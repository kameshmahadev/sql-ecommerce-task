
-- Create the ecommerce database
CREATE DATABASE ecommerce;

-- Use the ecommerce database
USE ecommerce;

-- Create the customers table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    address TEXT
);

-- Create the products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    description TEXT
);

-- Create the orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Insert sample customers
INSERT INTO customers (name, email, address) VALUES
('Alice', 'alice@example.com', '123 Main St'),
('Bob', 'bob@example.com', '456 Maple Ave'),
('Charlie', 'charlie@example.com', '789 Oak Blvd');

-- Insert sample products
INSERT INTO products (name, price, description) VALUES
('Product A', 50.00, 'Description of Product A'),
('Product B', 30.00, 'Description of Product B'),
('Product C', 40.00, 'Description of Product C'),
('Product D', 75.00, 'Description of Product D');

-- Insert sample orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, CURDATE(), 120.00),
(2, CURDATE() - INTERVAL 10 DAY, 200.00),
(1, CURDATE() - INTERVAL 35 DAY, 90.00),
(3, CURDATE() - INTERVAL 5 DAY, 300.00);

-- 1. Customers who placed an order in the last 30 days
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;

-- 2. Total amount of all orders placed by each customer
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id;

-- 3. Update the price of Product C to 45.00
UPDATE products
SET price = 45.00
WHERE name = 'Product C';

-- 4. Add a new column discount to the products table
ALTER TABLE products
ADD discount DECIMAL(5,2) DEFAULT 0.00;

-- 5. Top 3 products with the highest price
SELECT *
FROM products
ORDER BY price DESC
LIMIT 3;

-- 7. Join orders and customers to get customer's name and order date
SELECT c.name, o.order_date
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- 8. Orders with total amount > 150.00
SELECT *
FROM orders
WHERE total_amount > 150.00;

-- Normalize: Create order_items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Sample data for order_items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 50.00),
(2, 2, 3, 30.00),
(3, 3, 1, 40.00),
(4, 1, 4, 50.00);

-- 6. Customers who have ordered Product A
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';

-- 10. Average total of all orders
SELECT AVG(total_amount) AS average_order_value
FROM orders;
