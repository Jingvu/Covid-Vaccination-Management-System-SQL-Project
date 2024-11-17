-- For any two given months, list the months, the total number of vaccines administered in each observation months 
-- in each of all countries, and the difference between the administered vaccines.
SELECT 
    l.location AS Country_Name,
    'April 2022' AS Observation_Months_1,
    SUM(CASE WHEN v.date BETWEEN '2022-04-01' AND '2022-04-30' THEN v.total_vaccinations ELSE 0 END) AS Administered_Vaccine_on_OM1,
    'May 2022' AS Observation_Months_2,
    SUM(CASE WHEN v.date BETWEEN '2022-05-01' AND '2022-05-31' THEN v.total_vaccinations ELSE 0 END) AS Administered_Vaccine_on_OM2,
    (SUM(CASE WHEN v.date BETWEEN '2022-04-01' AND '2022-04-30' THEN v.total_vaccinations ELSE 0 END) - 
     SUM(CASE WHEN v.date BETWEEN '2022-05-01' AND '2022-05-31' THEN v.total_vaccinations ELSE 0 END)) AS Difference_of_totals
FROM VaccinationRecordByLocation v
JOIN Location l ON v.iso_code = l.iso_code
WHERE v.iso_code IN ('OWID_WLS', 'CAN', 'USA', 'DNK')
GROUP BY v.iso_code, l.location
ORDER BY l.location;

-- Find the countries with more than the average cumulative numbers of COVID-19 doses administered by each country 
-- in each month 
WITH MonthlyAverages AS (
    SELECT 
        strftime('%Y-%m', date) AS Month,
        AVG(total_vaccinations) AS AvgCumulativeDoses
    FROM VaccinationRecordByLocation v
    JOIN Location l ON v.iso_code = l.iso_code
    WHERE v.iso_code IN ('OWID_WLS', 'CAN', 'USA', 'DNK')
    GROUP BY Month),
CountryMonthlyDoses AS (
    SELECT 
        l.location AS Country_Name,
        strftime('%Y-%m', v.date) AS Month,
        SUM(v.total_vaccinations) AS CumulativeDoses
    FROM VaccinationRecordByLocation v
    JOIN Location l ON v.iso_code = l.iso_code
    WHERE l.iso_code IN ('OWID_WLS', 'CAN', 'USA', 'DNK')
    GROUP BY Country_Name, Month)
SELECT 
    c.Country_Name,
    c.Month,
    c.CumulativeDoses
FROM CountryMonthlyDoses c
JOIN MonthlyAverages m ON c.Month = m.Month
WHERE c.CumulativeDoses > m.AvgCumulativeDoses
ORDER BY c.Month, c.Country_Name;

-- Produce a list of vaccine types with the countries taking each vaccine type
SELECT 
    v.vaccine_name AS Vaccine_Type,
    l.location AS Country
FROM Vaccine v
JOIN Location l ON v.iso_code = l.iso_code
WHERE l.iso_code IN ('OWID_WLS', 'CAN', 'USA', 'DNK')
ORDER BY Vaccine_Type, Country;

-- A report showing the total number of vaccines administered in each country according to each data source. 
-- Order the result set by the total number of administered vaccines.
SELECT 
    l.location AS Country_Name,
    s.source_website AS Source_URL,
    SUM(v.total_vaccinations) AS Total_Administered_Vaccines
FROM VaccinationRecordByLocation v
JOIN Location l ON v.iso_code = l.iso_code
JOIN Source s ON l.iso_code = s.iso_code
WHERE l.iso_code IN ('OWID_WLS', 'CAN', 'USA', 'DNK')
GROUP BY Country_Name, Source_URL
ORDER BY Total_Administered_Vaccines DESC;

-- A report that lists all the observation months in 2022 and 2023, and then for each months, list the total number 
-- of people fully vaccinated in each one of the 4 countries US, Wales, Canada and Denmark
SELECT 
    strftime('%Y-%m', date) AS Month,
    SUM(CASE WHEN l.location = 'United States' THEN v.people_fully_vaccinated ELSE 0 END) AS United_States,
    SUM(CASE WHEN l.location = 'Wales' THEN v.people_fully_vaccinated ELSE 0 END) AS Wales,
    SUM(CASE WHEN l.location = 'Canada' THEN v.people_fully_vaccinated ELSE 0 END) AS Canada,
    SUM(CASE WHEN l.location = 'Denmark' THEN v.people_fully_vaccinated ELSE 0 END) AS Denmark
FROM VaccinationRecordByLocation v
JOIN Location l ON v.iso_code = l.iso_code
WHERE strftime('%Y', date) IN ('2022', '2023')
GROUP BY Month
ORDER BY Month;
