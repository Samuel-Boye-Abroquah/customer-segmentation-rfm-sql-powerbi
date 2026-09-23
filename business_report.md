# Customer Segmentation: Business Findings & Recommendations

**Prepared by:** Samuel Boye Abroquah
**Basis:** RFM + Lifespan segmentation of 18,484 customers and $29.36M of revenue
**Audience:** Commercial, marketing and executive leadership
**Companion documents:** [methodology](methodology.md) · Power BI dashboard (Executive Overview, Segment Deep-Dive)

---

## 1. Executive summary

The customer base is small at the top and thin at the bottom. A third of customers produce three-quarters of revenue, and more than half of the base has bought about once and has been quiet for around seven months.

**Five headline findings**

1. **Revenue is concentrated.** VIP and Regular customers are 32% of the base and 74% of revenue. Losing a small share of them costs more than any other risk in the data.
2. **Even the best customers are not very recent.** VIP customers last ordered 93 days ago on average, and Regular customers 168 days ago. Core revenue is already drifting toward inactivity.
3. **The majority of customers have bought about once.** The three lowest segments (Needs Attention, Hibernating, Churn) hold 57.5% of customers, average about one order each, and carry only 18.6% of revenue.
4. **Repeat purchasing is what creates value.** Average revenue per customer rises from about $530 to about $3,900 as the frequency score rises from 1 to 5, while it barely moves across recency scores.
5. **Churn is not a volume problem.** The 258 customers in the Churn segment average $20 each. The commercial issue is missed second purchases, not lost regulars.

**Five priorities**

| # | Priority | Why |
|---|----------|-----|
| 1 | Protect VIP and Regular customers with proactive, personal outreach | $21.83M (74%) of revenue |
| 2 | Convert one-time buyers into repeat buyers, starting with Needs Attention | Largest pool of recoverable value per customer contacted |
| 3 | Move Promising customers to a second and third order quickly | Already ~6 months since last order on average |
| 4 | Put Hibernating customers on low-cost automation | Low value per customer ($263) |
| 5 | Stop paid spend on Churn | $20 average lifetime value |

---

## 2. How to read this report

- **Segments** come from a score of 1–5 on four dimensions (how recently, how often, how much, and over what span a customer bought), summed to a total from 4 to 20. Six segments follow from that total. See the methodology document for detail.
- **Revenue figures are cumulative** over the full period covered by the dataset, not annual. Percentages of total are the safest numbers to compare. Dollar figures in Section 7 are sized on the same basis.
- **"Days since last order"** is measured from the latest order in the dataset, not from today.
- **Cost and margin data were not available.** Revenue is not profit, and all "return" statements below are directional until campaign cost is known.

---

## 3. Segment scorecard

| Segment | Customers | % of base | Revenue | % of revenue | Avg revenue / customer | Avg orders | Avg days since last order | Concentration index* |
|---------|----------:|----------:|--------:|-------------:|-----------------------:|-----------:|--------------------------:|---------------------:|
| VIP | 2,210 | 12.0% | $10.99M | 37.4% | $4,974 | 2.5 | 93 | 3.1× |
| Regular | 3,708 | 20.1% | $10.84M | 36.9% | $2,923 | 2.3 | 168 | 1.8× |
| Promising | 1,930 | 10.4% | $2.06M | 7.0% | $1,067 | 1.5 | 192 | 0.7× |
| Needs Attention | 4,724 | 25.6% | $3.97M | 13.5% | $841 | 1.0 | 202 | 0.5× |
| Hibernating | 5,654 | 30.6% | $1.49M | 5.1% | $263 | 1.0 | 223 | 0.2× |
| Churn | 258 | 1.4% | $0.005M | ~0% | $20 | 1.0 | 326 | ~0× |
| **Total** | **18,484** | **100%** | **$29.36M** | **100%** | **$1,588** | **1.5** | **189** | 1.0× |

\*Concentration index = share of revenue ÷ share of customers. Above 1× means the segment earns more than its headcount would suggest.

**Approximate value per order** (average revenue ÷ average orders; approximate because orders are rounded): VIP ≈ $1,990, Regular ≈ $1,270, Needs Attention ≈ $840, Promising ≈ $710, Hibernating ≈ $260, Churn ≈ $20.

**Reading the table**

- VIP customers are valuable because they place large orders (about $1,990 each) and order more than once, not because they order very often.
- Needs Attention customers have an average order of about $840 and placed one. They were worth winning, and were not converted into repeat customers.

---

## 4. Findings in detail

### Finding 1: Revenue depends on a third of the customer base

VIP (12% of customers) generate 37.4% of revenue, a 3.1× concentration. Adding Regular customers, 32% of customers generate 74% of revenue. The bottom 68% of customers share the remaining 26%.

*Implication:* the business is exposed to the behaviour of roughly 5,900 customers. A 5% erosion of VIP and Regular revenue would remove about $1.09M, or 3.7% of all revenue.

### Finding 2: The core customers are already going quiet

The average VIP customer last ordered 93 days ago and the average Regular customer 168 days ago. The base-wide average is 189 days.

*Implication:* many core customers are past three months without an order. Whether this signals risk depends on how often customers normally buy (see Section 9). If the normal cycle is shorter than these gaps, revenue is at risk now; if it is longer, the priority is to time outreach to the cycle.

### Finding 3: The base is mostly one-time buyers

Needs Attention, Hibernating and Churn together are 10,636 customers (57.5%). Each averages about one order and last ordered 202 to 326 days ago.

*Implication:* the business likely relies on a steady flow of first-time buyers to hold revenue up. Each first-time buyer who does not return is a lost acquisition cost.

### Finding 4: Frequency, not recency, separates valuable customers

In the recency × frequency view, average revenue per customer is:

| Frequency score | 1 | 2 | 3 | 4 | 5 |
|---|---:|---:|---:|---:|---:|
| Avg revenue per customer | $532 | $443 | $715 | $2,339 | $3,913 |

Across recency scores 1 to 5, the equivalent range is about $1,430 to $1,700, which is flat.

*Implication:* how recently someone bought predicts little about value; whether they buy repeatedly predicts a lot. Part of this is arithmetic (more orders means more revenue), so it should be tested through a pilot before it is treated as cause and effect.

### Finding 5: The value gap between segments is steep and orderly

Average revenue per customer falls without interruption from $4,974 (VIP) to $2,923, $1,067, $841, $263 and $20. A VIP customer is worth about 250 Churn customers.

*Implication:* retention effort should be scaled by segment. Equal treatment overspends on low-value customers and underspends on high-value ones.

### Finding 6: Churn is small and cheap to lose

The 258 Churn customers (1.4% of the base) contribute about $5,000 in total. They scored the minimum on every dimension.

*Implication:* do not build campaigns around them. Their presence is not evidence of large-scale attrition.

### Finding 7: Segment mix looks similar across age groups (to be verified)

The Segment Deep-Dive page shows a broadly similar segment mix in each age band. If confirmed with exact figures, age is a weak targeting lever and behaviour is the better guide.

---

## 5. Segment playbook

Investment intensity: **High** = personal, proactive contact. **Medium** = targeted campaigns. **Low** = automated. **None** = no paid spend.

### VIP: protect (High)
**Contribution:** 12.0% of customers, 37.4% of revenue, $4,974 per customer.
**Position:** highest value, large orders, average 2.5 orders, 93 days since last order.
**Risks:** loss of a single VIP is expensive; average silence is already over three months.
**Actions**
- Assign a named owner or account contact to each VIP, with a recurring check-in.
- Trigger outreach when a VIP passes the point where their own purchase rhythm suggests a reorder is due.
- Offer priority service, early access and recognition rather than blanket discounts. These customers already buy, so discounts mostly give away margin.
- Review complaints, returns and delivery problems for this group weekly.
**Watch:** VIP revenue share, VIP average days since last order, number of VIPs slipping to Regular.

### Regular: grow (High to Medium)
**Contribution:** 20.1% of customers, 36.9% of revenue, $2,923 per customer.
**Position:** the second engine of revenue, and the main source of future VIPs. Average 168 days since last order.
**Risks:** longer silence than VIP; a slide into Needs Attention would cost about $2,000 per customer.
**Actions**
- Run cross-sell and upsell offers based on what each customer bought before.
- Use a "next order" prompt at 60 to 90 days after purchase.
- Create a clear path to VIP: a spend or order-count threshold that unlocks visible benefits.
**Watch:** Regular to VIP migration rate, Regular to Needs Attention slippage.

### Promising: accelerate (Medium)
**Contribution:** 10.4% of customers, 7.0% of revenue, $1,067 per customer.
**Position:** average 1.5 orders, but already about 192 days since last order, so "promising" is time-limited.
**Risks:** without a prompt second or third order, this group drifts into Needs Attention.
**Actions**
- Send a well-timed follow-up after the most recent order, with a reason to reorder (replenishment, complementary product, service).
- Use bundles or reorder incentives that reward a second and third purchase.
- Gather feedback from a sample to learn what would prompt the next order.
**Watch:** share of Promising customers who place another order within 90 days.

### Needs Attention: recover (Medium, main win-back focus)
**Contribution:** 25.6% of customers, 13.5% of revenue, $841 per customer.
**Position:** the largest pool of meaningful value outside the top segments; about one order each at roughly $840 per order; 202 days since last order.
**Risks:** each month of inactivity reduces the chance of a second purchase.
**Actions**
- Prioritise this group for a structured second-purchase campaign: personalised message, relevant product, clear reason to return.
- Test two or three offer types on small samples before scaling (for example, service or convenience benefit versus a modest incentive).
- Segment within the group by raw recency (most recent first), because the recently active are most likely to respond.
**Watch:** reactivation rate, revenue per customer contacted, cost per reactivated customer.

### Hibernating: automate (Low)
**Contribution:** 30.6% of customers, 5.1% of revenue, $263 per customer.
**Position:** the biggest segment by headcount and low in value; about one order; 223 days since last order.
**Risks:** heavy spend here is unlikely to be repaid.
**Actions**
- Place in an automated, low-cost re-engagement sequence (email or messaging, two or three touches).
- Suppress customers who do not respond after the sequence, to protect list quality and reduce cost.
- Use responders as a feeder into Needs Attention-style treatment.
**Watch:** response rate, cost per response, share moved into a higher segment.

### Churn: release (None)
**Contribution:** 1.4% of customers, about 0% of revenue, $20 per customer.
**Actions**
- Exclude from paid campaigns.
- Keep on passive channels only (for example, general newsletters) if permitted.
- Review whether a specific product or channel is producing these low-value one-off customers, because that is the useful learning here.
**Watch:** size of the segment over time; a sudden increase would point to an acquisition-quality issue.

---

## 6. Where the revenue and the risk sit

| Group | % of customers | % of revenue | Business stance |
|-------|---------------:|-------------:|-----------------|
| Core (VIP + Regular) | 32.0% | 74.3% | Protect and grow |
| Development (Promising) | 10.4% | 7.0% | Accelerate to repeat purchase |
| At risk (Needs Attention + Hibernating) | 56.1% | 18.6% ($5.46M) | Recover selectively |
| Release (Churn) | 1.4% | ~0% | Stop spend |

Two points guide budget decisions:

- The **core** carries the most revenue at stake per customer contacted, so it justifies the most attention per head.
- The **at-risk** group is where the largest number of customers can be recovered, but at a much lower value per customer. This calls for testing and automation before any large spend.

---

## 7. Sizing the opportunity (illustrative)

The figures below apply simple assumptions to the current segment values. They are **not forecasts**. Replace the assumptions with results from small pilots as soon as they are available.

| Lever | Assumption | Approximate revenue effect | % of total revenue |
|-------|------------|---------------------------:|-------------------:|
| Needs Attention: second purchase | 10% place one more order at about $841 | +$0.40M | 1.4% |
| Hibernating: reactivation | 5% place one more order at about $263 | +$0.07M | 0.3% |
| Promising to Regular | 10% reach Regular-level value (gap ≈ $1,856 each) | +$0.36M | 1.2% |
| Regular to VIP | 5% reach VIP-level value (gap ≈ $2,051 each) | +$0.38M | 1.3% |
| **Total upside** | | **≈ +$1.21M** | **≈ 4.1%** |
| **Downside to avoid** | 5% erosion of VIP + Regular revenue | **−$1.09M** | **−3.7%** |

**What this shows**

- A 5% slip in core revenue costs more than twice what the whole win-back effort (Needs Attention + Hibernating, about $0.47M) could plausibly recover. Retention of the core comes first.
- The upside from moving customers up a segment is about as large as win-back, and the customers involved are already engaged.
- The gaps between segments are differences between groups, not proven effects of any campaign. Treat the migration figures as upper bounds until tested.

---

## 8. Keeping the business stable

### 8.1 Principles

1. **Defend the core first.** About three-quarters of revenue sits with about a third of customers.
2. **Turn first orders into second orders.** More than half the base stops after roughly one order, so the second purchase is the most valuable step to fix.
3. **Match effort to value.** Personal contact for VIP and Regular, targeted offers for Promising and Needs Attention, automation for Hibernating, nothing for Churn.
4. **Measure before scaling.** Pilot every campaign on a sample with a control group.

### 8.2 Early-warning indicators

| Indicator | Why it matters | Review frequency |
|-----------|----------------|------------------|
| VIP + Regular share of revenue | Concentration and stability of the core | Monthly |
| Average days since last order, VIP and Regular | Early sign of core drift | Monthly |
| Number of customers moving down a segment | Attrition inside the core | Monthly |
| Repeat buyer rate (share of customers with 2+ orders) | Health of the second purchase | Monthly |
| Second-order conversion within 90 days of first order | Quality of onboarding and follow-up | Monthly |
| At-risk share of customers and revenue | Size of the recovery pool | Quarterly |
| Reactivation rate and cost per reactivated customer | Campaign return | Per campaign |

The segmentation view recalculates on each refresh and does not keep history. To measure movement between segments, save a dated snapshot of the view every month (a simple table with customer key, segment and score). This is the single most useful addition to the data process.

### 8.3 Operating rhythm

- **Monthly:** refresh the model, review the indicators above, and list VIP and Regular customers past their expected reorder point.
- **Quarterly:** review segment movement, campaign results and budget by segment.
- **Twice a year:** recheck the score thresholds using the total score histogram, especially after any large change in customer mix.

### 8.4 Risk register

| Risk | Likelihood / impact | Response |
|------|---------------------|----------|
| Loss or slowdown of VIP / Regular customers | Impact high | Personal outreach, service monitoring, early-warning indicator |
| Dependence on continued first-time buyers | Impact medium to high | Second-order programme, acquisition quality review |
| Spending on low-value segments | Impact medium | Tiered investment, suppression rules |
| Misreading "inactive" as "lost" in a long purchase cycle | Impact medium | Calibrate thresholds to the real purchase interval |
| Data gaps (no cost, channel or product detail) | Impact medium | Add fields, see Section 9 |

---

## 9. Assumptions, limitations and data needed

**Limitations to keep in mind**

- **Purchase cycle is unknown.** "Days since last order" only signals risk relative to how often customers normally buy. If the products are durable or bought infrequently, a 190-day gap may be normal. Measure the typical time between orders and adjust what counts as at risk.
- **Score boundaries are approximate for one-time buyers.** The scoring method splits customers with identical order counts across adjacent scores using a tie-break rule. Segment averages and revenue shares remain valid descriptions of the groups, but which individual one-time buyer lands in Needs Attention versus Hibernating is partly arbitrary. **Before running a campaign, select customers by their actual recency, order count and spend, not by segment name alone.**
- **Revenue is not profit.** Some high-revenue customers may be low margin.
- **No acquisition or channel data.** It is not possible to separate customers who joined organically from those who were acquired through paid channels.
- **Cumulative period.** Dollar values cover the full dataset period, so annual impact needs the period length.

**Data that would most improve the analysis**

1. Product cost or margin, to rank segments by profit.
2. Acquisition channel and date, to link first orders to acquisition cost.
3. Typical inter-order interval by product category.
4. Campaign contact cost, to calculate real return on win-back.
5. Monthly snapshots of segments, to track migration.

---

## 10. 30 / 60 / 90-day action plan

**Days 0–30: Foundation**
- Agree the segment definitions and owners for each segment.
- Start monthly snapshots of the segment view.
- Measure the typical time between orders and set reorder-due rules.
- Build the VIP and Regular watch list (customers past their expected reorder point).
- Fix and confirm the repeat buyer metric so it reflects real order counts.

**Days 31–60: Pilot**
- Begin personal outreach to VIP and high-value Regular customers.
- Launch second-purchase pilots on Needs Attention with a control group, testing two offer types.
- Launch a follow-up sequence for Promising customers.
- Set up the automated Hibernating re-engagement flow.

**Days 61–90: Measure and scale**
- Compare pilot results against control groups and calculate cost per reactivated customer.
- Scale the offers that work; stop those that do not.
- Set targets for repeat buyer rate, second-order conversion and core revenue share, using the baselines measured in the first 30 days.
- Report results to leadership using the dashboard and the indicators in Section 8.2.

---

## 11. Conclusion

The business's strength is a loyal core of about 5,900 customers who produce roughly three-quarters of revenue. Its weakness is that most other customers stop after about one purchase. Protecting the core, converting one-time buyers into repeat buyers, and matching spend to segment value give the strongest and lowest-risk route to steady revenue. Every recommendation here should be tested on a small group first, with cost measured, before it is scaled.

---

*Segment definitions:* VIP 18–20, Regular 15–17, Promising 13–14, Needs Attention 10–12, Hibernating 5–9, Churn 4 (total score from four 1–5 scores: recency, frequency, monetary value, lifespan).
