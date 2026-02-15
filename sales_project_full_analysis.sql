-- ============================================
-- SALES DATA ANALYSIS PROJECT
-- Author: Mendie
-- Database: MySQL
-- Description: End-to-end SQL project including
-- database creation, data generation, and analysis
-- ============================================


-- Create Database
CREATE DATABASE IF NOT EXISTS sales_project;
USE sales_project;


-- Drop table if it already exists (for reproducibility)
DROP TABLE IF EXISTS sales;


-- Create Sales Table
CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    product VARCHAR(50),
    category VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2)
);


-- Remove old procedure if it exists
DROP PROCEDURE IF EXISTS generate_sales_data;


-- Procedure to Generate 100 Random Rows
DELIMITER //

CREATE PROCEDURE generate_sales_data()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 100 DO
        INSERT INTO sales (
            order_id,
            order_date,
            customer_id,
            product,
            category,
            quantity,
            price
        )
        VALUES (
            i,
            DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND()*120) DAY),
            FLOOR(100 + RAND()*20),
            ELT(FLOOR(1 + RAND()*6),
                'Laptop','Phone','Tablet','Monitor','Desk','Headphones'),
            ELT(FLOOR(1 + RAND()*3),
                'Electronics','Furniture','Accessories'),
            FLOOR(1 + RAND()*5),
            ROUND(50 + (RAND()*1150), 2)
        );

        SET i = i + 1;
    END WHILE;

END //

DELIMITER ;


-- Generate Data
CALL generate_sales_data();


-- =========================
-- BUSINESS ANALYSIS QUERIES
-- =========================


-- Total Revenue
SELECT SUM(quantity * price) AS total_revenue
FROM sales;


-- Revenue by Category
SELECT category,
       SUM(quantity * price) AS revenue
FROM sales
GROUP BY category
ORDER BY revenue DESC;


-- Top 5 Products by Revenue
SELECT product,
       SUM(quantity * price) AS revenue
FROM sales
GROUP BY product
ORDER BY revenue DESC
LIMIT 5;


-- Top 5 Customers by Revenue
SELECT customer_id,
       SUM(quantity * price) AS revenue
FROM sales
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 5;


-- Monthly Revenue Trend
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(quantity * price) AS revenue
FROM sales
GROUP BY month
ORDER BY month;
