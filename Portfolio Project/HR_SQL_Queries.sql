/* =========================================================
   PROJECT 2: HR EMPLOYEE ANALYTICS DASHBOARD
   SQL used to extract & join tables before loading into Power BI
   Tested against the schema in HR_Employee_Data.xlsx
   ========================================================= */

-- 1. Table creation
CREATE TABLE Dim_Department (
    DepartmentID    VARCHAR(10) PRIMARY KEY,
    DepartmentName  VARCHAR(50)
);

CREATE TABLE Dim_Role (
    RoleID        VARCHAR(10) PRIMARY KEY,
    RoleName      VARCHAR(50),
    DepartmentID  VARCHAR(10),
    FOREIGN KEY (DepartmentID) REFERENCES Dim_Department(DepartmentID)
);

CREATE TABLE Fact_Employee (
    EmployeeID        VARCHAR(10) PRIMARY KEY,
    EmployeeName      VARCHAR(100),
    DepartmentID      VARCHAR(10),
    RoleID            VARCHAR(10),
    Gender            VARCHAR(10),
    Age               INT,
    JoiningDate       DATE,
    ExitDate          DATE NULL,
    Attrition         VARCHAR(3),
    ExperienceBand    VARCHAR(15),
    TenureYears       DECIMAL(4,1),
    PerformanceScore  DECIMAL(3,1),
    MonthlySalary     DECIMAL(10,2),
    EmploymentType    VARCHAR(20),
    FOREIGN KEY (DepartmentID) REFERENCES Dim_Department(DepartmentID),
    FOREIGN KEY (RoleID) REFERENCES Dim_Role(RoleID)
);


-- 2. Unified HR dataset: employees joined with department + role
SELECT
    e.EmployeeID, e.EmployeeName, e.Gender, e.Age, e.JoiningDate, e.ExitDate,
    e.Attrition, e.ExperienceBand, e.TenureYears, e.PerformanceScore,
    e.MonthlySalary, e.EmploymentType,
    d.DepartmentName, r.RoleName
FROM Fact_Employee e
JOIN Dim_Department d ON e.DepartmentID = d.DepartmentID
JOIN Dim_Role r        ON e.RoleID = r.RoleID;


-- 3. Department-wise headcount and attrition rate
SELECT
    d.DepartmentName,
    COUNT(*) AS Headcount,
    SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) AS ExitedEmployees,
    ROUND(SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS AttritionRatePct
FROM Fact_Employee e
JOIN Dim_Department d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AttritionRatePct DESC;


-- 4. Average tenure and performance by experience band
SELECT
    ExperienceBand,
    COUNT(*)                     AS Employees,
    ROUND(AVG(TenureYears), 1)   AS AvgTenure,
    ROUND(AVG(PerformanceScore), 2) AS AvgPerformanceScore
FROM Fact_Employee
GROUP BY ExperienceBand
ORDER BY FIELD(ExperienceBand, '0-2 Years','2-5 Years','5-10 Years','10+ Years');


-- 5. Departments with above-average attrition (subquery example)
SELECT DepartmentName, AttritionRatePct FROM (
    SELECT d.DepartmentName,
           ROUND(SUM(CASE WHEN e.Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS AttritionRatePct
    FROM Fact_Employee e
    JOIN Dim_Department d ON e.DepartmentID = d.DepartmentID
    GROUP BY d.DepartmentName
) AS DeptAttrition
WHERE AttritionRatePct > (
    SELECT SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) FROM Fact_Employee
)
ORDER BY AttritionRatePct DESC;


-- 6. Hiring trend by year (feeds hiring trend chart)
SELECT
    YEAR(JoiningDate) AS JoinYear,
    COUNT(*) AS NewHires
FROM Fact_Employee
GROUP BY YEAR(JoiningDate)
ORDER BY JoinYear;
