-- INSPECT THE TABLE
DESC verifications; 
SHOW COLUMNS FROM verifications;

----------------------------------------------------------------------------------------
-- A) VERIFICATION ANALYSIS

----------------------------------------------------------------------------------------

SELECT
	COUNT(*) AS total_verifications
FROM
	verifications;
-- shows the total verifications count in the table

-------------------------------------------------------------------------------------------

SELECT DISTINCT
    (status)
FROM
    verifications; 
-- shows the different verification status
    
---------------------------------------------------------------------------------------------

UPDATE verifications SET status = 'Successful' WHERE status ='Completed';
UPDATE verifications SET status = 'Abandoned' WHERE status ='Archived';
UPDATE verifications SET aml_reference = 'none' WHERE aml_reference = '-';

-- Normalizes the status labels across the table so there is no confusion or inconsistency

---------------------------------------------------------------------------------------------

SELECT
	status,
    COUNT(*) as count_per_verification_status,
    SUM(COUNT(*)) OVER() AS total_verifications,
    ROUND((COUNT(*) / SUM(COUNT(*)) OVER())*100,2) AS status_percentage
FROM
	verifications
GROUP BY 
	status
ORDER BY count_per_verification_status DESC; 
-- query shows the count of verifications per status

--------------------------------------------------------------------------------------------

SELECT 
	review_process,
    COUNT(*) as count_review
FROM 
	verifications
GROUP BY review_process;
-- this shows that there were more automatic verifications than human review

---------------------------------------------------------------------------------------------------

-- 2) CONFIDENCE SCORE ANALYSIS

---------------------------------------------------------------------------------------------------

SELECT 
	status,
    ROUND(AVG(confidence), 2) AS avg_confidence,
    COUNT(*) AS verification_count
FROM 
	verifications
WHERE selfie_url != 'No selfie' AND status = 'Successful'
GROUP BY status
ORDER BY avg_confidence DESC; -- this query shows the average confidence by status

-----------------------------------------------------------------------------------------------------

-- 3) GEOGRAPHIC INSIGHTS

-----------------------------------------------------------------------------------------------------

SELECT
	country,
    COUNT(*) AS total_verifications_per_country
FROM
	verifications
WHERE country != 'unknown'
GROUP BY country
ORDER BY total_verifications_per_country DESC
LIMIT 10; 
-- shows the country with highest verification

----------------------------------------------------------------------------------------------

-- 4) TIME BASED TRENDS

---------------------------------------------------------------------------------------------

SELECT 
	DATE(datetime) AS verifications_date,
    COUNT(*) AS verifications_count
FROM verifications
GROUP BY verifications_date
ORDER BY verifications_date, verifications_count DESC; 
-- shows daily volume transaction

----------------------------------------------------------------------------------------------

SELECT 
	DAYNAME(datetime) AS day_of_week,
    COUNT(*) AS verifications_count
FROM verifications
GROUP BY day_of_week
ORDER BY verifications_count DESC; 
-- Shows the day with the most verifications and weekday volume trends

-----------------------------------------------------------------------------------------------

SELECT 
	MONTHNAME(datetime) AS month,
	COUNT(*) AS verifications_count
FROM verifications
GROUP BY month
ORDER BY verifications_count DESC; 
-- shows the month with the most verifcations and monthly verification volume

----------------------------------------------------------------------------------------------

SELECT
	HOUR(datetime) AS hour_of_day,
    COUNT(*) AS verifications_count
FROM verifications
GROUP BY hour_of_day
ORDER BY verifications_count DESC; 
-- shows the hour of the day with the most verifications 
---------------------------------------------------------------------------

SELECT
	year(datetime) AS year,
    COUNT(*) AS verifications_count
FROM verifications
GROUP BY year
ORDER BY verifications_count DESC; 
-- shows the hour of the day with the most verifications

----------------------------------------------------------------------------------------------


-- 5) QUALITY CHECKS & ANOMALIES

----------------------------------------------------------------------------------------------

SELECT
	COUNT(*) as confidence_count
FROM 
	verifications
WHERE confidence < 85 AND status = 'Successful'; -- shows confidence scores below 85% with successful status

---------------------------------------------------------------------------------------------------------------

WITH 
	total AS (
		SELECT COUNT(*) AS total_verifications_count FROM verifications
	),
    dups AS (
		SELECT COUNT(*) AS duplicated_checks FROM verifications WHERE duplicate_check = 1
	)
SELECT
	total.total_verifications_count,
    dups.duplicated_checks,
    (dups.duplicated_checks/ total.total_verifications_count) * 100 AS duplicated_check_percentage
FROM total, dups; 
-- Shows percentage of duplicated_checks

------------------------------------------------------------------------------------

SELECT 
    total.verifications_count,
    aml.AML_count,
    (aml.AML_count / total.verifications_count * 100) AS Percentage
FROM 
    (SELECT COUNT(*) AS verifications_count FROM verifications) AS total,
    (SELECT COUNT(*) AS AML_count FROM verifications WHERE aml_reference != 'none') AS aml;

-- Percentage of verifications that went through AML




----------------------------------------------------------------------------------------------------------

SELECT 
	reason_for_human_review_id,
    COUNT(*) AS most_common_error
FROM verifications
WHERE reason_for_human_review_id != 'none'
GROUP BY reason_for_human_review_id
ORDER BY most_common_error DESC;
-- this query identifies the most common failure reasons

----------------------------------------------------------------------------------------------------

-- 6) CUSTOMER LEVEL METRICS

SELECT
	app_id,
    COUNT(*) as verification_count
FROM verifications
WHERE app_id 
GROUP BY app_id
ORDER BY verification_count DESC
LIMIT 10;
-- Shows the top 10 companies by volume

-------------------------------------------------------------------------------


-- 7) SUSPICIOUS VERIFICATIONS

CREATE VIEW suspicious_verifications AS 
SELECT
	*
FROM 
	verifications
WHERE confidence < 85
OR duplicate_check = 1
OR reason_for_human_review_id != 'none';

SELECT COUNT(*) FROM suspicious_verifications;
-- this creates a view of suspicious verifications for further analysis

----------------------------------------------------------------------------------------------

-- 7) EXTRA INSIGHTS 

-----------------------------------------------------------------------------------------------


SELECT
	app_id,
    COUNT(*) as verification_count,
    RANK() OVER(ORDER BY COUNT(*) DESC) as customer_rank
FROM verifications
WHERE app_id != 'none'
GROUP BY app_id
LIMIT 10;

-- Ranks Customers by verification volume

-----------------------------------------------------------------------------------------------

WITH quality_check AS (
	SELECT 
		id,
        confidence,
        CASE
			WHEN confidence >=98 THEN 'High'
            WHEN confidence BETWEEN 85 AND 97.99 THEN 'Medium'
            ELSE 'Low'
        END AS quality_band
	FROM
		verifications
)
SELECT 
	quality_band,
    COUNT(*) as total
FROM quality_check
GROUP BY quality_band
ORDER BY total DESC;

-- Classifies verification on a quality band which can be used to segment data for quality assurance

-----------------------------------------------------------------------------------------

WITH flagged AS (
	SELECT 
		id,
        confidence,
        duplicate_check,
        reason_for_human_review_id,
        reason_for_human_review_selfie,
        CASE
			WHEN confidence  < 85 AND duplicate_check = 1 AND reason_for_human_review_id != 'none' THEN 'Duplicate + Low Confidence + Manual Review'
            WHEN confidence < 85 AND duplicate_check = 1 THEN 'Duplicate and Low Confidence'
            WHEN reason_for_human_review_id != 'none' THEN 'Manual Review Triggered'
            ELSE 'Clean'
        END AS issue_category
	FROM 
		verifications
)
SELECT 
	issue_category,
    COUNT(*) AS count
FROM 
	flagged
GROUP BY issue_category;

-- flagging verifications into different problem types, which gives insight into common verification challenges for the team to prioritize fixing.

---------------------------------------------------------------------------------------




