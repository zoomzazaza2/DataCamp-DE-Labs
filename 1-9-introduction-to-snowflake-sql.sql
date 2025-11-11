-- Select pizza_type_id, pizza_size, and price from pizzas table
Select pizza_type_id,
	pizza_size,
    price
FROM pizzas

-- ##################################################################################

-- Count all pizza entries
SELECT COUNT(*) AS count_all_pizzas
FROM pizza_type
-- Apply filter on category for Classic pizza types
where category = 'Classic';

-- ##################################################################################

-- Get information about the orders table
DESC TABLE orders

-- ##################################################################################

-- Convert order_id to VARCHAR aliasing to order_id_string
SELECT CAST(order_id AS VARCHAR) AS order_id_string
FROM orders

SELECT price, 
-- Convert price to NUMBER data type
price::NUMBER AS price_dollars
FROM pizzas

-- ##################################################################################

-- Capitalize each word in pizza_type_id
SELECT INITCAP(pizza_type_id) AS capitalized_pizza_id 
FROM pizza_type;

-- Combine the name and category columns
SELECT CONCAT(name, ' - ', category) AS name_and_category
FROM pizza_type

-- ##################################################################################

-- Select the current date, current time
SELECT CURRENT_DATE, CURRENT_TIME

-- Count the number of orders per day
SELECT count(*) AS orders_per_day, 
-- Extract the day of the week and alias to order_day
	EXTRACT(WEEKDAY FROM order_date) AS order_day
FROM orders
GROUP BY order_day
ORDER BY orders_per_day DESC

-- ##################################################################################

-- Get the month from order_date
SELECT EXTRACT(MONTH FROM order_date) AS order_month, 
    p.pizza_size, 
    -- Calculate revenue
    SUM(p.price * od.quantity) AS revenue
FROM orders o
INNER JOIN order_details od USING(order_id)
INNER JOIN pizzas p USING(pizza_id)
-- Appropriately group the query
GROUP BY ALL
-- Sort by revenue in descending order
ORDER BY revenue DESC;

-- ##################################################################################

SELECT
	-- Get the pizza category
    pt.category,
    SUM(p.price * od.quantity) AS total_revenue
FROM order_details AS od
NATURAL JOIN pizzas AS p
-- NATURAL JOIN the pizza_type table
NATURAL JOIN pizza_type AS pt
-- GROUP the records by category
GROUP BY pt.category
-- ORDER by total_revenue and limit the records
ORDER BY total_revenue DESC
LIMIT 1;

-- ##################################################################################

SELECT COUNT(o.order_id) AS total_orders,
        AVG(p.price) AS average_price,
        -- Calculate total revenue
        sum(p.price * od.quantity) AS total_revenue	
FROM orders AS o
LEFT JOIN order_details AS od
ON o.order_id = od.order_id
-- Use an appropriate JOIN with the pizzas table
LEFT JOIN pizzas AS p
ON od.pizza_id = p.pizza_id

SELECT COUNT(o.order_id) AS total_orders,
        AVG(p.price) AS average_price,
        -- Calculate total revenue
        SUM(p.price * od.quantity) AS total_revenue,
        -- Get the name from the pizza_type table
		pt.name AS pizza_name
FROM orders AS o
LEFT JOIN order_details AS od
ON o.order_id = od.order_id
-- Use an appropriate JOIN with the pizzas table
RIGHT JOIN pizzas p
ON od.pizza_id = p.pizza_id
-- NATURAL JOIN the pizza_type table
NATURAL JOIN pizza_type AS pt
GROUP BY pt.name, pt.category
ORDER BY total_revenue desc, total_orders desc

-- ##################################################################################

SELECT pt.name,
    pt.category,
    SUM(od.quantity) AS total_orders
FROM pizza_type pt
JOIN pizzas p
    ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od
    ON p.pizza_id = od.pizza_id
GROUP BY ALL
HAVING SUM(od.quantity) < (
  -- Calculate AVG of total_quantity
  SELECT avg(total_quantity)
  FROM (
    -- Calculate total_quantity
    SELECT sum(od.quantity) AS total_quantity
    FROM pizzas p
    JOIN order_details od 
    	ON p.pizza_id = od.pizza_id
    GROUP BY p.pizza_id
    -- Alias as subquery
  ) AS subquery
)

-- ##################################################################################

-- Create a CTE named most_ordered and limit the results 
WITH most_ordered AS (
    SELECT pizza_id, SUM(quantity) AS total_qty 
    FROM order_details GROUP BY pizza_id ORDER BY total_qty DESC
    LIMIT 1
)
-- Create CTE cheapest_pizza where price is equal to min price from pizzas table
, cheapest_pizza AS (
    SELECT pizza_id, price
    FROM pizzas 
    WHERE price = (SELECT MIN(price) FROM pizzas)
    LIMIT 1
)

SELECT pizza_id, 'Most Ordered' AS Description, total_qty AS metric
-- Select from the most_ordered CTE
FROM most_ordered
UNION ALL
SELECT pizza_id, 'Cheapest' AS Description, price AS metric
-- Select from the cheapest_pizza CTE
FROM cheapest_pizza

-- ##################################################################################

WITH filtered_orders AS (
  SELECT order_id, order_date 
  FROM orders 
  -- Filter records where order_date is greater than November 1, 2015
  WHERE order_date > '2015-11-01'
)

, filtered_pizza_type AS (
  SELECT name, pizza_type_id 
  FROM pizza_type 
  -- Filter the pizzas which are in the Veggie category
  WHERE category = 'Veggie'
)

SELECT fo.order_id, fo.order_date, fpt.name, od.quantity
-- Get the details from filtered_orders CTE
FROM filtered_orders AS fo
JOIN order_details AS od ON fo.order_id = od.order_id
JOIN pizzas AS p ON od.pizza_id = p.pizza_id
-- JOIN the filtered_pizza_type CTE on pizza_type_id
JOIN filtered_pizza_type AS fpt ON p.pizza_type_id = fpt.pizza_type_id

-- ##################################################################################
Querying JSON data

hours	= {	"Friday": "13:0-19:30",
  		"Monday": "13:0-21:30",
		"Thursday": "13:0-21:30",
 		"Tuesday": "13:0-21:30",
 		"Wednesday": "13:0-18:30"}

SELECT name,
    review_count,
    -- Retrieve the Saturday hours
    hours:Saturday,
    -- Retrieve the Sunday hours
    hours:Sunday
FROM yelp_business_data
-- Filter for Restaurants
WHERE categories LIKE '%Restaurant%'
    AND (hours:Saturday IS NOT NULL AND hours:Sunday IS NOT NULL)
    AND city = 'Philadelphia'
    AND stars = 5
ORDER BY review_count DESC

-- ##################################################################################
attributes = {	"BusinessParking": "{'garage': False, 
					'street': False, 
					'validated': False, 
					'lot': False, 
					'valet': False}",
  		"ByAppointmentOnly": "False",
  		"GoodForKids": "True"}

SELECT business_id, name
FROM yelp_business_data
WHERE categories ILIKE '%Restaurant%'
	-- Filter where DogsAllowed is '%True%'
	AND attributes:DogsAllowed ILIKE '%True%'
    -- Filter where BusinessAcceptsCreditCards is '%True%'
    AND attributes:BusinessAcceptsCreditCards ILIKE '%True%'
    AND city ILIKE '%Philadelphia%'
    AND stars = 5
