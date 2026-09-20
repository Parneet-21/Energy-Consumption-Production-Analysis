# Energy Consumption, Production & Emissions Analysis

## Project Overview

This project was developed using **MySQL** to analyze energy production, energy consumption, emissions, population, and GDP data across different countries and years.

The project involved creating a relational energy database, importing multiple datasets, and performing SQL-based analysis to identify patterns and relationships between energy, economic, population, and emissions indicators.

## What Was Done in the Project

### 1. Database Creation

Created a MySQL database named `energydb` and designed six tables:

- `country`
- `emission`
- `population`
- `production`
- `gdp`
- `consumption`

The `country` table was used as the reference table, with relationships established between country information and the other datasets using foreign keys.

### 2. Data Import

Imported datasets containing:

- Country information
- Energy production
- Energy consumption
- Emissions
- Population
- GDP

The datasets were organized into relational tables and used for further analysis.

### 3. Data Exploration

Performed initial database and table exploration using SQL commands such as:

- `DESCRIBE`
- `SELECT`
- `COUNT`
- `COUNT(DISTINCT)`
- `ORDER BY`
- `LIMIT`

This was used to inspect the database structure, records, and country-level information.

### 4. Emissions Analysis

Analyzed emissions across countries and energy types.

The analysis included:

- Total emissions by country
- Emissions in the most recent available year
- Emissions by energy type
- Per-capita emissions
- Emission-to-GDP ratios
- Countries with reductions in per-capita emissions
- Global share of emissions by country
- Global emissions across different years

### 5. Energy Production & Consumption Analysis

Compared energy production and consumption across countries and years.

The analysis included:

- Total energy production
- Total energy consumption
- Production versus consumption comparison
- Energy production per capita
- Energy consumption per capita
- Energy consumption relative to GDP
- Energy consumption trends for selected major economies

### 6. GDP & Economic Analysis

Used GDP data to perform country-level and year-level economic analysis.

This included:

- Identifying the top 5 countries by GDP
- Studying GDP trends over time
- Comparing GDP with energy consumption
- Comparing GDP growth with energy production growth
- Calculating energy consumption relative to GDP
- Calculating emission-to-GDP ratios

### 7. Population Analysis

Combined population data with energy and emissions data to analyze:

- Population versus total emissions
- Energy consumption per capita
- Energy production per capita
- Emissions per capita
- Emissions of the world's most populated countries

### 8. Advanced SQL Analysis

The project used several advanced SQL concepts, including:

- Multiple table `JOIN`s
- Subqueries
- Common Table Expressions (`CTEs`)
- Aggregate functions
- Window functions
- `LAG()`
- Grouped analysis
- Per-capita calculations
- Ratio calculations
- Year-over-year comparisons

## Key SQL Questions Answered

Some of the major questions addressed in the project were:

1. What are the total emissions per country?
2. Which countries have the highest GDP?
3. How do energy production and consumption compare?
4. Which energy types contribute most to emissions?
5. How have global emissions changed over time?
6. How does GDP vary across countries and years?
7. How do population and emissions compare?
8. How has energy consumption changed for major economies?
9. How has per-capita emissions changed over time?
10. What is the relationship between emissions and GDP?
11. What is energy consumption per capita?
12. What is energy production per capita?
13. Which countries have high energy consumption relative to GDP?
14. How do GDP growth and energy production growth compare?
15. Which highly populated countries have the highest emissions?
16. Which countries reduced their per-capita emissions?
17. What percentage of global emissions comes from each country?
18. How do GDP, emissions, and population vary globally by year?

## SQL Skills Demonstrated

- Database creation
- Relational table design
- Primary keys
- Foreign keys
- Data exploration
- Data aggregation
- Multi-table joins
- Subqueries
- CTEs
- Window functions
- `LAG()`
- `SUM()`
- `AVG()`
- `COUNT()`
- Filtering and sorting
- Per-capita analysis
- Ratio analysis
- Comparative analysis
- Trend analysis

## Project Structure

```text
Energy-Consumption-Production-Analysis/
│
├── README.md
├── SQL_Project.sql
├── consum_3.csv
├── country_3.csv
├── emission_3.csv
├── gdp_3.csv
├── population_3.csv
└── production_3.csv
