SELECT * 
FROM cities
-- Inner join to countries
Inner join countries
-- Match on country codes
on cities.country_code = countries.code

-- Select name fields (with alias) and region 
SELECT cities.name AS city, countries.name AS country, region
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;

-- ###########################################################################################

-- Select fields with aliases
Select c.code as country_code, name,year,inflation_rate
FROM countries AS c
-- Join to economies (alias e)
inner join economies AS e
-- Match on code field using table aliases
on c.code = e.code;

-- ###########################################################################################

SELECT c.name AS country, l.name AS language, official
FROM countries AS c
INNER JOIN languages AS l
-- Match using the code column
using(code)

-- ###########################################################################################

-- Select country (aliased) from countries
select name as country
from countries;

-- Select country and language names (aliased)
SELECT c.name AS country, l.name as language
-- From countries (aliased)
FROM countries c
-- Join to languages (aliased)
inner join languages l
-- Use code as the joining field with the USING keyword
using(code);

-- Select country and language name (aliased)
SELECT c.name AS country, l.name AS language
-- From countries (aliased)
FROM countries AS c
-- Join to languages (aliased)
INNER JOIN languages AS l
-- Use code as the joining field with the USING keyword
USING(code)
-- Filter for the Bhojpuri language
where l.name = 'Bhojpuri';

-- ###########################################################################################

-- Select relevant fields
Select name,fertility_rate 
-- Inner join countries and populations, aliased, on code
from countries c
Inner join populations p
on c.code = p.country_code;

-- Select fields
SELECT name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
-- Join to economies (as e)
INNER JOIN economies AS e
-- Match on country code
using(code)

-- ###########################################################################################

SELECT name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code
-- Add an additional joining condition such that you are also joining on year
	and p.year = e.year;

-- ###########################################################################################

SELECT 
    c1.name AS city,
    code,
    c2.name AS country,
    region,
    city_proper_pop
FROM cities AS c1
-- Perform an inner join with cities as c1 and countries as c2 on country code
inner join countries c2
on c1.country_code = c2.code
ORDER BY code DESC;

SELECT 
    c1.name AS city, 
    code, 
    c2.name AS country,
    region, 
    city_proper_pop
FROM cities AS c1
-- Join right table (with alias)
left join countries c2
ON c1.country_code = c2.code
ORDER BY code DESC;

-- ###########################################################################################

SELECT name, region, gdp_percapita
FROM countries AS c
LEFT JOIN economies AS e
-- Match on code fields
using(code)
-- Filter for the year 2010
WHERE year = 2010;

-- Select region, and average gdp_percapita as avg_gdp
Select region, avg(gdp_percapita) as avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE year = 2010
-- Group by region
GROUP BY region;

SELECT region, AVG(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE year = 2010
GROUP BY region
-- Order by descending avg_gdp
Order by avg_gdp desc
-- Return only first 10 records
limit 10;

-- ###########################################################################################

-- Modify this query to use RIGHT JOIN instead of LEFT JOIN
SELECT countries.name AS country, languages.name AS language, percent
FROM languages
right JOIN  countries
USING(code)
ORDER BY language;

-- ###########################################################################################

SELECT name AS country, code, region, basic_unit
FROM countries
-- Join to currencies
full Join currencies 
USING (code)
-- Where region is North America or name is null
WHERE region = 'North America' or name is NULL
ORDER BY region;

SELECT name AS country, code, region, basic_unit
FROM countries
-- Join to currencies
left join currencies 
USING (code)
WHERE region = 'North America' 
	OR name IS NULL
ORDER BY region;

SELECT name AS country, code, region, basic_unit
FROM countries
-- Join to currencies
inner join currencies 
USING (code)
WHERE region = 'North America' 
	OR name IS NULL
ORDER BY region;

-- ###########################################################################################

SELECT 
	c1.name AS country, 
    region, 
    l.name AS language,
	basic_unit, 
    frac_unit
FROM countries as c1 
-- Full join with languages (alias as l)
full join languages l
using(code)
-- Full join with currencies (alias as c2)
full join currencies c2
using(code)
WHERE region LIKE 'M%esia';

-- ###########################################################################################

SELECT c.name AS country, l.name AS language
-- Inner join countries as c with languages as l on code
from countries c
inner join languages l
using(code) 
WHERE c.code IN ('PAK','IND')
	AND l.code in ('PAK','IND');

SELECT c.name AS country, l.name AS language
FROM countries AS c        
-- Perform a cross join to languages (alias as l)
cross join languages as l
WHERE c.code in ('PAK','IND')
	AND l.code in ('PAK','IND')
order by country, language;

-- ###########################################################################################

SELECT 
	c.name AS country,
    region,
    life_expectancy AS life_exp
FROM countries AS c
-- Join to populations (alias as p) using an appropriate join
inner join  populations p
ON c.code = p.country_code
-- Filter for only results in the year 2010
where p.year = 2010
-- Sort by life_exp
order by life_exp
-- Limit to five records
limit 5;

-- ###########################################################################################

-- Select aliased fields from populations as p1
select p1.country_code, p1.size as size2010 , p2.size as size2015
-- Join populations as p1 to itself, alias as p2, on country code
from populations p1 
inner join populations p2
using(country_code)

SELECT 
	p1.country_code, 
    p1.size AS size2010, 
    p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code
WHERE p1.year = 2010
-- Filter such that p1.year is always five years before p2.year
    and p2.year = 2015;

-- ###########################################################################################

-- Select all fields from economies2015
Select * from economies2015    
-- Set operation
union 
-- Select all fields from economies2019
Select * from economies2019   
ORDER BY code, year;

-- ###########################################################################################

-- Query that determines all pairs of code and year from economies and populations, without duplicates
select code, year from economies
union
select country_code, year from populations
order by code,year

SELECT code, year
FROM economies
-- Set theory clause
UNION ALL
SELECT country_code, year
FROM populations
ORDER BY code, year;

-- ###########################################################################################

-- Return all cities with the same name as a country
select name from cities
intersect
select name from countries

-- ###########################################################################################

-- Return all cities that do not have the same name as a country
select name from cities
except
select name from countries
ORDER BY name;

-- ###########################################################################################

SELECT DISTINCT name
FROM languages
-- Add syntax to use bracketed subquery below as a filter
WHERE code in 
    (SELECT code
    FROM countries
    WHERE region = 'Middle East')
ORDER BY name;

-- ###########################################################################################

SELECT code, name
FROM countries
WHERE continent = 'Oceania'
-- Filter for countries not included in the bracketed subquery
  and code not in
    (SELECT code
    FROM currencies);

-- ###########################################################################################

SELECT *
FROM populations
WHERE year = 2015
-- Filter for only those populations where life expectancy is 1.15 times higher than average
  AND life_expectancy > 1.15*
  (SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015);

-- ###########################################################################################

-- Select relevant fields from cities table
select name,country_code,urbanarea_pop
-- Filter using a subquery on the countries table
from cities
where name in 
    (select capital from countries)
ORDER BY urbanarea_pop DESC;

-- ###########################################################################################

-- Find top nine countries with the most cities
select countries.name as country, count(cities.name) as cities_num
from countries
LEFT JOIN cities
on countries.code = cities.country_code

group by countries.name
-- Order by count of cities as cities_num
Order by cities_num desc, country
-- Order by countries.name
-- Limit the results
Limit 9;    


select countries.name as country, 
      (select count(*) 
      from cities
      where countries.code = cities.country_code  ) as cities_num
from countries
Order by cities_num desc, country
Limit 9;

-- ###########################################################################################

-- Select code, and language count as lang_num
select code, COUNT(*) as lang_num
from languages
GROUP BY code

-- Select local_name and lang_num from appropriate tables
Select local_name, lang_num
FROM 
  countries,
  (SELECT code, COUNT(*) AS lang_num
  FROM languages
  GROUP BY code) AS sub
-- Where codes match
WHERE countries.code = sub.code
ORDER BY lang_num DESC;

-- ###########################################################################################

-- Select relevant fields
SELECT code,inflation_rate,unemployment_rate
FROM economies
WHERE year = 2015 
  AND code IN
-- Subquery returning country codes filtered on gov_form
	(SELECT code 
  FROM countries
  WHERE gov_form LIKE '%Republic%' 
  OR gov_form LIKE '%Monarchy%'
  )
ORDER BY inflation_rate;

-- ###########################################################################################

-- Select fields from cities
SELECT name,country_code,city_proper_pop,metroarea_pop,
    city_proper_pop/metroarea_pop*100 as city_perc
-- Use subquery to filter city name
FROM cities,
    (SELECT capital 
    FROM countries
    WHERE continent = 'Europe'
    OR region LIKE '%America'
    ) as sub
-- Add filter condition such that metroarea_pop does not have null values
WHERE cities.name = sub.capital
    AND metroarea_pop IS NOT NULL
-- Sort and limit the result
ORDER BY city_perc DESC
LIMIT 10;
