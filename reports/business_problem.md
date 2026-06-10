# Business Problem Document
## Bank Marketing Campaign ROI Analysis & Budget Optimisation

---

### Project Overview

A Portuguese retail bank conducted a series of direct marketing campaigns
to promote term deposit subscriptions among its existing customers.
Campaigns were executed via two contact channels — cellular and telephone —
across multiple months and involved repeated outreach to a subset of customers.

Despite sustained campaign efforts across 41,188 customer interactions,
the overall subscription rate stands at approximately 11.3%, indicating
significant room to improve targeting efficiency and channel allocation.

This project analyses campaign performance data to identify what worked,
what did not, and where the bank should focus its marketing budget in
future campaign cycles.

---

### Business Context

Term deposits are a core liability product for retail banks. Acquiring
term deposit customers is relatively low-cost compared to lending products,
but requires effective outreach and timing. Inefficient campaigns — too many
contacts, wrong channels, wrong customer segments — increase cost per
acquisition and damage customer experience through over-communication.

The bank's marketing team needs data-driven answers to optimise the next
campaign cycle.

---

### Stakeholders

| Stakeholder | Role | Interest in This Analysis |
|---|---|---|
| Head of Marketing | Primary decision-maker | Budget reallocation recommendations |
| Campaign Manager | Executes campaigns | Channel and timing insights |
| Customer Analytics Team | Data consumers | Segment profiles and response patterns |
| Finance Director | Budget approver | ROI justification for spend |

---

### Business Questions

The analysis is structured around five business questions that progress
from diagnostic to prescriptive:

**Q1 — Baseline performance**
What is the overall conversion rate of the campaign, and how does
conversion vary by month and day of week? Which time periods drove
the highest subscription rates?

**Q2 — Channel effectiveness**
Which contact channel — cellular or telephone — delivers a higher
conversion rate? Does call duration differ significantly between
the two channels, and what does that imply about contact quality?

**Q3 — Customer segmentation**
Which customer segments — defined by age group, job type, and
education level — show the highest propensity to subscribe?
Which segments are being over-contacted with poor returns?

**Q4 — Previous campaign impact (A/B comparison)**
Do customers who had a successful outcome in a previous campaign
(poutcome = success) convert at a statistically significantly
higher rate than customers with no prior contact? Is this
difference real or due to chance?

**Q5 — Budget recommendation**
Based on findings from Q1–Q4, which channel, time period, and
customer segment should receive the highest budget allocation
in the next campaign cycle? What is the projected improvement
in conversion rate if recommendations are followed?

---

### Success Metrics

| Metric | Definition | Target |
|---|---|---|
| Conversion Rate | % of contacts who subscribed | Identify top-performing segments above 20% |
| Contact Efficiency | Subscriptions per campaign contact | Maximise — reduce wasted touches |
| Channel Conversion Gap | Difference in conversion rate: cellular vs telephone | Quantify and recommend accordingly |
| Segment Response Rate | Conversion rate by job / age / education group | Identify top 3 segments |
| Statistical Significance | p-value of A/B test on previous campaign outcome | p < 0.05 required to act on findings |

---

### Scope & Limitations

**In scope:**
- All 41,188 customer interaction records
- Campaign period: March to December (multi-year data)
- Variables: customer demographics, contact channel, campaign history,
  economic indicators, subscription outcome

**Out of scope:**
- Actual monetary spend per contact (not available in dataset)
- Customer lifetime value post-subscription (no product usage data)
- Real-time or predictive modelling (this is a descriptive + inferential analysis)

**Key limitation:**
The dataset does not include direct cost data. Cost per acquisition (CPA)
will be proxied using number of contacts and call duration as effort
indicators — a standard approach when granular spend data is unavailable.

---

### Deliverables

| Deliverable | Tool | Location |
|---|---|---|
| Data Cleaning & EDA | Python (Pandas, Seaborn) | notebooks/01_data_cleaning_eda.ipynb |
| SQL Business Analysis | MySQL | sql/queries.sql |
| A/B Statistical Test | Python (SciPy) | notebooks/03_ab_testing.ipynb |
| Executive Dashboard | Power BI | dashboard/ |
| Project Report | PDF | reports/ |
| GitHub Repository | Markdown README | github.com |

---

*Document version: 1.0 | Analyst: [Your Name] | Date: June 2026*
