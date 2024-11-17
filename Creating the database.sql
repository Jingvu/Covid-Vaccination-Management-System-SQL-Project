-- PART C
-- 1. Location
CREATE TABLE Location (
    iso_code CHAR(3) NOT NULL,
    location VARCHAR(255) NOT NULL,
    last_obs_date DATE NOT NULL,
    PRIMARY KEY (iso_code)
);

-- 2. States
CREATE TABLE States (
    US_state VARCHAR(255) NOT NULL,
    iso_code CHAR(3) NOT NULL,
    PRIMARY KEY (US_state, iso_code),
    FOREIGN KEY (iso_code) REFERENCES Location(iso_code)
);

-- 3. US_State
CREATE TABLE US_State (
    date DATE NOT NULL,    
    US_state VARCHAR(255) NOT NULL,
    total_vaccinations INT,
    total_distributed INT,
    people_vaccinated INT,
    people_fully_vaccinated_per_hundred NUMERIC,
    total_vaccinations_per_hundred NUMERIC,
    people_fully_vaccinated INT,
    people_vaccinated_per_hundred NUMERIC,
    distributed_per_hundred NUMERIC,
    daily_vaccinations_raw INT,
    daily_vaccinations INT,
    daily_vaccinations_per_million INT,
    share_doses_used NUMERIC,
    total_boosters INT,
    total_boosters_per_hundred NUMERIC,
    PRIMARY KEY (US_state, date),
    FOREIGN KEY (US_state) REFERENCES States(US_state)
);
-- Update blank values to NULL
UPDATE US_State
SET total_vaccinations = NULL
WHERE total_vaccinations = '';
UPDATE US_State
SET total_distributed = NULL
WHERE total_distributed = '';
UPDATE US_State
SET people_vaccinated = NULL
WHERE people_vaccinated = '';
UPDATE US_State
SET daily_vaccinations_raw = NULL
WHERE daily_vaccinations_raw = '';
UPDATE US_State
SET daily_vaccinations = NULL
WHERE daily_vaccinations = '';
UPDATE US_State
SET daily_vaccinations_per_million = NULL
WHERE daily_vaccinations_per_million = '';
UPDATE US_State
SET total_boosters = NULL
WHERE total_boosters = '';
UPDATE US_State
SET people_fully_vaccinated_per_hundred = NULL
WHERE people_fully_vaccinated_per_hundred = '';
UPDATE US_State
SET total_vaccinations_per_hundred = NULL
WHERE total_vaccinations_per_hundred = '';
UPDATE US_State
SET people_vaccinated_per_hundred = NULL
WHERE people_vaccinated_per_hundred = '';
UPDATE US_State
SET distributed_per_hundred = NULL
WHERE distributed_per_hundred = '';
UPDATE US_State
SET share_doses_used = NULL
WHERE share_doses_used = '';
UPDATE US_State
SET total_boosters_per_hundred = NULL
WHERE total_boosters_per_hundred = '';

-- 4. Age_group
CREATE TABLE Age_group (
    iso_code CHAR(3) NOT NULL,    
    age_group VARCHAR(50) NOT NULL,
    PRIMARY KEY (age_group, iso_code),
    FOREIGN KEY (iso_code) REFERENCES Location(iso_code)
);

-- 5. Vaccine
CREATE TABLE Vaccine (
    iso_code CHAR(3) NOT NULL,    
    vaccine_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (vaccine_name, iso_code),
    FOREIGN KEY (iso_code) REFERENCES Location(iso_code)
);

-- 6. VaccinationRecordByVaccine
CREATE TABLE VaccinationRecordByVaccine (
    iso_code CHAR(3) NOT NULL,    
    date DATE NOT NULL,
    vaccine_name VARCHAR(255) NOT NULL,
    total_vaccinations_by_vaccine INT,
    PRIMARY KEY (date, iso_code, vaccine_name),
    FOREIGN KEY (iso_code, vaccine_name) REFERENCES Vaccine(iso_code, vaccine_name)
);
-- Update blank values to NULL
UPDATE VaccinationRecordByVaccine
SET total_vaccinations_by_vaccine = NULL
WHERE total_vaccinations_by_vaccine = '';

-- 7. VaccinationRecordByAge
CREATE TABLE VaccinationRecordByAge ( 
    iso_code CHAR(3) NOT NULL,
    date DATE NOT NULL,
    age_group VARCHAR(50) NOT NULL,
    people_vaccinated_per_hundred NUMERIC,
    people_fully_vaccinated_per_hundred NUMERIC,
    people_with_booster_per_hundred NUMERIC,
    PRIMARY KEY (date, iso_code, age_group),
    FOREIGN KEY (iso_code, age_group) REFERENCES Age_group(iso_code, age_group)
);
-- Update blank values to NULL
UPDATE VaccinationRecordByAge
SET people_vaccinated_per_hundred = NULL
WHERE people_vaccinated_per_hundred = '';
UPDATE VaccinationRecordByAge
SET people_fully_vaccinated_per_hundred = NULL
WHERE people_fully_vaccinated_per_hundred = '';
UPDATE VaccinationRecordByAge
SET people_with_booster_per_hundred = NULL
WHERE people_with_booster_per_hundred = '';

-- 8. VaccinationRecordByLocation
CREATE TABLE VaccinationRecordByLocation (
    iso_code CHAR(3) NOT NULL,    
    date DATE NOT NULL,
    total_vaccinations INT,
    people_vaccinated INT,
    people_fully_vaccinated INT,
    total_boosters INT,
    daily_vaccinations_raw INT,
    daily_vaccinations INT,
    total_vaccinations_per_hundred NUMERIC,
    people_vaccinated_per_hundred NUMERIC,
    people_fully_vaccinated_per_hundred NUMERIC,
    total_boosters_per_hundred NUMERIC,
    daily_vaccinations_per_million INT,
    daily_people_vaccinated INT,
    daily_people_vaccinated_per_hundred NUMERIC,
    PRIMARY KEY (date, iso_code),
    FOREIGN KEY (iso_code) REFERENCES Location(iso_code)
);
-- Update blank values to NULL
UPDATE VaccinationRecordByLocation
SET total_vaccinations = NULL
WHERE total_vaccinations = '';
UPDATE VaccinationRecordByLocation
SET people_vaccinated = NULL
WHERE people_vaccinated = '';
UPDATE VaccinationRecordByLocation
SET people_fully_vaccinated = NULL
WHERE people_fully_vaccinated = '';
UPDATE VaccinationRecordByLocation
SET total_boosters = NULL
WHERE total_boosters = '';
UPDATE VaccinationRecordByLocation
SET daily_vaccinations_raw = NULL
WHERE daily_vaccinations_raw = '';
UPDATE VaccinationRecordByLocation
SET daily_vaccinations = NULL
WHERE daily_vaccinations = '';
UPDATE VaccinationRecordByLocation
SET daily_vaccinations_per_million = NULL
WHERE daily_vaccinations_per_million = '';
UPDATE VaccinationRecordByLocation
SET daily_people_vaccinated = NULL
WHERE daily_people_vaccinated = '';
UPDATE VaccinationRecordByLocation
SET total_vaccinations_per_hundred = NULL
WHERE total_vaccinations_per_hundred = '';
UPDATE VaccinationRecordByLocation
SET people_vaccinated_per_hundred = NULL
WHERE people_vaccinated_per_hundred = '';
UPDATE VaccinationRecordByLocation
SET people_fully_vaccinated_per_hundred = NULL
WHERE people_fully_vaccinated_per_hundred = '';
UPDATE VaccinationRecordByLocation
SET total_boosters_per_hundred = NULL
WHERE total_boosters_per_hundred = '';
UPDATE VaccinationRecordByLocation
SET daily_people_vaccinated_per_hundred = NULL
WHERE daily_people_vaccinated_per_hundred = '';

-- 9. Source
CREATE TABLE Source (
    iso_code VARCHAR(3) NOT NULL,
    source_name VARCHAR(255),
    source_website VARCHAR(255),
    FOREIGN KEY (iso_code) REFERENCES Location(iso_code)
);