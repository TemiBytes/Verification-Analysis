<h1>Verification Data Analysis with SQL, Python & Power BI</h1>

<h2>Overview</h2>

This project is a comprehensive exploratory data analysis (EDA) of a real-world identity verification dataset. 
The goal was to clean, transform, and analyze over 877,000 verification records using SQL and Python, and visualize key insights with Power BI. 
The analysis aims to identify trends in verification success, reasons for failure, and operational bottlenecks to help improve digital onboarding systems.

<h2>Objectives</h2>

- Clean and prepare raw verification data for analysis
- Perform SQL-based exploratory data analysis
- Use Python to perform deeper univariate and bivariate analysis
- Build an interactive Power BI dashboard for executive stakeholders
- Extract insights to guide improvements in the identity verification process

<h2>Tools & Technologies</h2>

- **SQL (MySQL)** – for schema design and data querying
- **Python (Pandas, Matplotlib, Seaborn)** – for data cleaning and exploratory analysis
- **Power BI** – for interactive dashboard visualization
- **Jupyter Notebook** – for documenting the Python cleaning workflow


<h2>Data Cleaning Highlights</h2>

Performed in the [`verifications_blog_data_cleaning.ipynb`]

- Removed duplicates and standardized column names
- Converted salary, confidence, and time columns to numeric types
- Cleaned dirty categorical fields (e.g., country, industry, mode)
- Handled missing values intelligently based on field relevance
- Prepared a clean dataset for both SQL and Power BI analysis


<h2>SQL Exploratory Data Analysis</h2>

Executed via the [`verification_analysis.sql`]

- Total number of verifications, failed vs. successful
- AML and human review rates
- Verification status trends by year and country
- Top human review failure reasons
- Top companies using the verification service

Example query:

SELECT 
    status, 
    COUNT(*) AS total_verifications
FROM 
    verifications
GROUP BY 
    status
ORDER BY 
    total_verifications DESC;


<h2>Indexing for Performance</h2>

With over 800K records, indexing was essential. See indexing.sql for how indexed columns improved query speed, especially on:

  - datetime
  - status
  - mode
  - Aml reference

<h2>Power BI Dashboard</h2>

<h4>Key metrics presented:</h4>

  - Total Verifications: 877K+
  - Success Rate: 29.26%
  - AML Rate: 2.08%
  - Average Confidence: 99.97%
  - Most Common Mode: LIVENESS (83.6%)

<h2>Visuals Included</h2>

  - verifications by Year
  - Country distribution map
  - Top Verification Statuses
  - Failure Reasons
  - Top Verifying Companies

<h2>Key Insights</h2>

  
  - Mode Preference: Majority used LIVENESS, with OTP forming a smaller portion.
  - Failure reason: "Unable to read document type" was the leading failure reason.
  - Confidence Score: Extremely high confidence average (99.97%), but failure rates still suggest UX issues.
  - Geographical Spread: High verification activity centered in Africa and parts of South America.


