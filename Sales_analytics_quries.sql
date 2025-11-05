ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

ALTER TABLE products
ADD PRIMARY KEY (product_id);

-- See what columns exist in products table
SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'products';

ALTER TABLE date
ADD PRIMARY KEY (date_id);

-- First, convert the column to proper date type
ALTER TABLE date
ALTER COLUMN order_date TYPE date USING order_date::date;


ALTER TABLE sales
ADD PRIMARY KEY (order_id);

ALTER TABLE sales 
ADD CONSTRAINT fk_customer_id 
FOREIGN KEY (customer_id) REFERENCES customers(customer_id); 

ALTER TABLE sales 
ADD CONSTRAINT fk_product_id 
FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE sales 
ADD CONSTRAINT fk_date_id 
FOREIGN KEY (date_id) REFERENCES date(date_id);

ALTER TABLE sales ALTER COLUMN product_id TYPE bigint USING product_id::bigint;



-- Average monthly sales per product with category info
SELECT 
    p.product_id,
    p.category,
    p.sub_category,
    SUM(s.amount) / COUNT(DISTINCT DATE_TRUNC('month', d.order_date)) AS avg_monthly_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN date d ON s.date_id = d.date_id
GROUP BY p.product_id, p.category, p.sub_category
ORDER BY avg_monthly_sales DESC;

-- By Category
SELECT 
    p.category,
    SUM(s.amount) / COUNT(DISTINCT DATE_TRUNC('month', d.order_date::date)) AS avg_monthly_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN date d ON s.date_id = d.date_id
GROUP BY p.category
ORDER BY avg_monthly_sales DESC;



-- Average monthly sales per product
SELECT 
    s.product_id,
    s.category,
    SUM(s.amount) / COUNT(DISTINCT DATE_TRUNC('month', s.order_date::date)) AS avg_monthly_sales,
    SUM(s.profit) / COUNT(DISTINCT DATE_TRUNC('month', s.order_date::date)) AS avg_monthly_profit
FROM sales s
GROUP BY s.product_id, s.category
ORDER BY avg_monthly_sales DESC;


-- Average monthly sales by category
SELECT 
    s.category,
    SUM(s.amount) / COUNT(DISTINCT DATE_TRUNC('month', s.order_date::date)) AS avg_monthly_sales,
    SUM(s.profit) / COUNT(DISTINCT DATE_TRUNC('month', s.order_date::date)) AS avg_monthly_profit,
    COUNT(DISTINCT s.order_id) AS total_orders
FROM sales s
GROUP BY s.category
ORDER BY avg_monthly_sales DESC;

-- Average monthly sales with subcategory

SELECT 
    p.category,
    p.sub_category,
    SUM(s.amount) / COUNT(DISTINCT DATE_TRUNC('month', s.order_date::date)) AS avg_monthly_sales,
    SUM(s.profit) / COUNT(DISTINCT DATE_TRUNC('month', s.order_date::date)) AS avg_monthly_profit
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category, p.sub_category
ORDER BY avg_monthly_sales DESC;

-- Cities with revenue above 95th percentile
WITH city_revenue AS (
    SELECT 
        s.city,
        s.state,
        SUM(s.amount) AS total_revenue,
        SUM(s.profit) AS total_profit,
        COUNT(DISTINCT s.order_id) AS num_orders,
        COUNT(DISTINCT s.customer_id) AS num_customers
    FROM sales s
    GROUP BY s.city, s.state
)
SELECT 
    city,
    state,
    total_revenue,
    total_profit,
    num_orders,
    num_customers,
    ROUND((total_profit / total_revenue * 100), 2) AS profit_margin_pct
FROM city_revenue
WHERE total_revenue > (
    SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY total_revenue)
    FROM city_revenue
)
ORDER BY total_revenue DESC;

-- Monthly profits over time
SELECT 
    DATE_TRUNC('month', s.order_date::date) AS month,
    SUM(s.amount) AS monthly_revenue,
    SUM(s.profit) AS monthly_profit,
    COUNT(DISTINCT s.order_id) AS num_orders,
    COUNT(DISTINCT s.customer_id) AS num_customers,
    ROUND((SUM(s.profit) / NULLIF(SUM(s.amount), 0) * 100), 2) AS profit_margin_pct
FROM sales s
GROUP BY DATE_TRUNC('month', s.order_date::date)
ORDER BY month;

-- Monthly profits by category
SELECT 
    DATE_TRUNC('month', s.order_date::date) AS month,
    s.category,
    SUM(s.amount) AS monthly_revenue,
    SUM(s.profit) AS monthly_profit,
    COUNT(DISTINCT s.order_id) AS num_orders
FROM sales s
GROUP BY DATE_TRUNC('month', s.order_date::date), s.category
ORDER BY month, monthly_profit DESC;

-- Top 20 customers by revenue and profit
SELECT 
    s.customer_id,
    s.customername,
    s.city,
    s.state,
    SUM(s.amount) AS total_revenue,
    SUM(s.profit) AS total_profit,
    COUNT(DISTINCT s.order_id) AS num_orders,
    ROUND(AVG(s.amount), 2) AS avg_order_value,
    ROUND((SUM(s.profit) / NULLIF(SUM(s.amount), 0) * 100), 2) AS profit_margin_pct
FROM sales s
GROUP BY s.customer_id, s.customername, s.city, s.state
ORDER BY total_revenue DESC
LIMIT 20;

-- Cities with profit margin below 10%
WITH city_metrics AS (
    SELECT 
        s.city,
        s.state,
        SUM(s.amount) AS total_revenue,
        SUM(s.profit) AS total_profit,
        COUNT(DISTINCT s.order_id) AS num_orders,
        COUNT(DISTINCT s.customer_id) AS num_customers,
        ROUND((SUM(s.profit) / NULLIF(SUM(s.amount), 0) * 100), 2) AS profit_margin_pct
    FROM sales s
    GROUP BY s.city, s.state
)
SELECT 
    city,
    state,
    total_revenue,
    total_profit,
    num_orders,
    num_customers,
    profit_margin_pct
FROM city_metrics
WHERE profit_margin_pct < 10  -- Low profitability threshold
  AND total_revenue > 5000     -- Minimum revenue to be significant
ORDER BY profit_margin_pct ASC;











