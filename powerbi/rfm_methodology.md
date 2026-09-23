# 📐 RFM + Lifespan Segmentation Methodology

## Overview

This project segments **18,484 customers** into **6 actionable tiers** using a 4-dimensional scoring model: **Recency**, **Frequency**, **Monetary value**, and **Lifespan**.

The approach extends the classic RFM framework by adding **Lifespan** as a fourth dimension — capturing customer tenure, which is critical for distinguishing long-term loyal customers from newly acquired ones with similar RFM scores.

The output powers a two-page Power BI executive dashboard used to drive retention strategy and revenue protection.

---

## 📑 Table of Contents

- [The Four Dimensions](#-the-four-dimensions)
- [Scoring Method](#-scoring-method)
- [Historical Data Anchoring](#-historical-data-anchoring)
- [Segment Mapping](#-total-score--segment-mapping)
- [Business Value](#-business-value)
- [Limitations & Assumptions](#-limitations--assumptions)
- [Implementation Reference](#-implementation-reference)

---

## 🎯 The Four Dimensions

### R — Recency

**Definition:** Number of days since the customer's most recent order.

**Why it matters:** Recent buyers are more likely to buy again. Long-dormant customers are at high risk of permanent churn.

**Calculation:**
```sql
TIMESTAMPDIFF(
    DAY, 
    MAX(order_date), 
    (SELECT MAX(order_date) FROM fact_sales)
) AS recency_days
```

**Scoring:** Lower is better — recent buyers get higher scores.

**Business interpretation:**

| Range | Status |
|-------|--------|
| 0–30 days | 🔥 Hot |
| 31–90 days | ☀️ Warm |
| 91–180 days | 🌤 Cooling |
| 180+ days | ❄️ Cold / At-Risk |

---

### F — Frequency

**Definition:** Number of distinct orders placed by the customer.

**Why it matters:** Repeat buyers demonstrate trust and habit. High-frequency customers are the foundation of predictable revenue.

**Calculation:**
```sql
COUNT(DISTINCT order_number) AS frequency
```

**Why `DISTINCT`:** An order may have multiple line items (rows). Counting rows would inflate frequency and misrepresent single-order customers as repeat buyers.

**Scoring:** Higher is better.

**Business interpretation:**

| Orders | Customer Type |
|--------|---------------|
| 1 | One-time buyer |
| 2–3 | Repeat customer |
| 4–9 | Loyal |
| 10+ | Champion |

---

### M — Monetary

**Definition:** Total revenue contributed by the customer.

**Why it matters:** Revenue concentration. A small percentage of customers often drives a disproportionate share of revenue — this is the Pareto principle in action.

**Calculation:**
```sql
SUM(sales) AS monetary
```

**Scoring:** Higher is better.

**Business interpretation:**

| Percentile | Spender Tier |
|-----------|--------------|
| Top 10% | VIP-tier spenders |
| Middle 80% | Core revenue base |
| Bottom 10% | Low-value or trial customers |

---

### L — Lifespan

**Definition:** Number of days between the customer's first order and the reference date (latest order in the dataset).

**Why it matters:** Distinguishes loyal long-term customers from newly acquired ones. A customer with 1 order but 3 years of tenure tells a different story than a customer with 1 order and 3 days of tenure.

**Calculation:**
```sql
TIMESTAMPDIFF(
    DAY, 
    MIN(order_date), 
    (SELECT MAX(order_date) FROM fact_sales)
) AS life_span_days
```

**Scoring:** Higher is better.

**Business interpretation:**

| Tenure | Stage |
|--------|-------|
| 0–30 days | New |
| 31–180 days | Establishing |
| 181–365 days | Committed |
| 365+ days | Long-term |

---

## 🎯 Scoring Method

### NTILE(5) — Percentile Bucketing

Each dimension is scored from **1 to 5** using the `NTILE()` window function:

```sql
NTILE(5) OVER (ORDER BY monetary, customer_key) AS m_score
```

This divides customers into 5 roughly equal groups (quintiles) based on the metric.

| Score | Meaning | Population Share |
|-------|---------|------------------|
| 5 | Top 20% | Best on that dimension |
| 4 | 60–80th percentile | Above average |
| 3 | 40–60th percentile | Average |
| 2 | 20–40th percentile | Below average |
| 1 | Bottom 20% | Worst on that dimension |

### Why NTILE(5) Instead of NTILE(10)?

- **Better segment separation** — fewer customers land in "borderline" buckets
- **Simpler mental model** — total score range of 4–20 is easier to reason about than 4–40
- **More balanced population** — 5-quintile splits produce more even groups than 10-decile splits

### Direction of Scoring

| Dimension | ORDER BY | Rationale |
|-----------|----------|-----------|
| Monetary | `ASC` | Higher spend → higher score (5) |
| Frequency | `ASC` | More orders → higher score (5) |
| Lifespan | `ASC` | Longer tenure → higher score (5) |
| **Recency** | **`DESC`** | Fewer days since last order → higher score (5) |

⚠️ **Critical:** Recency uses `DESC` because **lower recency is better** (recently active). All other dimensions use `ASC` because higher is better.

### Deterministic Tie-Breaking

Every `NTILE()` call includes `customer_key` as a secondary sort:

```sql
NTILE(5) OVER (ORDER BY monetary, customer_key) AS m_score
```

**Why:** Without the tie-breaker, customers with identical monetary values would receive random scores on every run. This makes the model **deterministic and reproducible** — the same customer always gets the same score.

This is essential for:
- ✅ Reporting stability (same numbers across refreshes)
- ✅ Auditing (results are explainable)
- ✅ Trust (stakeholders see consistent segments)

---

## 🎯 Historical Data Anchoring

### Reference Date Logic

All date-based calculations use the **latest order date in the dataset** as the reference point — not `CURDATE()`.

```sql
CROSS JOIN (SELECT MAX(order_date) AS ref_date FROM fact_sales) AS r
```

### Why Not CURDATE()?

The dataset is **historical** (ends in 2025). Using `CURDATE()` would create two problems:

1. **Inflated recency:** Every customer would show ~200+ days of recency, destroying the ability to differentiate active vs dormant customers
2. **Non-reproducible results:** The segmentation would silently change every day as `CURDATE()` advances

### Reproducibility

By anchoring to `MAX(order_date)`, the model produces **identical results on every run** regardless of when it's executed. This makes the analysis auditable and suitable for periodic reporting.

**Result:** A customer scoring as "VIP" today will score as "VIP" next week, next month, and next year — as long as the underlying data doesn't change.

---

## 🎯 Total Score → Segment Mapping

The 4 dimension scores are summed into a **total score ranging from 4 to 20**:

```sql
total_score = m_score + f_score + l_score + r_score
```

| Segment | Score Range | Population | Business Meaning |
|---------|-------------|-----------|------------------|
| 🏆 **VIP** | 18–20 | ~12% | Highest value, most engaged. Protect at all costs. |
| ⭐ **Regular** | 15–17 | ~20% | Consistent buyers. Nurture toward VIP. |
| 🌱 **Promising** | 13–14 | ~10% | Growing customers. Invest in their journey. |
| ⚠️ **Needs Attention** | 10–12 | ~26% | Slipping engagement. Re-activate with targeted campaigns. |
| 💤 **Hibernating** | 5–9 | ~31% | Dormant. Win-back with strong offers. |
| 🚫 **Churn** | 4 | ~1% | Lost customers. Sunset or deep-discount reactivation. |

### Why These Thresholds?

The thresholds were **calibrated to the actual data distribution** — ensuring each segment is populated and business-meaningful. They are not arbitrary; they reflect natural breakpoints in the customer base.

If the customer base changes materially (e.g., major acquisition campaign, seasonal shift), thresholds should be **recalibrated** by inspecting the histogram of total_scores.

### Sort Order

Segments are sorted in **business priority order** (VIP → Churn), not alphabetically. This is enforced in Power BI using a calculated column:

```dax
Segment Order = 
SWITCH (
    rfm_customer_segments[customer_segmentation],
    "VIP", 1, "Regular", 2, "Promising", 3,
    "Needs Attention", 4, "Hibernating", 5, "Churn", 6,
    99
)
```

Then applied via **Sort by column** on `customer_segmentation`.

---

## 🎯 Business Value

### What This Methodology Enables

| Question | How RFM+L Answers It |
|----------|---------------------|
| Who are our best customers? | High total scores (VIP segment) |
| Where is revenue concentrated? | Monetary scores + segment aggregation |
| Who's at risk of churning? | Low recency + low frequency combinations |
| Which customers should we protect? | VIP segment with high monetary scores |
| Which customers should we re-engage? | Needs Attention + Hibernating segments |
| How valuable is each customer? | ARPC (Avg Revenue Per Customer) by segment |

### Quantified Insights From This Dataset

For this dataset:

- **VIP customers (12% of base)** drive **37.4% of revenue** — a **3.1× concentration lift**
- **At-Risk segments (56% of base)** represent **$5.46M in at-risk revenue**
- **ARPC ranges from $4,974 (VIP) to $20 (Churn)** — a **250× customer value disparity**
- **Churn segment (258 customers)** contributes just **$5,252** — effectively zero

These metrics directly inform:
- Retention budget allocation
- Campaign targeting priority
- Product roadmap focus
- Executive KPI reporting

---

## 🎯 Limitations & Assumptions

### Limitations

1. **No seasonality adjustment** — customers who buy seasonally may appear "dormant" in off-season months
2. **Monetary is not profit** — a high-spend customer with high product costs may not be the most profitable
3. **No acquisition channel data** — the model can't distinguish organic VIPs from paid-acquisition VIPs
4. **Static segments** — segments don't update in real-time; the view refreshes on demand

### Assumptions

1. `fact_sales.order_date` is accurate and complete
2. `dim_customers` is the single source of truth for customer attributes
3. Orders with `NULL` order_date are excluded (data quality)
4. Customers with no orders are excluded from segmentation (they can't be scored)
5. `customer_key` uniquely identifies each customer in both tables

---

## 🎯 Implementation Reference

### Full SQL View

See [`sql/04_rfm_segmentation_view.sql`](../sql/04_rfm_segmentation_view.sql) for the complete implementation.

### Key SQL Techniques Used

- **`NTILE(5)`** — Percentile bucketing
- **`CASE`** — Segment assignment
- **`CROSS JOIN`** — Reference date injection
- **CTEs (`WITH`)** — Modular query structure
- **`TIMESTAMPDIFF`** — Date arithmetic
- **`COUNT(DISTINCT ...)`** — Order-level frequency

### Database Requirements

- MySQL 8.0+ (window functions required)
- `utf8mb4` character set (international data)

### Power BI Integration

- Connects to `rfm_customer_segments` view via ODBC
- 13+ DAX measures (see [`powerbi/measures.dax`](../powerbi/measures.dax))
- Two-page dashboard: Executive Overview + Segment Deep-Dive
- Dynamic segment sorting via calculated column

---

## 🎯 Further Reading

- **RFM origins:** Hughes, A. M. (1994). *Strategic Database Marketing*
- **NTILE window function:** [MySQL 8.0 Reference](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html)
- **Kimball dimensional modeling:** Kimball & Ross (2013). *The Data Warehouse Toolkit*
- **Pareto principle in analytics:** Koch, R. (1998). *The 80/20 Principle*

---

**Last Updated:** September 2026  
**Author:** Samuel Boye Abroquah  
**Repository:** [customer-segmentation-rfm-sql-powerbi](https://github.com/Samuel-Boye-Abroquah/customer-segmentation-rfm-sql-powerbi)
