-- ============================================================
-- Bank Marketing Campaign Analysis
-- Analyst: Vinup | Date: June 2026
-- ============================================================

USE bank_marketing;

-- ============================================================
-- Q1 · BASELINE PERFORMANCE
-- ============================================================

-- 1.1 Overall conversion rate
SELECT
    COUNT(*)                                            AS total_contacts,
    SUM(subscribed_num)                                 AS total_subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns;

-- 1.2 Conversion rate by month (ordered chronologically)
SELECT
    month,
    COUNT(*)                                            AS total_contacts,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
GROUP BY month
ORDER BY
    FIELD(month,'mar','apr','may','jun','jul',
               'aug','sep','oct','nov','dec');

-- 1.3 Conversion rate by day of week
SELECT
    day_of_week,
    COUNT(*)                                            AS total_contacts,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
GROUP BY day_of_week
ORDER BY
    FIELD(day_of_week,'mon','tue','wed','thu','fri');

-- 1.4 Best performing month + day combination
SELECT
    month,
    day_of_week,
    COUNT(*)                                            AS total_contacts,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
GROUP BY month, day_of_week
HAVING total_contacts > 100
ORDER BY conversion_rate_pct DESC
LIMIT 10;

-- ============================================================
-- Q2 · CHANNEL EFFECTIVENESS
-- ============================================================

-- 2.1 Conversion rate by contact channel
SELECT
    contact                                             AS channel,
    COUNT(*)                                            AS total_contacts,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct,
    ROUND(AVG(duration_min), 2)                         AS avg_call_duration_min
FROM campaigns
GROUP BY contact
ORDER BY conversion_rate_pct DESC;

-- 2.2 Call duration comparison: subscribers vs non-subscribers by channel
SELECT
    contact                                             AS channel,
    subscribed,
    ROUND(AVG(duration_min), 2)                         AS avg_duration_min,
    ROUND(MIN(duration_min), 2)                         AS min_duration_min,
    ROUND(MAX(duration_min), 2)                         AS max_duration_min,
    COUNT(*)                                            AS total_contacts
FROM campaigns
GROUP BY contact, subscribed
ORDER BY contact, subscribed;

-- 2.3 Contact efficiency: subscriptions per campaign contact made
SELECT
    contact                                             AS channel,
    campaign                                            AS num_contacts_made,
    COUNT(*)                                            AS customers,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
GROUP BY contact, campaign
HAVING customers > 50
ORDER BY contact, num_contacts_made;

-- ============================================================
-- Q3 · CUSTOMER SEGMENTATION
-- ============================================================

-- 3.1 Conversion rate by age group
SELECT
    age_group,
    COUNT(*)                                            AS total_contacts,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
GROUP BY age_group
ORDER BY FIELD(age_group,'18–30','31–40','41–50','51–60','60+');

-- 3.2 Conversion rate by job type (sorted best to worst)
SELECT
    job,
    COUNT(*)                                            AS total_contacts,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
WHERE job IS NOT NULL
GROUP BY job
ORDER BY conversion_rate_pct DESC;

-- 3.3 Conversion rate by education level
SELECT
    education,
    COUNT(*)                                            AS total_contacts,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
WHERE education IS NOT NULL
GROUP BY education
ORDER BY conversion_rate_pct DESC;

-- 3.4 High value segment identification
-- Customers with above average conversion: which job + age group combos perform best?
SELECT
    job,
    age_group,
    COUNT(*)                                            AS total_contacts,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
WHERE job IS NOT NULL
GROUP BY job, age_group
HAVING total_contacts > 50
   AND conversion_rate_pct > (
       SELECT AVG(subscribed_num) * 100
       FROM campaigns
   )
ORDER BY conversion_rate_pct DESC
LIMIT 10;

-- 3.5 Over-contacted low conversion segments (wasted spend)
-- Segments receiving many contacts but converting poorly
SELECT
    job,
    age_group,
    ROUND(AVG(campaign), 1)                             AS avg_contacts_made,
    COUNT(*)                                            AS total_customers,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
WHERE job IS NOT NULL
GROUP BY job, age_group
HAVING total_customers > 100
   AND conversion_rate_pct < (
       SELECT AVG(subscribed_num) * 100
       FROM campaigns
   )
ORDER BY avg_contacts_made DESC
LIMIT 10;

-- ============================================================
-- Q4 · PREVIOUS CAMPAIGN IMPACT
-- ============================================================

-- 4.1 Conversion rate: previously contacted vs new customers
SELECT
    prev_contacted,
    COUNT(*)                                            AS total_customers,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
GROUP BY prev_contacted
ORDER BY conversion_rate_pct DESC;

-- 4.2 Conversion rate by previous campaign outcome
SELECT
    poutcome                                            AS previous_outcome,
    COUNT(*)                                            AS total_customers,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
WHERE poutcome IS NOT NULL
GROUP BY poutcome
ORDER BY conversion_rate_pct DESC;

-- 4.3 Deep dive: previously successful customers by channel
-- Do previously successful customers convert better on cellular too?
SELECT
    poutcome                                            AS previous_outcome,
    contact                                             AS channel,
    COUNT(*)                                            AS total_customers,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
WHERE poutcome IS NOT NULL
GROUP BY poutcome, contact
ORDER BY conversion_rate_pct DESC;

-- ============================================================
-- Q5 · BUDGET RECOMMENDATION
-- ============================================================

-- 5.1 Diminishing returns: conversion rate by number of contacts made
SELECT
    campaign                                            AS contacts_made,
    COUNT(*)                                            AS customers,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
GROUP BY campaign
HAVING customers > 100
ORDER BY contacts_made;

-- 5.2 Optimal contact window: where does conversion drop below average?
SELECT
    campaign                                            AS contacts_made,
    COUNT(*)                                            AS customers,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct,
    CASE
        WHEN AVG(subscribed_num) * 100 >= (SELECT AVG(subscribed_num)*100 FROM campaigns)
        THEN 'Above average — worth contacting'
        ELSE 'Below average — wasted spend'
    END                                                 AS efficiency_flag
FROM campaigns
GROUP BY campaign
HAVING customers > 100
ORDER BY contacts_made;

-- 5.3 Budget recommendation summary
-- Best channel + best month + best segment combined
SELECT
    contact                                             AS best_channel,
    month                                               AS best_month,
    job                                                 AS best_job_segment,
    age_group                                           AS best_age_group,
    COUNT(*)                                            AS total_contacts,
    SUM(subscribed_num)                                 AS subscriptions,
    ROUND(AVG(subscribed_num) * 100, 2)                 AS conversion_rate_pct
FROM campaigns
WHERE poutcome = 'success'
   OR month IN ('mar','sep','oct','dec')
GROUP BY contact, month, job, age_group
HAVING total_contacts > 30
ORDER BY conversion_rate_pct DESC
LIMIT 15;