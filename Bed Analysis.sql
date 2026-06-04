USE Hospital_Bed_Availability

SELECT * FROM feature_engineered_dataset

--Check if the NULL values are affected
SELECT * FROM feature_engineered_dataset
WHERE available_beds IS NULL

-- Update the NULL value with default value
UPDATE feature_engineered_dataset
SET available_beds = 0
WHERE available_beds IS NULL


--KPI's Calculation

--Occupancy Percentage
SELECT occupancy_rate FROM feature_engineered_dataset

SELECT date, hospital_branch,occupancy_rate , CAST((occupied_beds * 100.0 / total_beds) AS DECIMAL(10,2)) 
AS Occupancy_Percentage
FROM feature_engineered_dataset

--ICU Utilization Percentage
SELECT icu_utilization FROM feature_engineered_dataset

SELECT date,hospital_branch,CAST((occupied_icu_beds *100.0 / icu_beds ) AS DECIMAL(10,2))
AS ICU_Utilization
FROM feature_engineered_dataset

--TO Find Busiest Hospital Branch
SELECT hospital_branch,AVG(occupied_beds *100.0 / total_beds )
AS Avg_Occupancy
FROM feature_engineered_dataset
GROUP BY hospital_branch
ORDER BY Avg_Occupancy

--TO Find Peak Occupancy Periods
SELECT date,hospital_branch,CAST((occupied_beds *100.0 / total_beds ) AS DECIMAL(10,2))
AS Peak_Occupancy
FROM feature_engineered_dataset
ORDER BY Peak_Occupancy DESC

--Monthly Occupancy Trend
SELECT MONTH (date) AS Month,
AVG(occupied_beds *100.0 / total_beds )
AS Avg_Monthly_Occupancy
FROM feature_engineered_dataset
GROUP BY MONTH(date)
ORDER BY Month

--TO find Which weekdays are Busiest
SELECT weekday,AVG(occupied_beds *100.0 / total_beds )
AS Avg_Weekday_Occupancy
FROM feature_engineered_dataset
GROUP BY weekday
ORDER BY Avg_Weekday_Occupancy DESC

--ICU usage
SELECT weekday,hospital_branch,
AVG(occupied_icu_beds *100.0 / icu_beds)
AS Avg_ICU_Usage
FROM feature_engineered_dataset
GROUP BY weekday,hospital_branch
ORDER BY Avg_ICU_Usage DESC

--Admissoins Vs Discharges
SELECT date,weekday,
SUM(admissions) AS Total_Admission,
SUM(discharges) AS Total_Discharges
FROM feature_engineered_dataset
GROUP BY date,weekday
ORDER BY date

--Emergency Case analysis
SELECT weekday,hospital_branch,SUM(emergency_cases) AS Total_emergency_case
FROM feature_engineered_dataset
GROUP BY weekday,hospital_branch
ORDER BY Total_emergency_case DESC

--TO find Overcrowded in Hospital
SELECT date,weekday,hospital_branch,
CAST((occupied_beds *100.0 / total_beds ) AS DECIMAL(10,2)) AS Occupancy_per
FROM feature_engineered_dataset
WHERE (occupied_beds *100.0 / total_beds) > 85
ORDER BY Occupancy_per DESC

