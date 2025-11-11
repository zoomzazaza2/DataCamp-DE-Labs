-- Count the number of records in the people table
select count(*) as count_records
from people;

-- Count the number of birthdates in the people table
select count(birthdate) as count_birthdate
from people;

-- Count the records for languages and countries represented in the films table
select Count(language) as count_languages ,
        Count(country) as count_countries
from films;

-- ###########################################################################################

-- Return the unique countries from the films table
select distinct(country)
from films

-- Return the unique countries from the films table
select count(distinct(country)) as count_distinct_countries
from films

-- ###########################################################################################

-- Rewrite this query
SELECT person_id, role 
FROM roles 
LIMIT 10;

-- ###########################################################################################

-- Select film_id and imdb_score with an imdb_score over 7.0
SELECT film_id,imdb_score
FROM reviews
WHERE imdb_score > 7.0;

-- Select film_id and facebook_likes for ten records with less than 1000 likes 
SELECT film_id , facebook_likes
FROM reviews
WHERE facebook_likes < 1000
LIMIT 10;

-- ###########################################################################################

-- Count the Spanish-language films
SELECT COUNT(language) as count_spanish
FROM films
WHERE language = 'Spanish'

-- Select the title and release_year for all German-language films released before 2000
Select title,release_year
from films
where language = 'German' and release_year < 2000

-- Update the query to see all German-language films released after 2000
SELECT title, release_year
FROM films
WHERE release_year > 2000
	AND language = 'German';

-- Select all records for German-language films released after 2000 and before 2010
SELECT *
FROM films
WHERE language = 'German' 
        AND release_year > 2000 
        AND release_year < 2010

-- ###########################################################################################

SELECT title, release_year
FROM films
WHERE (release_year = 1990 OR release_year = 1999)
	AND (language = 'English' OR language = 'Spanish')
	AND gross > 2000000
-- Filter films with more than $2,000,000 gross

-- ###########################################################################################

SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
	AND budget > 100000000
-- Amend the query to include Spanish or French-language films
	AND (language ='Spanish' or language ='French');

-- ###########################################################################################
-- Select the names that start with B
SELECT name
FROM people
WHERE name LIKE 'B%'

SELECT name
FROM people
-- Select the names that have r as the second letter
WHERE name LIKE '_r%'

SELECT name
FROM people
-- Select names that don't start with A
WHERE name NOT LIKE 'A%'

-- ###########################################################################################
-- Find the title and release_year for all films over two hours in length released in 1990 and 2000
SELECT title, release_year
FROM films
WHERE duration > 120 
    AND release_year in (1990,2000)

-- Find the title and language of all films in English, Spanish, and French

SELECT title, language
FROM films
WHERE language in ('English', 'Spanish',  'French')

-- Find the title, certification, and language all films certified NC-17 or R that are in English, Italian, or Greek
SELECT title, certification,language
FROM films
WHERE certification in ('NC-17','R')
    AND language in ('English', 'Italian', 'Greek')

-- ###########################################################################################
-- Count the unique titles
SELECT COUNT(DISTINCT(title)) AS nineties_english_films_for_teens
FROM films
-- Filter to release_years to between 1990 and 1999
WHERE release_year BETWEEN 1990 AND 1999
-- Filter to English-language films
	AND language = 'English'
-- Narrow it down to G, PG, and PG-13 certifications
	AND certification in ('G','PG','PG-13');

-- ###########################################################################################
-- List all film titles with missing budgets
SELECT title as no_budget_info
FROM films
WHERE budget IS NULL;

-- Count the number of films we have language data for
SELECT COUNT(*) as count_language_known
FROM films
WHERE language IS NOT NULL;

-- ###########################################################################################

-- Query the sum of film durations
SELECT sum(duration) as total_duration
FROM films

-- Calculate the average duration of all films
SELECT avg(duration) as average_duration
FROM films;

-- Find the latest release_year
SELECT max(release_year) as latest_year
FROM films;

-- Find the duration of the shortest film
SELECT min(duration) as shortest_film
FROM films;

-- ###########################################################################################
-- Calculate the sum of gross from the year 2000 or later
SELECT sum(gross) as total_gross
FROM films
WHERE release_year >= 2000;

-- Calculate the average gross of films that start with A
SELECT avg(gross) as  avg_gross_A
FROM films
WHERE title like 'A%';

-- Calculate the lowest gross film in 1994
SELECT min(gross) as  lowest_gross
FROM films
WHERE release_year = 1994;

-- Calculate the highest gross film released between 2000-2012
SELECT max(gross) as  highest_gross
FROM films
WHERE release_year BETWEEN 2000 AND 2012;




-- Round the average number of facebook_likes to one decimal place
SELECT round(avg(facebook_likes),1) as  avg_facebook_likes
FROM reviews;

-- ###########################################################################################

-- Calculate the average budget rounded to the thousands
SELECT round(avg(budget),-3) as  avg_budget_thousands
FROM films;

-- ###########################################################################################

-- Calculate the title and duration_hours from films
SELECT title, (duration/60.0) as duration_hours
FROM films;

-- Calculate the percentage of people who are no longer alive
SELECT count(deathdate) * 100.0 / count(*) AS percentage_dead
FROM people;

-- Find the number of decades in the films table
SELECT (max(release_year)-min(release_year)) / 10.0 AS number_of_decades
FROM films;

-- ###########################################################################################

-- Round duration_hours to two decimal places
SELECT title, round(duration / 60.0,2) AS duration_hours
FROM films;

-- ###########################################################################################

-- Select name from people and sort alphabetically
SELECT name
FROM people
ORDER BY name;

-- Select the title and duration from longest to shortest film
Select title, duration
from films
order by duration DESC

-- ###########################################################################################

-- Select the release year, duration, and title sorted by release year and duration
Select release_year,duration,title
from films
order by release_year, duration

-- Select the certification, release year, and title sorted by certification and release year
select certification, release_year, title
from films
order by certification , release_year DESC

-- ###########################################################################################
  
-- Find the release_year and film_count of each year
select release_year, count(*) as film_count
from films 
group by release_year;

-- Find the release_year and average duration of films for each year
select release_year, avg(duration) as avg_duration
from films
group by release_year

-- ###########################################################################################

-- Find the release_year, country, and max_budget, then group and order by release_year and country
select release_year,country,max(budget) as max_budget
from films
group by release_year,country
order by release_year,country;

-- ###########################################################################################

-- Select the country and distinct count of certification as certification_count
Select country, count(distinct(certification)) as certification_count
-- Group by country
from films
Group by country
-- Filter results to countries with more than 10 different certifications
having count(distinct(certification)) > 10;

-- ###########################################################################################

-- Select the country and average_budget from films
Select country, round(avg(budget),2) as average_budget
from films
-- Group by country
Group by country
-- Filter to countries with an average_budget of more than one billion
having avg(budget) > 1e9
-- Order by descending order of the aggregated budget
order by average_budget desc;

-- ###########################################################################################

-- Select the release_year for films released after 1990 grouped by year
Select release_year
from films
where release_year > 1990
group by release_year

-- Modify the query to also list the average budget and average gross
SELECT release_year, avg(budget) as avg_budget, avg(gross) as avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year;

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
-- Modify the query to see only years with an avg_budget of more than 60 million
having AVG(budget) >60e6;

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
-- Order the results from highest to lowest average gross and limit to one
ORDER BY AVG(gross) DESC
limit 1;
