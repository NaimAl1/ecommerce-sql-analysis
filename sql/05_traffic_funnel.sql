# 1.) Which traffic sources drive the most conversions and revenue?
SELECT 
	-- Identify the marketing channel (e.g., Organic Search, Paid Ads, Social)
	mql.origin,
    -- Total number of Marketing Qualified Leads (Top of Funnel)
    COUNT(mql.mql_id) AS total_leads,
	-- Total number of deals that successfully signed (Bottom of Funnel)
    COUNT(cd.mql_id) AS closed_deals,
    -- Lead-to-Deal Conversion Rate: measures the quality of leads from each source
    ROUND(COUNT(cd.mql_id) * 100.0 / COUNT(mql.mql_id), 2) AS conversion_rate,
    -- Forecasted revenue gain from these specific conversions
    SUM(cd.declared_monthly_revenue) AS potential_monthly_revenue 
FROM marketing_qualified_leads mql
-- Join to filter which leads actually resulted in a business win
LEFT JOIN closed_deals cd ON mql.mql_id	= cd.mql_id
WHERE mql.origin IS NOT NULL
GROUP BY mql.origin
ORDER BY closed_deals DESC;

# 2.) Where are users most likely to drop off in the funnel?
SELECT 
    mql.origin,
    COUNT(mql.mql_id) AS total_leads,
    -- Calculate "Lost" leads (Leads minus Closed Deals)
    COUNT(mql.mql_id) - COUNT(cd.mql_id) AS dropped_off_leads,
    -- Drop-off Rate: identifies which channels attract high-volume but low-intent users
    ROUND((COUNT(mql.mql_id) - COUNT(cd.mql_id)) * 100.0 / COUNT(mql.mql_id), 2) AS drop_off_rate
FROM marketing_qualified_leads mql
LEFT JOIN closed_deals cd ON mql.mql_id = cd.mql_id
GROUP BY mql.origin
ORDER BY drop_off_rate DESC;
