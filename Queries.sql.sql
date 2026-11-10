-- ============================================
-- SQL Business Analytics Project
-- Database: sales_analytics
-- ============================================

-- 1. Creating database
CREATE DATABASE IF NOT EXISTS sales_analytics;
USE sales_analytics;

-- 2. Creating tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 3. Inserting sample data
INSERT INTO Customers VALUES
(1, 'Alice', 'Chennai', 'India'),
(2, 'Bob', 'Mumbai', 'India'),
(3, 'Charlie', 'Delhi', 'India'),
(4, 'David', 'Bangalore', 'India'),
(5, 'Eve', 'Hyderabad', 'India');

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 45000),
(102, 'Mouse', 'Electronics', 500),
(103, 'Desk', 'Furniture', 8000),
(104, 'Chair', 'Furniture', 3000),
(105, 'Keyboard', 'Electronics', 1200);

INSERT INTO Orders VALUES
(1001, 1, 101, '2025-01-05', 1),
(1002, 1, 102, '2025-01-06', 2),
(1003, 2, 103, '2025-01-07', 1),
(1004, 3, 101, '2025-01-08', 1),
(1005, 4, 104, '2025-01-09', 2),
(1006, 5, 105, '2025-01-10', 3),
(1007, 2, 102, '2025-01-11', 5),
(1008, 3, 103, '2025-01-12', 1);

-- 4. Analytical Queries

-- Query 1: Top customers by revenue
SELECT 
    c.customer_name,
    SUM(o.quantity * p.price) AS total_spent
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- Query 2: Monthly revenue trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(quantity * (SELECT price FROM Products WHERE Products.product_id = Orders.product_id)) AS revenue
FROM Orders
GROUP BY month
ORDER BY month;

-- Query 3: Average order value by category
SELECT 
    p.category,
    AVG(o.quantity * p.price) AS avg_order_value
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
GROUP BY p.category;

-- Query 4: Best and worst selling products
SELECT 
    p.product_name,
    SUM(o.quantity) AS total_quantity_sold,
    SUM(o.quantity * p.price) AS total_revenue
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;
