# covid-vaccination-dataset-sql-project
This project involves analyzing and understanding a publicly available dataset, ["A Global Database of COVID-19 Vaccinations"](https://github.com/owid/covid-19-data/tree/master/public/data/vaccinations).

It includes designing a conceptual model for storing the dataset in a relational database, implementing and hosting the database, and developing SQL queries to meet specific data analysis requirements.

## Designing the database
![Blank diagram (1)](https://github.com/user-attachments/assets/d13aa01a-c74a-41bb-b25f-ea23156f9f04)


### Relationship Explanation
- Location - Source_name: each location can originate from multiple sources, with each source potentially having several locations.
- Location – States: each location can have 0 to n states and each state is linked to a single location.
- States - US_State: each state can have multiple records of state-specific vaccination data and each state vaccination record in a day is associated with a single state.
- Location - Age_group: each location can have multiple age group records and each age group record is linked to a single location and each age group can appear in multiple locations.
- Location – Vaccine: each location can use multiple vaccines and each vaccine can be used in multiple locations.
- VaccinationRecordByLocation - Location: each vaccination record on each day is associated with a single location and each location can have multiple vaccination records.
- VaccinationRecordByVaccine - Vaccine: each vaccination record by vaccine on each day is associated with a specific vaccine and each vaccine can have multiple vaccination records.
- VaccinationRecordByAge - Age_group: each vaccination record by age group on each day is associated with a specific age group and each age group can have multiple vaccination records.

### Schema
Location (iso_code, location, last_obs_date)\
Source (source_website, source_name, iso_code*)\
States (US_state, iso_code*)\
US_State (US_state*, date, total_vaccinations, total_distributed, people_vaccinated, people_fully_vaccinated_per_hundred, total_vaccinations_per_hundred, people_fully_vaccinated, people_vaccinated_per_hundred, distributed_per_hundred, daily_vaccinations_raw, daily_vaccinations, daily_vaccinations_per_million, share_doses_used, total_boosters, total_boosters_per_hundred)\
Age_group (age_group, iso_code*)\
Vaccine (vaccine_name, iso_code*)\
VaccinationRecordByVaccine (date, iso_code*, vaccine_name*, total_vaccinations_by_vaccine)\
VaccinationRecordByAge (date, iso_code*, age_group*, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred, people_with_booster_per_hundred)\
VaccinationRecordByLocation (date, iso_code*, total_vaccinations, people_vaccinated, people_fully_vaccinated, total_boosters, daily_vaccinations_raw, daily_vaccinations, total_vaccinations_per_hundred, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred, total_boosters_per_hundred, daily_vaccinations_per_million, daily_people_vaccinated, daily_people_vaccinated_per_hundred)

### Assumptions, Adjustments and Constraints
- Despite not being applicable to this dataset, in real-world scenarios, data for each location can originate from multiple sources, with each source potentially having several URLs. The ER diagram in this study is designed to be suitable for dealing with this scenario.
- Vaccines are a multivalued attribute and must be separated and normalized, so the vaccine data need to be tidied to eliminate any comma-separated values.
- The Location entity is central and based on the “Locations.csv” file. Any additional location data recorded in other tables will be updated in this table. This includes some subnational locations (such as England, Northern Ireland, Scotland, Wales, Northern Cyprus) and international aggregates (such as World, continents, European Union). However, due to the limitations of the nine CSV files used, some records may lack source names and source websites.
- All date values in this dataset are in YYYY-MM-DD format.
- All blank values are treated as NULL values.
- Due to each location can have multiple vaccines, and each vaccine can be used in multiple locations, while some locations have recorded total vaccinations by vaccine name for specific days and others do not, two separate tables being used Vaccine and VaccinationRecordByVaccine
•	Locations with Vaccination Data: will be stored in VaccinationRecordByVaccine, each record will link a location, date, and vaccine with the corresponding vaccination metrics.
•	Locations without Vaccination Data: will be queried through Vaccine table. This ensures that the relationship between locations and vaccines can be captured even when daily data is not available.
- The same method applied to vaccines is used for age groups, resulting in two separate tables Age_group and VaccinationRecordByAge.
- Although there are some numeric variables in VaccinationRecordByVaccine, US_State, and VaccinationRecordByAge that share names with those in the VaccinationRecordByLocation (ex: total_vaccinations,…) table, they differ in their levels and are therefore stored in different tables.
- Many countries, such as Australia, Mexico, and Nigeria, also have states. The ER diagram in this study is designed to accommodate this scenario by using two separate tables States and US_State.
