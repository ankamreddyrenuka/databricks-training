-- SQL example for filtering and selection
SELECT customer_id, first_name, last_name, city
FROM customers
WHERE city = 'Springfield'
ORDER BY customer_id;
