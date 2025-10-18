-- Additional tables for comprehensive JOIN practice
-- File: initial-scripts/02-joins-practice-tables.sql
-- Description: Tables designed specifically for practicing different types of joins

-- Different tables involved:
-- 1. employees
-- 2. departments
-- 3. projects
-- 4. skills
-- 5. products
-- 6. suppliers
-- 7. categories

-- Departments table
CREATE TABLE departments (
                             dept_id SERIAL PRIMARY KEY,
                             dept_name VARCHAR(50) NOT NULL,
                             location VARCHAR(50),
                             budget DECIMAL(12,2)
);

-- Employees table
CREATE TABLE employees (
                           emp_id SERIAL PRIMARY KEY,
                           first_name VARCHAR(50) NOT NULL,
                           last_name VARCHAR(50) NOT NULL,
                           email VARCHAR(100),
                           dept_id INTEGER REFERENCES departments(dept_id),
                           salary DECIMAL(10,2),
                           hire_date DATE,
                           manager_id INTEGER REFERENCES employees(emp_id)  -- self-referencing FK
);

-- Projects table
CREATE TABLE projects (
                          project_id SERIAL PRIMARY KEY,
                          project_name VARCHAR(100) NOT NULL,
                          start_date DATE,
                          end_date DATE,
                          budget DECIMAL(12,2),
                          status VARCHAR(20) DEFAULT 'active'
);

-- Employee_Projects (many-to-many relationship)
CREATE TABLE employee_projects (
                                   emp_id INTEGER REFERENCES employees(emp_id),
                                   project_id INTEGER REFERENCES projects(project_id),
                                   role VARCHAR(50),
                                   hours_allocated INTEGER,
                                   PRIMARY KEY (emp_id, project_id)
);

-- Skills table
CREATE TABLE skills (
                        skill_id SERIAL PRIMARY KEY,
                        skill_name VARCHAR(50) NOT NULL,
                        category VARCHAR(30)
);

-- Employee_Skills (many-to-many relationship)
CREATE TABLE employee_skills (
                                 emp_id INTEGER REFERENCES employees(emp_id),
                                 skill_id INTEGER REFERENCES skills(skill_id),
                                 proficiency_level VARCHAR(20), -- 'Beginner', 'Intermediate', 'Advanced', 'Expert'
                                 years_experience INTEGER,
                                 PRIMARY KEY (emp_id, skill_id)
);

-- Suppliers table (for demonstrating joins with products)
CREATE TABLE suppliers (
                           supplier_id SERIAL PRIMARY KEY,
                           supplier_name VARCHAR(100) NOT NULL,
                           contact_person VARCHAR(50),
                           phone VARCHAR(20),
                           country VARCHAR(50)
);

-- Product_Suppliers (many-to-many relationship)
CREATE TABLE product_suppliers (
                                   product_id INTEGER REFERENCES products(product_id),
                                   supplier_id INTEGER REFERENCES suppliers(supplier_id),
                                   supply_price DECIMAL(10,2),
                                   lead_time_days INTEGER,
                                   PRIMARY KEY (product_id, supplier_id)
);

-- Categories table (for hierarchical joins)
CREATE TABLE categories (
                            category_id SERIAL PRIMARY KEY,
                            category_name VARCHAR(50) NOT NULL,
                            parent_category_id INTEGER REFERENCES categories(category_id),
                            description TEXT
);

-- Insert sample data for departments
INSERT INTO departments (dept_name, location, budget) VALUES
                                                          ('Engineering', 'San Francisco', 2000000.00),
                                                          ('Marketing', 'New York', 800000.00),
                                                          ('Sales', 'Chicago', 1200000.00),
                                                          ('HR', 'Austin', 500000.00),
                                                          ('Finance', 'New York', 600000.00),
                                                          ('R&D', 'Seattle', 1800000.00);

-- Insert sample data for employees
INSERT INTO employees (first_name, last_name, email, dept_id, salary, hire_date, manager_id) VALUES
-- Engineering Department
('Alice', 'Johnson', 'alice.johnson@company.com', 1, 120000, '2020-01-15', NULL),
('Bob', 'Smith', 'bob.smith@company.com', 1, 95000, '2020-03-20', 1),
('Charlie', 'Brown', 'charlie.brown@company.com', 1, 85000, '2021-06-10', 1),
('Diana', 'Davis', 'diana.davis@company.com', 1, 88000, '2021-09-05', 1),

-- Marketing Department
('Eve', 'Wilson', 'eve.wilson@company.com', 2, 75000, '2019-11-12', NULL),
('Frank', 'Miller', 'frank.miller@company.com', 2, 65000, '2020-07-18', 5),
('Grace', 'Taylor', 'grace.taylor@company.com', 2, 70000, '2021-02-28', 5),

-- Sales Department
('Henry', 'Anderson', 'henry.anderson@company.com', 3, 80000, '2018-05-20', NULL),
('Ivy', 'Thomas', 'ivy.thomas@company.com', 3, 72000, '2019-08-15', 8),
('Jack', 'Jackson', 'jack.jackson@company.com', 3, 68000, '2020-12-01', 8),

-- HR Department
('Karen', 'White', 'karen.white@company.com', 4, 85000, '2017-03-10', NULL),

-- Finance Department
('Liam', 'Harris', 'liam.harris@company.com', 5, 90000, '2018-09-25', NULL),

-- Employees without departments (for testing LEFT/RIGHT joins)
('Mike', 'Clark', 'mike.clark@company.com', NULL, 75000, '2022-01-10', NULL),
('Nancy', 'Lewis', 'nancy.lewis@company.com', NULL, 68000, '2022-02-15', NULL);

-- Insert sample data for projects
INSERT INTO projects (project_name, start_date, end_date, budget, status) VALUES
                                                                              ('Mobile App Development', '2023-01-01', '2023-12-31', 500000, 'active'),
                                                                              ('Website Redesign', '2023-03-15', '2023-09-30', 200000, 'active'),
                                                                              ('Data Analytics Platform', '2023-02-01', '2024-01-31', 800000, 'active'),
                                                                              ('Marketing Campaign Q3', '2023-07-01', '2023-09-30', 150000, 'completed'),
                                                                              ('Customer Support System', '2023-05-01', '2023-11-30', 300000, 'active'),
                                                                              ('Legacy System Migration', '2022-06-01', '2023-03-31', 1000000, 'completed'),
-- Project with no assigned employees
                                                                              ('Future AI Project', '2024-01-01', '2024-12-31', 2000000, 'planned');

-- Insert sample data for employee_projects
INSERT INTO employee_projects (emp_id, project_id, role, hours_allocated) VALUES
-- Mobile App Development
(1, 1, 'Project Lead', 160),
(2, 1, 'Senior Developer', 160),
(3, 1, 'Junior Developer', 160),

-- Website Redesign
(2, 2, 'Lead Developer', 120),
(4, 2, 'Frontend Developer', 120),
(6, 2, 'Designer', 100),

-- Data Analytics Platform
(1, 3, 'Technical Architect', 80),
(4, 3, 'Data Engineer', 160),

-- Marketing Campaign Q3
(5, 4, 'Campaign Manager', 120),
(6, 4, 'Content Creator', 100),
(7, 4, 'Social Media Manager', 80),

-- Customer Support System
(3, 5, 'Backend Developer', 160),
(11, 5, 'Business Analyst', 120);

-- Insert sample data for skills
INSERT INTO skills (skill_name, category) VALUES
                                              ('Python', 'Programming'),
                                              ('JavaScript', 'Programming'),
                                              ('Java', 'Programming'),
                                              ('SQL', 'Database'),
                                              ('PostgreSQL', 'Database'),
                                              ('React', 'Frontend'),
                                              ('Node.js', 'Backend'),
                                              ('Docker', 'DevOps'),
                                              ('AWS', 'Cloud'),
                                              ('Project Management', 'Management'),
                                              ('Data Analysis', 'Analytics'),
                                              ('Machine Learning', 'Analytics'),
                                              ('Photoshop', 'Design'),
                                              ('Figma', 'Design'),
                                              ('Marketing Strategy', 'Marketing');

-- Insert sample data for employee_skills
INSERT INTO employee_skills (emp_id, skill_id, proficiency_level, years_experience) VALUES
-- Alice (Engineering Manager)
(1, 1, 'Expert', 8),
(1, 4, 'Advanced', 6),
(1, 10, 'Advanced', 5),

-- Bob (Senior Developer)
(2, 1, 'Advanced', 5),
(2, 2, 'Advanced', 6),
(2, 6, 'Intermediate', 3),
(2, 7, 'Advanced', 4),

-- Charlie (Junior Developer)
(3, 1, 'Intermediate', 2),
(3, 2, 'Beginner', 1),
(3, 8, 'Beginner', 1),

-- Diana (Data Engineer)
(4, 1, 'Advanced', 4),
(4, 4, 'Expert', 5),
(4, 5, 'Expert', 5),
(4, 11, 'Advanced', 3),

-- Eve (Marketing Manager)
(5, 15, 'Expert', 7),
(5, 10, 'Advanced', 5),

-- Frank (Marketing Specialist)
(6, 13, 'Advanced', 4),
(6, 14, 'Intermediate', 2),

-- Some employees with no skills (for testing joins)
-- Henry, Ivy, Jack have no skills recorded

-- Skills with no employees (for testing joins)
-- Machine Learning (skill_id 12) has no employees;

-- Insert sample data for suppliers
INSERT INTO suppliers (supplier_name, contact_person, phone, country) VALUES
    ('TechSupplier Inc', 'John Tech', '+1-555-0101', 'USA'),
    ('ElectroWorld', 'Maria Electronics', '+44-20-7946-0958', 'UK'),
    ('FurniturePlus', 'David Furniture', '+49-30-12345678', 'Germany'),
    ('ApplianceKing', 'Sarah Appliance', '+1-555-0202', 'USA'),
    ('GlobalTech Solutions', 'Ahmed Global', '+971-4-123-4567', 'UAE'),
-- Supplier with no products
    ('NewSupplier Co', 'Lisa New', '+1-555-0303', 'Canada');

-- Insert sample data for product_suppliers
INSERT INTO product_suppliers (product_id, supplier_id, supply_price, lead_time_days) VALUES
-- Laptop Pro (product_id 1)
(1, 1, 999.99, 14),
(1, 5, 1050.00, 21),

-- Wireless Headphones (product_id 2)
(2, 1, 149.99, 7),
(2, 2, 159.99, 10),

-- Office Chair (product_id 3)
(3, 3, 199.99, 30),

-- Smartphone (product_id 4)
(4, 1, 549.99, 14),
(4, 5, 579.99, 18),

-- Coffee Maker (product_id 6)
(6, 4, 69.99, 14),

-- Bluetooth Speaker (product_id 7)
(7, 2, 59.99, 7);

-- Products without suppliers: Desk Lamp (5), Standing Desk (8)
-- Supplier without products: NewSupplier Co (6)

-- Insert sample data for categories (hierarchical structure)
INSERT INTO categories (category_name, parent_category_id, description) VALUES
-- Top level categories
('Electronics', NULL, 'All electronic devices'),
('Furniture', NULL, 'Office and home furniture'),
('Appliances', NULL, 'Home and kitchen appliances'),

-- Electronics subcategories
('Computers', 1, 'Laptops, desktops, tablets'),
('Audio', 1, 'Headphones, speakers, audio equipment'),
('Mobile Devices', 1, 'Smartphones, tablets, accessories'),

-- Furniture subcategories
('Office Furniture', 2, 'Chairs, desks, office equipment'),
('Lighting', 2, 'Lamps, light fixtures'),

-- Appliances subcategories
('Kitchen Appliances', 3, 'Coffee makers, blenders, etc.');

-- Create some useful views for join practice
CREATE VIEW employee_department_view AS
SELECT
    e.emp_id,
    e.first_name,
    e.last_name,
    e.email,
    e.salary,
    d.dept_name,
    d.location as dept_location
FROM employees e
         LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- Summary comment
-- This database now supports practicing:
-- 1. INNER JOIN - employees with departments, products with suppliers
-- 2. LEFT JOIN - all employees (including those without departments)
-- 3. RIGHT JOIN - all departments (including those without employees like R&D)
-- 4. FULL OUTER JOIN - all employees and departments
-- 5. CROSS JOIN - cartesian product examples
-- 6. SELF JOIN - employees with their managers
-- 7. Multiple table joins - employees, departments, projects together
-- 8. Many-to-many joins - employees with projects, employees with skills