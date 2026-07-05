# HR Employee Analytics Dashboard

A Power BI dashboard analyzing employee performance, attrition trends, and workforce
distribution across departments and experience bands.

## Tools Used
Power BI Desktop, Power BI Service, SQL, Power Query, DAX, Excel

## What It Does
- Tracks KPIs: Total Employees, Active Employees, Attrition Rate, Average Tenure
- Department-wise headcount and experience-band distribution
- Attrition trend analysis with conditional formatting highlighting high-attrition departments
- Hiring trend by year
- Drillthrough from department summary into individual employee performance detail
- Bookmark-based navigation between Workforce Distribution, Attrition Analysis, and Performance Review pages
- Slicers for Department, ExperienceBand, Gender, and EmploymentType

## Data Model
Star schema: Fact_Employee connected to Dim_Department and Dim_Role.

## Files in this repo
- `HR_Employee_Analytics_Dashboard.pbix` — the Power BI file
- `HR_SQL_Queries.sql` — SQL used to extract and join employee, department, and role data
- Screenshots of all 3 dashboard pages<img width="1920" height="1080" alt="Screenshot (88)" src="https://github.com/user-attachments/assets/b6e69bf8-a4f7-43a9-bb36-c02ca32b65ec" />
<img width="1920" height="1080" alt="Screenshot (87)" src="https://github.com/user-attachments/assets/509189b1-b3f3-45e3-a7cb-b593b3d986cb" />
<img width="1920" height="1080" alt="Screenshot (86)" src="https://github.com/user-attachments/assets/e2bc8820-416a-4307-9053-9248d619b26a" />
