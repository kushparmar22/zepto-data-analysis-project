
-- --- Creating a database ---


CREATE DATABASE zepto_SQL_project;


-- ---- Creating A Table ----

CREATE TABLE zepto(
	sku_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC (5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC (8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER);
    
 -- ------ Importing a Data in a table -------   
 
 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/zepto_v2.csv'
INTO TABLE zepto
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, @outOfStock, quantity)
SET outOfStock = CASE
    WHEN LOWER(TRIM(@outOfStock)) = 'true' THEN 1
    WHEN LOWER(TRIM(@outOfStock)) = 'false' THEN 0
    ELSE NULL
END;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

----- Checking a NULL Value --- 

SELECT * FROM zepto
WHERE name IS NULL 
OR category IS NULL
OR mrp IS NULL
OR discountPercent IS NULL
OR discountedSellingPrice IS NULL
OR outOfStock IS NULL
OR weightInGms IS NULL
OR availableQuantity IS NULL
OR quantity IS NULL;

 -- different product categories 
 
 SELECT distinct(category) from zepto
 order by category;
 
 -- product instock Vs outstock 
 
SELECT outOfStock, count(sku_id) 
from zepto
group by outOfStock;
 
 -- product names present multiple times 
 
 select name, count(sku_id) as occurance 
 from zepto
 group by name
 having occurance >1
 order by occurance DESC;
 
 -- Data Cleaning --- 
 
    -- product with price 0 -- 
    
    select *
    from zepto 
    where mrp = 0 OR discountedSellingPrice=0;
    
    DELETE  from zepto 
    where mrp = 0 OR sku_id IS NULL;
    
-- converted paisa into rs -- 

UPDATE zepto 
SET mrp = mrp/100.0,
	discountedSellingPrice = discountedSellingPrice/100.0;
    
select * FROM zepto;

-- Find the top 10 best value products based on the discount percentage ? 

select distinct(name),mrp, discountPercent 
 from zepto
 order by discountPercent DESC
 LIMIT 10;
 
 -- What are the products with high MRP but out of stock ? 
 
 select distinct( name) , mrp
 from zepto
 where outOfStock=1 and mrp >300
 order by mrp DESC;
 
 -- calculate estimated revenue by each catagory --
 
select category, sum(discountedSellingPrice*availableQuantity) as revenue 
from zepto
group by category
order by revenue DESC;

-- find all products where mrp is grater than 500 and discount is less than 10% -- 

select name, mrp, discountPercent
from zepto
where mrp > 500 and discountPercent<10
order by mrp desc;

-- identify the top 5 categories offering the highest average discount percentage -- 

select category, round(avg(discountPercent),2) as avg_discount 
from zepto
group by category
order by avg_discount desc
limit 5;

-- find the price per gram for products abov 100 gm and sort by best value -- 

select name, weightInGms, discountedSellingPrice, round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto
where weightInGms >=100
order by price_per_gram ;

-- group the product into catagories like low, medium, bulk 

select name, weightInGms, case when weightInGms < 1000 then "Low"
							   when weightInGms < 5000 then "Medium"
                               else "Bulk"
                               end as weight_category
from zepto;

-- what is the total inventory weight per category -- 

select category, sum(weightInGms*availableQuantity) as total_weight 
from zepto
group by category
order by total_weight;

    
    