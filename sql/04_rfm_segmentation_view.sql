/* =====================================================================
   View:      rfm_customer_segments
   Purpose:   Score every customer on Recency, Frequency, Monetary value
              and Lifespan, then assign an actionable marketing segment.

   Inputs:    fact_sales     (order_number, order_date, sales, customer_key)
              dim_customers  (customer_key, first_name, last_name, gender,
                              marital_status, country, birth_date)

   Requires:  MySQL 8.0+ (window functions)

   Method:    1. Aggregate metrics per customer
              2. Score each metric 1-5 with NTILE (5 = best)
              3. Sum the four scores (range 4-20)
              4. Map the total score to a segment:
                 VIP 18-20 | Regular 15-17 | Promising 13-14 |
                 Needs Attention 10-12 | Hibernating 5-9 | Churn 4

   Notes:     - "Today" is the latest order date in the dataset, not
                CURDATE(), so results are reproducible.
              - customer_key is used as a tie-breaker inside NTILE so
                scores are deterministic between runs.
   ===================================================================== */

CREATE OR REPLACE VIEW rfm_customer_segments AS

-- Reference date: last order in the dataset
WITH ref AS (
    SELECT MAX(order_date) AS ref_date
    FROM fact_sales
),

-- Step 1: one row per customer with raw RFM + lifespan metrics
customer_metrics AS (
    SELECT
        c.customer_key,
        CONCAT_WS(' ', c.first_name, c.last_name)                 AS full_name,
        c.gender,
        c.marital_status,
        c.country,
        TIMESTAMPDIFF(YEAR, c.birth_date, r.ref_date)             AS age,
        TIMESTAMPDIFF(DAY, MIN(f.order_date), MAX(f.order_date))  AS life_span_days,
        TIMESTAMPDIFF(DAY, MAX(f.order_date), r.ref_date)         AS recency_days,
        SUM(f.sales)                                              AS monetary,
        COUNT(DISTINCT f.order_number)                            AS frequency
    FROM fact_sales AS f
    JOIN dim_customers AS c
        ON f.customer_key = c.customer_key
    CROSS JOIN ref AS r
    GROUP BY
        c.customer_key,
        c.first_name,
        c.last_name,
        c.gender,
        c.marital_status,
        c.country,
        c.birth_date,
        r.ref_date
),

-- Step 2: age bracket + quintile scores (5 = best)
scores AS (
    SELECT
        *,
        CASE
            WHEN age IS NULL THEN 'Unknown'
            WHEN age >= 60   THEN '60 and Above'
            WHEN age >= 40   THEN '40 to 59'
            ELSE 'Below 40'
        END AS age_bracket,
        NTILE(5) OVER (ORDER BY monetary,             customer_key) AS m_score,
        NTILE(5) OVER (ORDER BY frequency,            customer_key) AS f_score,
        NTILE(5) OVER (ORDER BY life_span_days,       customer_key) AS l_score,
        -- Recency is reversed: more days since last order = lower score
        NTILE(5) OVER (ORDER BY recency_days DESC,    customer_key) AS r_score
    FROM customer_metrics
),

-- Step 3: combined score (min 4, max 20)
total_scores AS (
    SELECT
        *,
        m_score + f_score + l_score + r_score AS total_score
    FROM scores
)

-- Step 4: segment assignment
SELECT
    customer_key,
    full_name,
    gender,
    marital_status,
    country,
    age_bracket,
    monetary,
    frequency,
    recency_days,
    life_span_days,
    m_score,
    f_score,
    l_score,
    r_score,
    total_score,
    CASE
        WHEN total_score >= 18 THEN 'VIP'
        WHEN total_score >= 15 THEN 'Regular'
        WHEN total_score >= 13 THEN 'Promising'
        WHEN total_score >= 10 THEN 'Needs Attention'
        WHEN total_score >= 5  THEN 'Hibernating'
        ELSE 'Churn'
    END AS customer_segmentation
FROM total_scores;
