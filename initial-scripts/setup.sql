-- Sample database for mastering SQL
-- This script creates sample tables and data for learning SQL concepts

-- Create customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
    country VARCHAR(50),
    created_date DATE DEFAULT CURRENT_DATE
);

-- Create products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER DEFAULT 0,
    created_date DATE DEFAULT CURRENT_DATE
);

-- Create orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending'
);

-- Create order_items table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

-- Insert sample customers
INSERT INTO customers (first_name, last_name, email, city, country) VALUES
('John', 'Doe', 'john.doe@email.com', 'New York', 'USA'),
('Jane', 'Smith', 'jane.smith@email.com', 'London', 'UK'),
('Mike', 'Johnson', 'mike.johnson@email.com', 'Toronto', 'Canada'),
('Sarah', 'Williams', 'sarah.williams@email.com', 'Sydney', 'Australia'),
('David', 'Brown', 'david.brown@email.com', 'Berlin', 'Germany');

-- Insert sample products
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Laptop Pro', 'Electronics', 1299.99, 50),
('Wireless Headphones', 'Electronics', 199.99, 100),
('Office Chair', 'Furniture', 299.99, 25),
('Smartphone', 'Electronics', 699.99, 75),
('Desk Lamp', 'Furniture', 49.99, 200),
('Coffee Maker', 'Appliances', 89.99, 30),
('Bluetooth Speaker', 'Electronics', 79.99, 60),
('Standing Desk', 'Furniture', 399.99, 15);

-- Insert sample orders
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2024-01-15', 1499.98, 'completed'),
(2, '2024-01-16', 199.99, 'completed'),
(3, '2024-01-17', 349.98, 'shipped'),
(1, '2024-01-18', 699.99, 'completed'),
(4, '2024-01-19', 129.98, 'pending');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1299.99),  -- Laptop Pro
(1, 2, 1, 199.99),   -- Wireless Headphones
(2, 2, 1, 199.99),   -- Wireless Headphones
(3, 3, 1, 299.99),   -- Office Chair
(3, 5, 1, 49.99),    -- Desk Lamp
(4, 4, 1, 699.99),   -- Smartphone
(5, 6, 1, 89.99),    -- Coffee Maker
(5, 7, 1, 79.99);    -- Bluetooth Speaker

-- Create indexes for better performance (learning about indexes)
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- Add some views for learning (advanced SQL concepts)
CREATE VIEW customer_order_summary AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) as total_orders,
    COALESCE(SUM(o.total_amount), 0) as total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;