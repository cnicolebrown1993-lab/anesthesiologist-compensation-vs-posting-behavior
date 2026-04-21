# Anesthesiologist Compensation vs Posting Behavior Analysis

## Overview
This project analyzes anesthesiologist job posting data to identify trends in compensation and posting behavior. Using SQL and Python, the analysis explores how job posting volume compares to compensation levels across different days of the week.

The goal is to understand whether high job volume aligns with high-paying opportunities and to uncover patterns in employer posting behavior.

---

## Key Questions
- Which days have the highest job posting volume?
- Which days have the highest average compensation?
- Do high-volume posting days correspond to higher-paying jobs?
- Are there patterns in how employers release job opportunities throughout the week?

---

## Tools Used
- **SQL Server** – data cleaning, joins, and aggregation
- **Python (pandas, matplotlib)** – data analysis and visualization
- **Excel** – initial data collection and preparation

---

## Key Visualizations

### Job Posting Volume by Day of Week
![Job Postings](images/job_postings_by_day.png)

### Average Compensation by Day of Week
![Compensation](images/avg_compensation_by_day.png)

---

## Key Findings

### 1. Job Posting Volume Peaks on Thursdays
- Thursday has the highest number of job postings by a significant margin
- Posting activity declines sharply toward the weekend

### 2. Highest Compensation Occurs Mid-Week
- Wednesday has the highest average compensation
- Despite lower posting volume, it contains higher-value opportunities

### 3. High Volume Does Not Equal High Pay
- Thursday: highest volume, moderate compensation (~$559K)
- Wednesday: lower volume, highest compensation (~$594K)

👉 This indicates that higher-paying roles are posted more selectively, while bulk postings occur later in the week.

---

## Conclusion
Job posting behavior is consistent across the week, with employers favoring mid-to-late week postings. However, compensation trends reveal a different pattern: higher-paying opportunities tend to appear earlier in the week.

This distinction highlights a key insight:
> High job posting volume does not necessarily indicate higher-value opportunities.

---

## Project Structure
anesthesiologist-compensation-vs-posting-behavior/
│
├── README.md
├── compensation_trends_analysis.ipynb
├── /images
│ ├── job_postings_by_day.png
│ └── avg_compensation_by_day.png
├── /sql
│ └── analysis.sql


---

## Future Improvements
- Expand dataset to multiple months for long-term trend analysis
- Segment analysis by job type, facility, or experience level
- Build interactive dashboards using Tableau or Python

---

## Author
Cassandra Brown  
Data Analyst | Healthcare Analytics | SQL • Python • Tableau
