
-- ============================================
-- ENERGY DATABASE
-- ============================================
CREATE DATABASE energydb;

-- using energydb
use energydb;

-- creating relevent tables
-- 1. creating country table
CREATE TABLE country (
    CID VARCHAR(10) PRIMARY KEY,
    Country VARCHAR(100) UNIQUE
);

describe country;
SELECT * FROM COUNTRY;

-- 2. creating emission table
CREATE TABLE emission(
    country VARCHAR(100),
    energy_type VARCHAR(50),
    year INT,
    emission varchar(255),
    per_capita_emission DOUBLE,
    FOREIGN KEY (country) REFERENCES country(Country)
);

describe emission;
select * from emission;

-- 3. creating population table
CREATE TABLE population (
    countries VARCHAR(100),
    year INT,
    Value varchar(255),
    FOREIGN KEY (countries) REFERENCES country(Country)
);

describe population;
SELECT * FROM POPULATION;

-- 4. creating production table
CREATE TABLE production (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    production varchar(255),
    FOREIGN KEY (country) REFERENCES country(Country)
);
 
describe production;
SELECT * FROM PRODUCTION;

-- 5. creating gdp table
CREATE TABLE gdp(
    Country VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (Country) REFERENCES country(Country)
);

SELECT * FROM GDP;

-- 6. creating consumption table
CREATE TABLE consumption (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    consumption varchar(255),
    FOREIGN KEY (country) REFERENCES country(Country)
);

describe consumption;
SELECT * FROM CONSUMPTION;

-- Data Analysis Questions
 -- General & Comparative Analysis
-- What is the total emission per country for the most recent year available?
select country, year, sum(emission) as total_emission from emission
where year = (select max(year) from emission)
group by country,year order by total_emission desc;

-- What are the top 5 countries by GDP in the most recent year?
select country,year,value as GDP from gdp 
where year = (select max(year) from gdp)
order by GDP desc limit 5;

-- Compare energy production and consumption by country and year. 
select p.country,p.year,sum(p.production) as total_production, sum(c.consumption) as total_consumption,
(sum(p.production) - sum(c.consumption)) as difference from production p join consumption c on p.country = c.country 
and p.year = c.year group by p.country,p.year order by difference desc;

-- Which energy types contribute most to emissions across all countries?
select energy_type, sum(emission) as total_emission from emission group by energy_type order by total_emission desc;

-- Analysis Over Time
-- How have global emissions changed year over year?
select year,sum(emission) as total_emission from emission group by year order by total_emission desc;

-- What is the trend in GDP for each country over the given years?
select country,year,sum(value) as GDP_VALUE from gdp group by country,year order by country,year;

-- How has population growth affected total emissions in each country?
select e.country, e.year, p.value as pop_growth, sum(e.emission) as total_emissions
from emission e join population p on e.country = p.countries and e.year = p.year
group by e.country, e.year, p.value order by e.country,e.year;

-- Has energy consumption increased or decreased over the years for major economies?
select country ,avg(value) as av from gdp group by country order by av desc limit 5;

select country, year, sum(consumption) as total_consumption from consumption 
where country in ("china","united states","India","japan","germany")
group by country,year order by country,year desc;

 
 -- What is the average yearly change in emissions per capita for each country?
 WITH EmissionPerCapita AS (
    SELECT 
        e.country,
        e.year,
        SUM(e.emission) AS total_emission,
        p.value AS population,
        SUM(e.emission) / p.value AS emission_per_capita
    FROM emission e
    JOIN population p ON e.country = p.countries AND e.year = p.year
    GROUP BY e.country, e.year, p.value
),
YearlyChange AS (
    SELECT
        country,
        year,
        emission_per_capita,
        emission_per_capita - LAG(emission_per_capita) OVER (PARTITION BY country ORDER BY year) AS yearly_change
    FROM EmissionPerCapita
)
SELECT 
    country,
    AVG(yearly_change) AS avg_yearly_change_in_emission_per_capita
FROM YearlyChange
WHERE yearly_change IS NOT NULL
GROUP BY country
ORDER BY avg_yearly_change_in_emission_per_capita DESC;

-- Ratio & Per Capita Analysis
-- What is the emission-to-GDP ratio for each country by year?
select e.country,e.year,sum(e.emission) as total_emission, g.value as gdp_value,
round(sum(e.emission) / g.Value,2) as emission_to_gdp_ratio from emission e join gdp g on e.country = g.Country
and e.year = g.year group by e.country,e.year,g.value order by e.country, e.year;

-- What is the energy consumption per capita for each country over the last decade?
select c.country, c.year, p.value as population, round(sum(c.consumption) / p.Value, 4) as consumption_per_capita
from consumption c join population p on c.country = p.countries and c.year = p.year
where c.year between (select max(year) - 9 from consumption) and (select max(year) from consumption)
group by c.country,c.year,p.value order by c.country,c.year desc;

-- How does energy production per capita vary across countries?
select p.country, sum(p.production / pp.value) as avg_energy_per_capita
from production as p
join population as pp on p.country = pp.countries and p.year = pp.year
group by p.country order by avg_energy_per_capita desc;

-- Which countries have the highest energy consumption relative to GDP?
select c.country, c.year, g.value as gdp_value, sum(c.consumption) as total_consumption,
round(sum(c.consumption)/g.value,6) as relation from consumption c 
join gdp g on c.country = g.country and c.year = g.year group by c.country,c.year,g.value order by relation desc;

-- What is the correlation between GDP growth and energy production growth?
with gdp_growth as(select country,year,
((value-lag(value) over (partition by country order by year))
/lag(value) over (partition by country order by year)) * 100 as gdp_growth1
from gdp),
energy_growth as(select country,year,
((production-lag(production) over (partition by country order by year))
/lag(production) over(partition by country order by year)) * 100 as energy_growth1
from production)
SELECT  g.country,g.year,g.gdp_growth1,e.energy_growth1
FROM gdp_growth g
JOIN energy_growth e
    ON g.country = e.country
   AND g.year = e.year;
   
 -- Global Comparisons
-- What are the top 10 countries by population and how do their emissions compare?
select p.countries, p.Value,sum(e.emission) as total_emission,(sum(e.emission)/p.value) as relation from population p join emission e
on p.countries = e.country and p.year = e.year group by p.countries,p.value
order by p.value desc limit 10;

-- Which countries have improved (reduced) their per capita emissions the most over the last decade?
WITH emissions_per_capita AS (
    SELECT
        e.country,
        e.year,
        SUM(e.emission) / p.value AS per_capita_emission
    FROM emission e
    JOIN population p ON e.country = p.countries AND e.year = p.year
    GROUP BY e.country, e.year, p.value
),

years AS (
    SELECT MIN(year) AS min_year, MAX(year) AS max_year FROM emissions_per_capita
),

per_capita_diff AS (
    SELECT
        recent.country,
        (old.per_capita_emission - recent.per_capita_emission) AS reduction
    FROM emissions_per_capita recent
    JOIN emissions_per_capita old ON recent.country = old.country
    CROSS JOIN years
    WHERE recent.year = years.max_year
      AND old.year = years.min_year
)

SELECT country, reduction
FROM per_capita_diff
WHERE reduction > 0
ORDER BY reduction DESC
LIMIT 10;

-- What is the global share (%) of emissions by country?
select country,sum(emission) as total_emission,round(sum(emission) * 100.0 / (select sum(emission) from emission), 2) 
as global_share from emission group by country order by total_emission desc;

-- What is the global average GDP, emission, and population by year?
select gdp.year, avg(gdp.Value) as avg_gdp,
avg(emission.emission) as avg_emission,
avg(population.Value) as avg_population
from gdp join emission on gdp.Country = emission.country 
and gdp.year = emission.year join population on gdp.Country = population.countries 
and gdp.year = population.year group by gdp.year order by gdp.year;