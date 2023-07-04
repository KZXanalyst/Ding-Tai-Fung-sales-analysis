USE DingTaiFung;

-- Joining the 3 tables together and ranking by largest orders to least

SELECT 
m.product_name,
m.category,
d.order_id,
d.item_id,
d.price,
mo.date,
mo.total
FROM menu m
JOIN detail d
ON m.product_id = d.item_id
JOIN more mo
ON d.order_id = mo.order_id
ORDER BY total DESC;

-- Ranking order count for products

SELECT 
m.product_name,
m.category,
m.price as item_price,
COUNT(m.product_name) as order_count,
SUM(d.price) as total_sales
FROM menu m
JOIN detail d
ON m.product_id = d.item_id
JOIN more mo
ON d.order_id = mo.order_id
GROUP BY m.product_name, m.category, m.price
ORDER BY order_count DESC;

-- Ranking total sales per product

SELECT 
m.product_name,
m.category,
m.price as item_price,
COUNT(m.product_name) as order_count,
SUM(d.price) as total_sales
FROM menu m
JOIN detail d
ON m.product_id = d.item_id
JOIN more mo
ON d.order_id = mo.order_id
GROUP BY m.product_name, m.category, m.price
ORDER BY total_sales DESC;

-- Ranking products by total sales for a specific date

SELECT 
m.product_name,
m.category,
m.price as item_price,
COUNT(m.product_name) as order_count,
SUM(d.price) as total_sales,
mo.date
FROM menu m
JOIN detail d
ON m.product_id = d.item_id
JOIN more mo
ON d.order_id = mo.order_id
GROUP BY m.product_name, m.category, m.price, mo.date
ORDER BY total_sales DESC;

-- Ranking dates by total sales

SELECT 
	mo.date,
	SUM(d.price) as total_sales,
	RANK() OVER (ORDER BY SUM(d.price) DESC) as sales_rank
FROM 
menu m
JOIN 
detail d
ON 
m.product_id = d.item_id
JOIN 
more mo
ON 
d.order_id = mo.order_id
GROUP BY 
mo.date
ORDER BY 
sales_rank;

-- Ranking products by average sales

SELECT 
m.product_name,
m.category,
m.price as item_price,
COUNT(m.product_name) as order_count,
COUNT(m.product_name) * m.price as total_revenue,
(COUNT(m.product_name) * m.price) / COUNT(DISTINCT DATE(mo.date)) as avg_daily_revenue
FROM menu m
JOIN detail d
ON m.product_id = d.item_id
JOIN more mo
ON d.order_id = mo.order_id
GROUP BY m.product_name, m.category, m.price
ORDER BY avg_daily_revenue DESC;

-- Comparing at the average order for every product per day before and after feature launch

SELECT 
    m.product_name,
    m.price,
    COUNT(CASE WHEN mo.date < '2023-04-01' THEN d.price ELSE NULL END) / COUNT(DISTINCT CASE WHEN mo.date < '2023-04-01' THEN mo.date ELSE NULL END) as avg_order_count_per_day_before,
    COUNT(CASE WHEN mo.date >= '2023-04-01' THEN d.price ELSE NULL END) / COUNT(DISTINCT CASE WHEN mo.date >= '2023-04-01' THEN mo.date ELSE NULL END) as avg_order_count_per_day_after,
    ((COUNT(CASE WHEN mo.date >= '2023-04-01' THEN d.price ELSE NULL END) / COUNT(DISTINCT CASE WHEN mo.date >= '2023-04-01' THEN mo.date ELSE NULL END)) - 
     (COUNT(CASE WHEN mo.date < '2023-04-01' THEN d.price ELSE NULL END) / COUNT(DISTINCT CASE WHEN mo.date < '2023-04-01' THEN mo.date ELSE NULL END))) / 
    (COUNT(CASE WHEN mo.date < '2023-04-01' THEN d.price ELSE NULL END) / COUNT(DISTINCT CASE WHEN mo.date < '2023-04-01' THEN mo.date ELSE NULL END)) * 100 as percentage_increase
FROM 
    menu m
JOIN 
    detail d ON m.product_id = d.item_id
JOIN 
    more mo ON d.order_id = mo.order_id
GROUP BY 
    m.product_name,
    m.price;

-- Sales per day of the week

SELECT 
    DAYOFWEEK(mo.date) as day_of_week,
    AVG(d.price) as avg_sales
FROM 
    detail d
JOIN 
    more mo ON d.order_id = mo.order_id
GROUP BY 
    day_of_week
ORDER BY 
    avg_sales DESC;
    
-- Ranking categories based on daily sales
    
SELECT 
m.category,
SUM(d.price) as total_sales,
AVG(d.price) as average_price,
COUNT(*) as total_items,
SUM(d.price) / COUNT(DISTINCT DATE(mo.date)) as avg_daily_sales
FROM menu m
JOIN detail d
ON m.product_id = d.item_id
JOIN more mo
ON d.order_id = mo.order_id
GROUP BY m.category
ORDER BY avg_daily_sales DESC;

