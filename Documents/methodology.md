# 📐 RFM + Lifespan Segmentation Methodology

## Overview

This project segments **18,484 customers** into **6 actionable tiers** using a four-dimension scoring model: **Recency**, **Frequency**, **Monetary value** and **Lifespan**.

Lifespan is added on top of classic RFM to capture how long a customer has been actively buying, not just how recently or how much.

The output feeds a two-page Power BI dashboard used to explain retention priorities and revenue at risk.

**Contents**
[The four dimensions](#the-four-dimensions) · [Scoring method](#scoring-method) · [Historical anchoring](#historical-data-anchoring) · [Segment mapping](#total-score--segment-mapping) · [Business value](#business-value) · [Known limitations](#known-limitations) · [Assumptions](#assumptions) · [Implementation](#implementation-reference)

---

## The four dimensions

### R — Recency
**Definition:** days between the customer's most recent order and the reference date.
**Why it matters:** recent buyers are more likely to buy again; long-dormant customers are at higher risk of lapsing for good.
**Scoring:** lower is better, so recent buyers score higher.

```sql
TIMESTAMPDIFF(DAY, MAX(f.order_date), r.ref_date) AS recency_days
```

| Range | Descriptive band |
|-------|------------------|
| 0–30 days | Hot |
| 31–90 days | Warm |
| 91–180 days | Cooling |
| 180+ days | Cold / at risk |

*Bands are for interpretation only; they are not used in scoring.*

### F — Frequency
**Definition:** number of distinct orders placed.
**Why `DISTINCT`:** an order can have several line items (rows). Counting rows would inflate frequency and make one-order customers look like repeat buyers.
**Scoring:** higher is better.

```sql
COUNT(DISTINCT f.order_number) AS frequency
```

| Orders | Descriptive band |
|--------|------------------|
| 1 | One-time buyer |
| 2–3 | Repeat |
| 4–9 | Loyal |
| 10+ | Champion |

### M — Monetary
**Definition:** total revenue contributed by the customer.
**Why it matters:** revenue is usually concentrated in a minority of customers.
**Scoring:** higher is better.

```sql
SUM(f.sales) AS monetary
```

### L — Lifespan (active span)
**Definition:** days between the customer's **first** and **last** order.
**Scoring:** higher is better.

```sql
TIMESTAMPDIFF(DAY, MIN(f.order_date), MAX(f.order_date)) AS life_span_days
```

**What this does and does not measure.** It measures how long a customer kept buying. It is *not* tenure (first order to reference date): a one-order customer has a lifespan of 0 days whether they joined three days or three years ago. Recency already captures how long ago that order was. Read L as "sustained buying", which is why it is closely related to Frequency for single-order customers.

---

## Scoring method

### NTILE(5) bucketing

Each dimension is scored 1–5 with `NTILE(5)`, which splits customers into five equal-sized groups by rank:

```sql
NTILE(5) OVER (ORDER BY monetary, customer_key) AS m_score
```

| Score | Position | Meaning |
|-------|----------|---------|
| 5 | Top 20% | Best on that dimension |
| 4 | 60–80th percentile | Above average |
| 3 | 40–60th percentile | Average |
| 2 | 20–40th percentile | Below average |
| 1 | Bottom 20% | Weakest |

### Why quintiles instead of deciles

Deciles were tested first. Quintiles were kept because they are the standard RFM convention, give a total score range (4–20) that is easy to explain, and produce segment sizes that are easy to read on a dashboard.

### Direction of scoring

| Dimension | ORDER BY | Rationale |
|-----------|----------|-----------|
| Monetary | ASC | higher spend → higher score |
| Frequency | ASC | more orders → higher score |
| Lifespan | ASC | longer active span → higher score |
| **Recency** | **DESC** | fewer days since last order → higher score |

⚠️ Recency is the only reversed dimension, because lower is better.

### Deterministic tie-breaking

Every `NTILE()` includes `customer_key` as a secondary sort key so that the same data always produces the same scores. That gives reporting stability across refreshes and results that can be reproduced and audited.

**The trade-off:** the tie-breaker is arbitrary. See [Known limitations](#known-limitations).

---

## Historical data anchoring

All date calculations use the **latest order date in the dataset** as the reference date, not `CURDATE()`:

```sql
CROSS JOIN (SELECT MAX(order_date) AS ref_date FROM fact_sales) AS r
```

The dataset is historical. With `CURDATE()`, every customer's recency would grow by one day each day, compressing the differences between active and dormant customers and changing results on every run. Anchoring to `MAX(order_date)` makes the output reproducible whenever it is executed.

---

## Total score → segment mapping

The four scores are summed (range 4–20):

```sql
total_score = m_score + f_score + l_score + r_score
```

| Segment | Score | Customers | % | Business meaning |
|---------|-------|-----------|---|------------------|
| 🏆 VIP | 18–20 | 2,210 | 12.0% | Highest value, most engaged. Protect. |
| ⭐ Regular | 15–17 | 3,708 | 20.1% | Consistent buyers. Nurture toward VIP. |
| 🌱 Promising | 13–14 | 1,930 | 10.4% | Growing. Invest in the journey. |
| ⚠️ Needs Attention | 10–12 | 4,724 | 25.6% | Slipping. Targeted re-activation. |
| 💤 Hibernating | 5–9 | 5,654 | 30.6% | Dormant. Low-cost win-back. |
| 🚫 Churn | 4 | 258 | 1.4% | Minimum on every dimension. |

**Thresholds** were set by inspecting the histogram of `total_score` (shown on the dashboard's Segment Deep-Dive page) so that every segment is populated and meaningful. They are judgement-based, not statistically derived. If the customer base changes materially, re-inspect the histogram and recalibrate.

**Sort order.** Segments are shown in business-priority order (VIP → Churn) using a `Segment Order` calculated column with *Sort by column* (see `powerbi/measure.dax`).

---

## Business value

| Question | How the model answers it |
|----------|--------------------------|
| Who are the best customers? | High total score (VIP) |
| Where is revenue concentrated? | Revenue % vs customer % by segment |
| Who is at risk? | Needs Attention + Hibernating |
| Who should be protected? | VIP and Regular |
| Who should be re-engaged? | Needs Attention first |
| How valuable is each group? | Avg revenue per customer by segment |

**Results on this dataset**

- VIP is 12.0% of customers and 37.4% of revenue.
- VIP + Regular is 32.0% of customers and about 74% of revenue.
- Needs Attention + Hibernating is 56.1% of customers and 18.6% of revenue ($5.46M).
- Average revenue per customer runs from $4,974 (VIP) to $20 (Churn), roughly 250×.
- Churn (258 customers) contributes about $5K in total.

---

## Known limitations

1. **Tie-splitting.** `NTILE` forces five equal-sized groups. Where many customers share the same raw value, and one-order customers are the clear example (average orders per customer is about 1.5), identical customers are placed in different buckets, ordered by `customer_key`. Consequences: (a) two customers with the same behaviour can receive different scores; (b) if `customer_key` is assigned chronologically, ties are resolved in favour of newer customers. The same applies to Lifespan, where one-order customers all have 0 days. Checks 10 and 11 in `sql/05_validation.sql` show how much this affects the data.
   - *Possible v2:* tie-safe scoring, e.g. `CEIL(5 * CUME_DIST() OVER (ORDER BY frequency))`, which gives equal values equal scores (at the cost of unequal group sizes), or fixed business thresholds for F and L (e.g. F: 1, 2, 3, 4–5, 6+).
2. **Score-based KPIs are partly artefacts.** Because `NTILE` forces ~20% into each score, "share of customers with f_score = 5" is always ≈20%. Use raw values (e.g. `frequency >= 2`) for KPIs such as Repeat Buyer Rate.
3. **Lifespan is active span, not tenure** (see above).
4. **No seasonality adjustment.** Seasonal buyers may look dormant off-season.
5. **Monetary is revenue, not profit.**
6. **No acquisition-channel or cost data**, so reactivation ROI is assumed, not measured.
7. **Static segments.** The view is recalculated on refresh, not in real time.

## Assumptions

1. `fact_sales.order_date` is accurate and complete.
2. `dim_customers` is the single source of truth for customer attributes.
3. Order lines with a customer missing from `dim_customers` are dropped by the inner join (validation check 9 confirms none).
4. Customers with no orders are not scored.
5. `customer_key` uniquely identifies a customer in both tables.

---

## Implementation reference

- SQL view: [`sql/04_rfm_segmentation_view.sql`](../sql/04_rfm_segmentation_view.sql)
- Validation: [`sql/05_validation.sql`](../sql/05_validation.sql)
- DAX: [`powerbi/measure.dax`](../powerbi/measure.dax)
- Techniques: `NTILE`, CTEs, `CROSS JOIN` for the reference date, `TIMESTAMPDIFF`, `COUNT(DISTINCT …)`, `CASE`
- Requires MySQL 8.0+ (window functions)

## Further reading

- Hughes, A. M. (1994). *Strategic Database Marketing*
- MySQL 8.0 reference: [window function descriptions](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html)
- Kimball & Ross (2013). *The Data Warehouse Toolkit*

---

**Author:** Samuel Boye Abroquah · **Last updated:** September 2026
