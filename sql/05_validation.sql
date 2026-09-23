/* =====================================================================
   Validation:  rfm_customer_segments
   Purpose:     Confirm the view produces correct, consistent results
   Run After:   04_rfm_segmentation_view.sql
   ===================================================================== */

USE customer_rfm;

-- ---------------------------------------------------------------------
-- 1. Row count — one row per customer
-- ---------------------------------------------------------------------
SELECT 'Row Count' AS check_name;
SELECT COUNT(*) AS total_customers
FROM rfm_customer_segments;


-- ---------------------------------------------------------------------
-- 2. Duplicates — customer_key should be unique
-- ---------------------------------------------------------------------
SELECT 'Duplicate Customers (expect 0)' AS check_name;
SELECT customer_key, COUNT(*) AS occurrences
FROM rfm_customer_segments
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- ---------------------------------------------------------------------
-- 3. Score ranges — dimensions 1-5, total 4-20
-- ---------------------------------------------------------------------
SELECT 'Score Ranges' AS check_name;
SELECT 
    MIN(m_score) AS min_m, MAX(m_score) AS max_m,
    MIN(f_score) AS min_f, MAX(f_score) AS max_f,
    MIN(l_score) AS min_l, MAX(l_score) AS max_l,
    MIN(r_score) AS min_r, MAX(r_score) AS max_r,
    MIN(total_score) AS min_total, MAX(total_score) AS max_total
FROM rfm_customer_segments;


-- ---------------------------------------------------------------------
-- 4. NULL scores — must be zero
-- ---------------------------------------------------------------------
SELECT 'NULL Scores (expect 0)' AS check_name;
SELECT COUNT(*) AS null_scores
FROM rfm_customer_segments
WHERE m_score IS NULL
   OR f_score IS NULL
   OR l_score IS NULL
   OR r_score IS NULL
   OR total_score IS NULL;


-- ---------------------------------------------------------------------
-- 5. Segment distribution — all 6 segments populated
-- ---------------------------------------------------------------------
SELECT 'Segment Distribution' AS check_name;
SELECT 
    customer_segmentation,
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM rfm_customer_segments), 2) AS pct,
    ROUND(AVG(monetary), 0) AS avg_monetary,
    ROUND(AVG(recency_days), 0) AS avg_recency_days
FROM rfm_customer_segments
GROUP BY customer_segmentation
ORDER BY avg_monetary DESC;


-- ---------------------------------------------------------------------
-- 6. Score direction — top spenders should have m_score = 5
-- ---------------------------------------------------------------------
SELECT 'Score Direction' AS check_name;
SELECT full_name, monetary, m_score, recency_days, r_score
FROM rfm_customer_segments
ORDER BY monetary DESC
LIMIT 5;


-- ---------------------------------------------------------------------
-- 7. Age bracket distribution
-- ---------------------------------------------------------------------
SELECT 'Age Brackets' AS check_name;
SELECT 
    age_bracket,
    COUNT(*) AS customers
FROM rfm_customer_segments
GROUP BY age_bracket
ORDER BY customers DESC;


-- ---------------------------------------------------------------------
-- 8. Revenue reconciliation — view total matches fact_sales total
-- ---------------------------------------------------------------------
SELECT 'Revenue Reconciliation' AS check_name;
SELECT 
    (SELECT ROUND(SUM(sales), 2) FROM fact_sales)               AS fact_sales_total,
    (SELECT ROUND(SUM(monetary), 2) FROM rfm_customer_segments) AS view_total,
    (SELECT ROUND(SUM(sales), 2) FROM fact_sales) 
        - (SELECT ROUND(SUM(monetary), 2) FROM rfm_customer_segments) AS difference;
