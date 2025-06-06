
-- COALESCE
/* 1. Our favourite manager wants a detailed long list of products, but is afraid of tables! 
We tell them, no problem! We can produce a list with all of the appropriate details. 

Using the following syntax you create our super cool and not at all needy manager a list:

SELECT 
product_name || ', ' || product_size|| ' (' || product_qty_type || ')'
FROM product

But wait! The product table has some bad data (a few NULL values). 
Find the NULLs and then using COALESCE, replace the NULL with a 
blank for the first problem, and 'unit' for the second problem. 
 */
SELECT 
    product_name || ', ' || 
    COALESCE(product_size, '') || ' (' || 
    COALESCE(product_qty_type, 'unit') || ')' AS product_details
FROM product;


--Windowed Functions
/* 1. Write a query that selects from the customer_purchases table and numbers each customer’s  
visits to the farmer’s market (labeling each market date with a different number). 
Each customer’s first visit is labeled 1, second visit is labeled 2, etc. 

You can either display all rows in the customer_purchases table, with the counter changing on
each new market date for each customer, or select only the unique market dates per customer 
(without purchase details) and number those visits.  */

SELECT DISTINCT customer_id, market_date
,DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY market_date DESC) as drank
FROM customer_purchases;

/* 2. Reverse the numbering of the query from a part so each customer’s most recent visit is labeled 1, 
then write another query that uses this one as a subquery (or temp table) and filters the results to 
only the customer’s most recent visit. */
SELECT customer_id, market_date 

FROM
(
		SELECT DISTINCT customer_id, market_date
		,DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY market_date DESC) as drank
		FROM customer_purchases
)x
WHERE drank=1


/* 3. Using a COUNT() window function, include a value along with each row of the 
customer_purchases table that indicates how many different times that customer has purchased that product_id. */

SELECT DISTINCT customer_id, product_id
,COUNT(*) OVER (PARTITION BY customer_id, product_id) AS total_purchases
FROM customer_purchases

-- String manipulations
/* 1. Some product names in the product table have descriptions like "Jar" or "Organic". 
These are separated from the product name with a hyphen. 
Create a column using SUBSTR (and a couple of other commands) that captures these, but is otherwise NULL. 
Remove any trailing or leading whitespaces. Don't just use a case statement for each product! 

| product_name               | description |
|----------------------------|-------------|
| Habanero Peppers - Organic | Organic     |
 */

SELECT product_name,
CASE
		   WHEN INSTR(product_name, 'Jar') > 0 THEN TRIM(SUBSTR(product_name, INSTR(product_name, '-') + 1)) 
		   WHEN INSTR(product_name, 'Organic') > 0 THEN TRIM(SUBSTR(product_name, INSTR(product_name, '-') + 1)) 
		   ELSE NULL
END AS description
FROM product;



/* 2. Filter the query to show any product_size value that contains a number with REGEXP. */

SELECT product_size
FROM product
WHERE product_size REGEXP '^[0-9]';

-- UNION
/* 1. Using a UNION, write a query that displays the market dates with the highest and lowest total sales. */

WITH Salesbydate AS (
    
    SELECT market_date, SUM(quantity * cost_to_customer_per_qty) AS total_sales
    FROM customer_purchases
    GROUP BY market_date
),
Rankedsales AS (
   
    SELECT market_date, total_sales,
           RANK() OVER (ORDER BY total_sales DESC) AS highest_rank,
           RANK() OVER (ORDER BY total_sales ASC) AS lowest_rank
    FROM Salesbydate
)

SELECT market_date, total_sales, 'best day' AS sale_category
FROM RankedSales
WHERE highest_rank = 1

UNION

SELECT market_date, total_sales, 'worst day' AS sale_category
FROM RankedSales
WHERE lowest_rank = 1;



/* SECTION 3 */

-- Cross Join
/*1. Suppose every vendor in the `vendor_inventory` table had 5 of each of their products to sell to **every** 
customer on record. How much money would each vendor make per product? 
Show this by vendor_name and product name, rather than using the IDs.  */

WITH vendor_sales AS (
    
    SELECT 
        v.vendor_id, 
        v.vendor_name, 
        p.product_name, 
        (vi.original_price * 5) AS revenue_per_customer
    FROM vendor_inventory vi
    CROSS JOIN customer c
    INNER JOIN vendor v ON vi.vendor_id = v.vendor_id
    INNER JOIN product p ON vi.product_id = p.product_id
)


SELECT 
    vendor_name, 
    product_name, 
    SUM(revenue_per_customer) AS total_revenue
FROM vendor_sales
GROUP BY vendor_name, product_name
ORDER BY vendor_name, product_name;


-- INSERT
/*1.  Create a new table "product_units". 
This table will contain only products where the `product_qty_type = 'unit'`. 
It should use all of the columns from the product table, as well as a new column for the `CURRENT_TIMESTAMP`.  
Name the timestamp column `snapshot_timestamp`. */

DROP TABLE IF EXISTS product_units;

CREATE TABLE product_units AS

SELECT 
    product_id, 
	product_name,
    product_size, 
    product_category_id, 
    product_qty_type, 
    CURRENT_TIMESTAMP AS snapshot_timestamp
FROM product
WHERE product_qty_type = 'unit'



/*2. Using `INSERT`, add a new row to the product_units table (with an updated timestamp). 
This can be any product you desire (e.g. add another record for Apple Pie). */

INSERT INTO product_units
VALUES('24','Apple pie', 'medium','5','unit',CURRENT_TIMESTAMP)

-- DELETE
/* 1. Delete the older record for the whatever product you added. 

HINT: If you don't specify a WHERE clause, you are going to have a bad time.*/
DELETE FROM product_units
--SELECT *
--FROM product_units
WHERE product_id = '24' AND product_name = 'Apple pie' 


-- UPDATE
/* 1.We want to add the current_quantity to the product_units table. 
First, add a new column, current_quantity to the table using the following syntax.

ALTER TABLE product_units
ADD current_quantity INT;

Then, using UPDATE, change the current_quantity equal to the last quantity value from the vendor_inventory details.  */

UPDATE product_units 
SET current_quantity = (
    SELECT COALESCE(MAX(vi.quantity), 0) 
    FROM vendor_inventory vi
    WHERE vi.product_id = product_units.product_id
)
WHERE product_units.product_id = product_id;


