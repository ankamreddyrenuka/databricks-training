-- Databricks notebook source
-- MAGIC %md
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Remove rows with missing customer_id from both datasets**

-- COMMAND ----------


CREATE OR REPLACE TEMP VIEW customers_clean AS
SELECT *
FROM read_files('/Volumes/workspace/default/customers', format => 'csv', header => true)
WHERE customer_id IS NOT NULL;

CREATE OR REPLACE TEMP VIEW orders_clean AS
SELECT *
FROM read_files('/Volumes/workspace/default/customers/orders.csv', format => 'csv', header => true)
WHERE customer_id IS NOT NULL;




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ** Total order amount for each customer**

-- COMMAND ----------


SELECT
  customer_id,
  SUM(total_amount) AS total_total_amount
FROM orders_clean
GROUP BY customer_id;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Top 3 customers by total spend**

-- COMMAND ----------


SELECT
  customer_id,
  SUM(total_amount) AS total_spend
FROM orders_clean
GROUP BY customer_id
ORDER BY total_spend DESC
LIMIT 3;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Customers with no orders**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC

-- COMMAND ----------


SELECT
  c.customer_id,
  c.*
FROM customers_clean c
LEFT ANTI JOIN orders_clean o
ON c.customer_id = o.customer_id;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **City-wise total revenue**

-- COMMAND ----------


SELECT
  c.city,
  SUM(o.total_amount) AS total_revenue
FROM customers_clean c
JOIN orders_clean o
ON c.customer_id = o.customer_id
GROUP BY c.city;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Average order amount per customer**

-- COMMAND ----------


SELECT
  customer_id,
  AVG(total_amount) AS avg_total_amount
FROM orders_clean
GROUP BY customer_id;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ****

-- COMMAND ----------


SELECT
  customer_id,
  COUNT(*) AS order_count
FROM orders_clean
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC Sort customers by total spend descending
-- MAGIC
-- MAGIC

-- COMMAND ----------

-- Sort customers by total spend descending
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  c.email,
  c.phone_number,
  c.address,
  c.city,
  c.state,
  c.zip_code,
  COALESCE(SUM(o.total_amount), 0) AS total_spend
FROM customers_clean c
LEFT JOIN orders_clean o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.phone_number, c.address, c.city, c.state, c.zip_code
ORDER BY total_spend DESC;