-- check table for cleaning a douplicate column was identified, dropped
select * from anes
alter table anes
drop column city

--Removing unnecessary column
select * from anes
alter table anes
drop column [part_time_or_not]

--checking table names
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'anes';

--renameing columns
exec sp_rename 'anes.state','City','COLUMN';
exec sp_rename 'anes.Brief_Description', 'states', 'COLUMN';
exec sp_rename 'anes.Company', 'Facility', 'COLUMN';
exec sp_rename 'anes.Updated', 'Company', 'COLUMN';
exec sp_rename 'anes.Duration', 'Description', 'COLUMN';

--table has been cleaned and is ready for analysis
--count number of jobs post avaiable in data set
select count (*) as total_postings
from anes;
--1602 are the national results
--This shows which markets had the highest concentration of postings during the collection period.
select
	states,
	Count(*) as posting_count
from anes
group by states
order by Posting_count desc;

--checking for missing values in min and max feild
select
	count(*) as total_rows,
	count(Min) as rows_with_min,
	count(Max) as rows_with_max,
	count(*) - count (Min) as missing_min,
	count(*) - count(max) as missing_max
from anes;

--values with both a min and max
select
	count(*) as tota_rows,
	count(*) - COUNT(case
		when min is not null and max is not null then 1
	end) as missing_compensation,
	COUNT(case
		when min is not null and max is not null then 1
	end) as complete_compensation
from anes;

-- creating a mid point
select
	*,
	(min+max)/2.0 as avg_compensation
from anes;

--average compenstiaon by state using mid point
select 
	states,
	AVG((min+max)/2.0) as avg_compensation
from anes
where min is not null
	and max is not null
group by states
order by avg_compensation desc;
-- second table for joins
select*
from regions;

--column name conformantaion
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'regions';

--joining two tables together
select
	a.states,
	r.MGMA_region
from anes a 
left join regions r
	on a.states= r.state;

-- Analyze average midpoint compensation by MGMA region
select 
	r.MGMA_Region,
	count(*) as posting_count,
	AVG((a.[Min] + a.[Max])/2.0) as avg_compensation
from anes a 
left join regions r
	on a.states = r.State
where a.[Min] is not null
	and a.[Max] is not null
	and r.MGMA_Region is not null
group by r.MGMA_Region
order by avg_compensation desc;

-- Analyze compensation trends over time
SELECT
    Date_Posted,
    COUNT(*) AS posting_count,
    AVG((a.[Min] + a.[Max]) / 2.0) AS avg_compensation
FROM anes a
WHERE a.[Min] IS NOT NULL
  AND a.[Max] IS NOT NULL
GROUP BY Date_Posted
ORDER BY Date_Posted;

--weekly compensation trend
Select
	DATEPART(WEEK, Date_Posted) as week_number,
	count(*) as posting_count,
	avg((a.[min] + a.[max]) / 2.0) as avg_compensation
from anes a
where a.[min] is not null
	and a.[max] is not null
group by DATEPART(week, Date_Posted)
order by week_number;
-- compensation levels remained stable in the 500's fro the month with minor flucuations. date is only 1 month old. difficult to 
--imply if this is indicituve of long term trends. 

--compensation trends by region over time
select
	r.MGMA_Region,
	a.Date_posted,
	avg((a.[Min] + a.[Max]) / 2.0) as avg_compensation,
	count(*) as posting_count
from anes a
left join regions r
	on a.states = r.state
where a.[Min] is not null
 and a.[Max] is not null
 and r.MGMA_Region is not null
group by 
	r.MGMA_Region,
	a.Date_Posted
order by 
	r.MGMA_Region,
	a.Date_Posted; 

--find days with the most job postings
select top 5
	Date_Posted,
	count(*) as posting_count
from anes
group by Date_Posted
Order by posting_count desc; 

-- Posting volume + average compensation on those days
SELECT
    Date_Posted,
    COUNT(*) AS posting_count,
    AVG((a.[Min] + a.[Max]) / 2.0) AS avg_compensation
FROM anes a
WHERE a.[Min] IS NOT NULL
  AND a.[Max] IS NOT NULL
GROUP BY Date_Posted
ORDER BY posting_count DESC;

-- job postings by day of week
select
	DATENAME(WEEKDAY, Date_Posted) as day_of_week,
	count(*) as posting_count
from anes
GROUP BY DATENAME(WEEKDAY, Date_Posted)
ORDER BY posting_count desc; 

--Job posting activity is heavily concentrated during the workweek, with Thursday accounting for the highest volume of postings (837), significantly exceeding other days. Posting volume declines sharply after Thursday, with minimal activity observed on weekends. This pattern suggests that employers prioritize mid-week visibility when releasing new opportunities

-- Posting volume by day of week AND region
SELECT
    r.MGMA_Region,
    DATENAME(WEEKDAY, a.Date_Posted) AS day_of_week,
    COUNT(*) AS posting_count
FROM anes a
LEFT JOIN regions r
    ON a.states = r.State
WHERE r.MGMA_Region IS NOT NULL
GROUP BY 
    r.MGMA_Region,
    DATENAME(WEEKDAY, a.Date_Posted)
ORDER BY 
    r.MGMA_Region,
    posting_count DESC;
	
	-- Top posting day per region
WITH regional_counts AS (
    SELECT
        r.MGMA_Region,
        DATENAME(WEEKDAY, a.Date_Posted) AS day_of_week,
        COUNT(*) AS posting_count
    FROM anes a
    LEFT JOIN regions r
        ON a.states = r.State
    WHERE r.MGMA_Region IS NOT NULL
    GROUP BY 
        r.MGMA_Region,
        DATENAME(WEEKDAY, a.Date_Posted)
)

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY MGMA_Region ORDER BY posting_count DESC) AS rn
    FROM regional_counts
) ranked
WHERE rn = 1
--Job posting behavior was consistent across all regions, with Thursday emerging as the highest-volume posting day regardless of geographic location. This suggests that posting timing is driven by standardized hiring practices rather than regional differences.

--Compensation by day of week and region
select
	r.MGMA_Region, 
	DATENAME(WEEKDAY, a.Date_Posted) as day_of_week,
	count(*) AS posting_count,
	AVG((a.[Min] + a.[Max]) / 2.0)As avg_compensation
From anes a
Left Join regions r
	on A.states = r.state
Where a.[Min] is not null
	and a.[Max] is not null
	and r.MGMA_Region is not null
group by 
	r.MGMA_Region,
	DATENAME(WEEKDAY, a.Date_Posted)
ORDER BY
	r.MGMA_Region,
	posting_count DESC;

	--While Thursday is the dominant day for job postings across all regions, higher compensation opportunities tend to appear mid-week, particularly on Wednesdays, where average compensation exceeds other days in multiple regions.
	--Job posting volume peaks on Thursdays across all regions, indicating consistent national posting behavior. However, compensation trends reveal a different pattern: mid-week postings, particularly on Wednesdays, show higher average compensation despite lower posting volume. This suggests that higher-paying roles may be posted more selectively and are less frequent than standard job listings.

-- Compare volume vs compensation by day of week
SELECT
    DATENAME(WEEKDAY, a.Date_Posted) AS day_of_week,
    COUNT(*) AS posting_count,
    AVG((a.[Min] + a.[Max]) / 2.0) AS avg_compensation
FROM anes a
WHERE a.[Min] IS NOT NULL
  AND a.[Max] IS NOT NULL
GROUP BY DATENAME(WEEKDAY, a.Date_Posted)
ORDER BY posting_count DESC;

--Job postings peak on Thursdays, indicating a high-volume release of opportunities. However, the highest-paying roles tend to be posted mid-week, particularly on Wednesdays, where average compensation is significantly higher despite lower posting volume. This suggests a distinction between high-volume posting behavior and high-value job opportunities

-- Compare Wednesday vs Thursday directly
SELECT
    DATENAME(WEEKDAY, Date_Posted) AS day_of_week,
    COUNT(*) AS posting_count,
    AVG((a.[Min] + a.[Max]) / 2.0) AS avg_compensation
FROM anes a
WHERE DATENAME(WEEKDAY, Date_Posted) IN ('Wednesday', 'Thursday')
  AND a.[Min] IS NOT NULL
  AND a.[Max] IS NOT NULL
GROUP BY DATENAME(WEEKDAY, Date_Posted);

--While Thursday accounts for the highest volume of job postings, Wednesday postings exhibit higher average compensation, suggesting that higher-value opportunities are released more selectively mid-week. This indicates a distinction between high-volume posting behavior and premium job opportunities.
--Job seekers focusing on compensation rather than volume may benefit from targeting mid-week postings, particularly Wednesdays, where average compensation is highest despite lower posting frequency.
