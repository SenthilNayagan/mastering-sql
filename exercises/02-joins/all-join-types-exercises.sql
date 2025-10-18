-- Complete JOIN Types Practice Exercises
-- File: exercises/02-joins/all-join-types-exercises.sql
-- Description: Comprehensive exercises for all types of SQL joins

-- =============================================================================
-- 1. INNER JOIN - Returns only matching records from both tables
-- =============================================================================

-- Basic INNER JOIN: Employees with their departments
SELECT
    e.first_name,
    e.last_name,
    d.dept_name,
    d.location
FROM employees e
         INNER JOIN departments d ON e.dept_id = d.dept_id;

-- Multiple table INNER JOIN: Employees, departments, and their projects
SELECT
    e.first_name || ' ' || e.last_name as employee_name,
    d.dept_name,
    p.project_name,
    ep.role
FROM employees e
         INNER JOIN departments d ON e.dept_id = d.dept_id
         INNER JOIN employee_projects ep ON e.emp_id = ep.emp_id
         INNER JOIN projects p ON ep.project_id = p.project_id;

-- INNER JOIN with aggregation: Products with supplier count
SELECT
    p.product_name,
    p.price,
    COUNT(ps.supplier_id) as supplier_count,
    AVG(ps.supply_price) as avg_supply_price
FROM products p
         INNER JOIN product_suppliers ps ON p.product_id = ps.product_id
GROUP BY p.product_id, p.product_name, p.price;


-- =============================================================================
-- 2. LEFT JOIN (LEFT OUTER JOIN) - All records from left table + matching from right
-- =============================================================================

-- Basic LEFT JOIN: All employees (including those without departments)
SELECT
    e.first_name,
    e.last_name,
    e.salary,
    COALESCE(d.dept_name, 'No Department') as department
FROM employees e
         LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- LEFT JOIN to find employees without projects
SELECT
    e.first_name || ' ' || e.last_name as employee_name,
    e.salary,
    COUNT(ep.project_id) as project_count
FROM employees e
         LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
GROUP BY e.emp_id, e.first_name, e.last_name, e.salary
ORDER BY project_count;

-- LEFT JOIN to find products without suppliers
SELECT
    p.product_name,
    p.price,
    ps.supplier_id
FROM products p
         LEFT JOIN product_suppliers ps ON p.product_id = ps.product_id
WHERE ps.supplier_id IS NULL;


-- =============================================================================
-- 3. RIGHT JOIN (RIGHT OUTER JOIN) - All records from right table + matching from left
-- =============================================================================

-- Basic RIGHT JOIN: All departments (including those without employees)
SELECT
    COALESCE(e.first_name || ' ' || e.last_name, 'No Employees') as employee_name,
    d.dept_name,
    d.location,
    d.budget
FROM employees e
         RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- RIGHT JOIN to find departments without employees
SELECT
    d.dept_name,
    d.location,
    d.budget,
    COUNT(e.emp_id) as employee_count
FROM employees e
         RIGHT JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name, d.location, d.budget
HAVING COUNT(e.emp_id) = 0;

-- RIGHT JOIN to find suppliers without products
SELECT
    s.supplier_name,
    s.country,
    COUNT(ps.product_id) as product_count
FROM product_suppliers ps
         RIGHT JOIN suppliers s ON ps.supplier_id = s.supplier_id
GROUP BY s.supplier_id, s.supplier_name, s.country
ORDER BY product_count;


-- =============================================================================
-- 4. FULL OUTER JOIN - All records from both tables
-- =============================================================================

-- Basic FULL OUTER JOIN: All employees and all departments
SELECT
    COALESCE(e.first_name || ' ' || e.last_name, 'No Employee') as employee_name,
    COALESCE(d.dept_name, 'No Department') as department_name,
    e.salary,
    d.budget
FROM employees e
         FULL OUTER JOIN departments d ON e.dept_id = d.dept_id;

-- FULL OUTER JOIN to see complete picture: products and suppliers
SELECT
    COALESCE(p.product_name, 'No Product') as product_name,
    COALESCE(s.supplier_name, 'No Supplier') as supplier_name,
    ps.supply_price,
    ps.lead_time_days
FROM products p
         FULL OUTER JOIN product_suppliers ps ON p.product_id = ps.product_id
         FULL OUTER JOIN suppliers s ON ps.supplier_id = s.supplier_id
ORDER BY p.product_name, s.supplier_name;


-- =============================================================================
-- 5. CROSS JOIN - Cartesian product of all records
-- =============================================================================

-- Basic CROSS JOIN: All possible employee-project combinations (be careful - large result!)
SELECT
    e.first_name || ' ' || e.last_name as employee_name,
    p.project_name
FROM employees e
         CROSS JOIN projects p
WHERE e.dept_id = 1  -- Limiting to engineering dept to reduce results
ORDER BY employee_name, project_name;

-- CROSS JOIN for creating combinations: Skills by proficiency levels
SELECT
    s.skill_name,
    levels.level
FROM skills s
         CROSS JOIN (
    VALUES ('Beginner'), ('Intermediate'), ('Advanced'), ('Expert')
) AS levels(level)
WHERE s.category = 'Programming'
ORDER BY s.skill_name, levels.level;


-- =============================================================================
-- 6. SELF JOIN - Joining a table with itself
-- =============================================================================

-- Basic SELF JOIN: Employees and their managers
SELECT
    emp.first_name || ' ' || emp.last_name as employee_name,
    emp.salary as employee_salary,
    mgr.first_name || ' ' || mgr.last_name as manager_name,
    mgr.salary as manager_salary
FROM employees emp
         LEFT JOIN employees mgr ON emp.manager_id = mgr.emp_id;

-- SELF JOIN: Find employees who earn more than their managers
SELECT
    emp.first_name || ' ' || emp.last_name as employee_name,
    emp.salary as employee_salary,
    mgr.first_name || ' ' || mgr.last_name as manager_name,
    mgr.salary as manager_salary
FROM employees emp
         INNER JOIN employees mgr ON emp.manager_id = mgr.emp_id
WHERE emp.salary > mgr.salary;

-- SELF JOIN: Hierarchical categories (parent-child relationships)
SELECT
    parent.category_name as parent_category,
    child.category_name as child_category,
    child.description
FROM categories parent
         INNER JOIN categories child ON parent.category_id = child.parent_category_id
ORDER BY parent.category_name, child.category_name;


-- =============================================================================
-- 7. ADVANCED JOIN COMBINATIONS
-- =============================================================================

-- Multiple JOINs: Employee skills with experience levels
SELECT
    e.first_name || ' ' || e.last_name as employee_name,
    d.dept_name,
    s.skill_name,
    s.category,
    es.proficiency_level,
    es.years_experience
FROM employees e
         INNER JOIN departments d ON e.dept_id = d.dept_id
         INNER JOIN employee_skills es ON e.emp_id = es.emp_id
         INNER JOIN skills s ON es.skill_id = s.skill_id
ORDER BY employee_name, s.category, s.skill_name;

-- Complex JOIN: Project participation with department info
SELECT
    p.project_name,
    p.status,
    e.first_name || ' ' || e.last_name as employee_name,
    d.dept_name,
    ep.role,
    ep.hours_allocated
FROM projects p
         LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
         LEFT JOIN employees e ON ep.emp_id = e.emp_id
         LEFT JOIN departments d ON e.dept_id = d.dept_id
ORDER BY p.project_name, d.dept_name, employee_name;

-- JOIN with subquery: Employees working on high-budget projects
SELECT
    e.first_name || ' ' || e.last_name as employee_name,
    d.dept_name,
    high_budget_projects.project_name,
    high_budget_projects.budget
FROM employees e
         INNER JOIN departments d ON e.dept_id = d.dept_id
         INNER JOIN employee_projects ep ON e.emp_id = ep.emp_id
         INNER JOIN (
    SELECT project_id, project_name, budget
    FROM projects
    WHERE budget > 500000
) as high_budget_projects ON ep.project_id = high_budget_projects.project_id;


-- =============================================================================
-- 8. JOIN PERFORMANCE AND ANALYSIS QUERIES
-- =============================================================================

-- Find departments with no employees using LEFT JOIN
SELECT
    d.dept_name,
    d.budget
FROM departments d
         LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;

-- Find employees with no skills using LEFT JOIN
SELECT
    e.first_name || ' ' || e.last_name as employee_name,
    e.hire_date
FROM employees e
         LEFT JOIN employee_skills es ON e.emp_id = es.emp_id
WHERE es.emp_id IS NULL;

-- Find skills that no employee has using RIGHT JOIN
SELECT
    s.skill_name,
    s.category
FROM employee_skills es
         RIGHT JOIN skills s ON es.skill_id = s.skill_id
WHERE es.skill_id IS NULL;

-- Department statistics using multiple JOINs
SELECT
    d.dept_name,
    COUNT(DISTINCT e.emp_id) as total_employees,
    COUNT(DISTINCT ep.project_id) as total_projects,
    AVG(e.salary) as avg_salary,
    SUM(ep.hours_allocated) as total_project_hours
FROM departments d
         LEFT JOIN employees e ON d.dept_id = e.dept_id
         LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_employees DESC;


-- =============================================================================
-- 9. PRACTICAL JOIN EXERCISES - Try These Yourself!
-- =============================================================================

-- EXERCISE 1: Find all customers who have never placed an order (use existing tables)
-- Hint: Use LEFT JOIN between customers and orders

-- EXERCISE 2: List all products with their categories, including products without suppliers
-- Hint: You'll need to join products, product_suppliers, and suppliers

-- EXERCISE 3: Find employees who work on the same projects (excluding themselves)
-- Hint: Use SELF JOIN on employee_projects table

-- EXERCISE 4: Create a report showing each employee's manager's department
-- Hint: Multiple JOINs needed - employee -> manager -> department

-- EXERCISE 5: Find departments that have employees but no active projects
-- Hint: Use EXISTS or complex JOINs with conditions

-- =============================================================================
-- Summary of what each JOIN type shows:
-- INNER JOIN: Only matching records (intersection)
-- LEFT JOIN: All from left + matching from right
-- RIGHT JOIN: All from right + matching from left
-- FULL OUTER JOIN: All records from both tables (union)
-- CROSS JOIN: Every combination (cartesian product)
-- SELF JOIN: Table joined with itself for hierarchical data
-- =============================================================================