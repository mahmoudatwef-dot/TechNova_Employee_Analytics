CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);
INSERT INTO departments (department_name)
VALUES
('IT'),
('HR'),
('Finance'),
('Sales'),
('Marketing');
SELECT * FROM departments;
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    birth_date DATE,
    hire_date DATE,
    salary DECIMAL(10,2),
    department_id INT,
    status VARCHAR(20),
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);
INSERT INTO employees
(first_name, last_name, gender, birth_date, hire_date, salary, department_id, status)
VALUES
('Ahmed', 'Ali', 'Male', '1998-05-12', '2022-03-10', 15000, 1, 'Active'),
('Sara', 'Mohamed', 'Female', '1997-08-20', '2021-07-15', 18000, 2, 'Active'),
('Omar', 'Hassan', 'Male', '1995-01-25', '2020-01-20', 22000, 1, 'Active'),
('Mona', 'Ibrahim', 'Female', '1999-11-03', '2023-06-01', 12000, 4, 'Active'),
('Youssef', 'Khaled', 'Male', '1996-04-17', '2019-09-12', 25000, 3, 'Left');
SELECT * FROM employees;

SELECT COUNT(*) AS total_employees
FROM employees;

SELECT AVG(salary) AS average_salary
FROM employees;

SELECT
    department_id,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department_id;

SELECT
    d.department_name,
    AVG(e.salary) AS average_salary
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
GROUP BY d.department_name;

SELECT
    d.department_name,
    COUNT(e.employee_id) AS total_employees
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
GROUP BY d.department_name;

SELECT
    first_name,
    last_name,
    salary
FROM employees
ORDER BY salary DESC
LIMIT 1;

SELECT
    first_name,
    last_name,
    salary
FROM employees
ORDER BY salary DESC
LIMIT 3;

SELECT
    d.department_name,
    SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_salary DESC;

SELECT
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary
FROM employees;

SELECT
    first_name,
    last_name,
    salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
ORDER BY salary DESC;

SELECT
    first_name,
    last_name,
    salary,
    CASE
        WHEN salary < 15000 THEN 'Low'
        WHEN salary <= 20000 THEN 'Medium'
        ELSE 'High'
    END AS salary_level
FROM employees;

SELECT
    CASE
        WHEN salary < 15000 THEN 'Low'
        WHEN salary <= 20000 THEN 'Medium'
        ELSE 'High'
    END AS salary_level,
    COUNT(*) AS total_employees
FROM employees
GROUP BY
    CASE
        WHEN salary < 15000 THEN 'Low'
        WHEN salary <= 20000 THEN 'Medium'
        ELSE 'High'
    END;

SELECT
    EXTRACT(YEAR FROM hire_date) AS hire_year,
    COUNT(*) AS total_hires
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
ORDER BY hire_year;

SELECT
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN status = 'Left' THEN 1 END) AS employees_left,
    ROUND(
        COUNT(CASE WHEN status = 'Left' THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate
FROM employees;

SELECT
    d.department_name,
    COUNT(e.employee_id) AS employees_left
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE e.status = 'Left'
GROUP BY d.department_name

SELECT
    d.department_name,
    COUNT(e.employee_id) AS total_employees,
    COUNT(CASE WHEN e.status = 'Left' THEN 1 END) AS employees_left,
    ROUND(
        COUNT(CASE WHEN e.status = 'Left' THEN 1 END) * 100.0
        / NULLIF(COUNT(e.employee_id), 0),
        2
    ) AS attrition_rate
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY attrition_rate DESC;

SELECT
    COUNT(*) AS total_rows,
    COUNT(first_name) AS first_name_filled,
    COUNT(last_name) AS last_name_filled,
    COUNT(gender) AS gender_filled,
    COUNT(birth_date) AS birth_date_filled,
    COUNT(hire_date) AS hire_date_filled,
    COUNT(salary) AS salary_filled,
    COUNT(department_id) AS department_filled,
    COUNT(status) AS status_filled
FROM employees;

SELECT
    first_name,
    last_name,
    salary
FROM employees
WHERE salary <= 0;

SELECT
    first_name,
    last_name,
    birth_date,
    hire_date
FROM employees
WHERE hire_date < birth_date;

SELECT
    first_name,
    last_name,
    COUNT(*) AS duplicate_count
FROM employees
GROUP BY
    first_name,
    last_name
HAVING COUNT(*) > 1;

SELECT
    status,
    COUNT(*) AS total_employees
FROM employees
GROUP BY status
ORDER BY total_employees DESC;

CREATE TABLE performance (
    performance_id SERIAL PRIMARY KEY,
    employee_id INT,
    performance_score DECIMAL(5,2),
    evaluation_date DATE,
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);

INSERT INTO performance
(employee_id, performance_score, evaluation_date)
VALUES
(1, 85.50, '2023-12-15'),
(1, 90.00, '2024-12-15'),
(2, 78.00, '2023-12-15'),
(2, 88.50, '2024-12-15'),
(3, 92.00, '2023-12-15'),
(3, 95.00, '2024-12-15'),
(4, 70.00, '2024-12-15'),
(5, 65.50, '2020-12-15');
SELECT *
FROM performance;

SELECT
    e.first_name,
    e.last_name,
    AVG(p.performance_score) AS average_performance
FROM performance p
JOIN employees e
    ON p.employee_id = e.employee_id
GROUP BY
    e.first_name,
    e.last_name
ORDER BY average_performance DESC;

SELECT
    d.department_name,
    AVG(p.performance_score) AS average_performance
FROM performance p
JOIN employees e
    ON p.employee_id = e.employee_id
JOIN departments d
    ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY average_performance DESC;

SELECT
    e.first_name,
    e.last_name,
    e.salary,
    AVG(p.performance_score) AS average_performance
FROM employees e
JOIN performance p
    ON e.employee_id = p.employee_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary
ORDER BY average_performance DESC;

SELECT
    CORR(e.salary, p.performance_score) AS salary_performance_correlation
FROM employees e
JOIN performance p
    ON e.employee_id = p.employee_id;

SELECT
    e.first_name,
    e.last_name,
    d.department_name,
    e.salary,
    e.status
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE e.status = 'Left';	

SELECT
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN status = 'Left' THEN 1 END) AS employees_left,
    ROUND(
        COUNT(CASE WHEN status = 'Left' THEN 1 END) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS attrition_rate
FROM employees;

SELECT
    e.first_name,
    e.last_name,
    d.department_name,
    e.salary,
    e.status
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE e.status = 'Active'
ORDER BY e.salary DESC;

CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,
    employee_id INT,
    attendance_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);

INSERT INTO attendance
(employee_id, attendance_date, status)
VALUES
(1, '2024-12-01', 'Present'),
(1, '2024-12-02', 'Present'),
(1, '2024-12-03', 'Late'),
(1, '2024-12-04', 'Present'),
(1, '2024-12-05', 'Absent'),

(2, '2024-12-01', 'Present'),
(2, '2024-12-02', 'Late'),
(2, '2024-12-03', 'Present'),
(2, '2024-12-04', 'Present'),
(2, '2024-12-05', 'Present'),

(3, '2024-12-01', 'Present'),
(3, '2024-12-02', 'Present'),
(3, '2024-12-03', 'Present'),
(3, '2024-12-04', 'Late'),
(3, '2024-12-05', 'Present'),

(4, '2024-12-01', 'Present'),
(4, '2024-12-02', 'Absent'),
(4, '2024-12-03', 'Present'),
(4, '2024-12-04', 'Late'),
(4, '2024-12-05', 'Present'),

(5, '2020-12-01', 'Absent'),
(5, '2020-12-02', 'Absent'),
(5, '2020-12-03', 'Present');

SELECT
    status,
    COUNT(*) AS total_records
FROM attendance
GROUP BY status
ORDER BY total_records DESC;

SELECT
    e.first_name,
    e.last_name,
    COUNT(*) AS absent_days
FROM attendance a
JOIN employees e
    ON a.employee_id = e.employee_id
WHERE a.status = 'Absent'
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name
ORDER BY absent_days DESC;

SELECT
    e.first_name,
    e.last_name,
    COUNT(*) AS total_days,
    COUNT(CASE WHEN a.status = 'Absent' THEN 1 END) AS absent_days,
    ROUND(
        COUNT(CASE WHEN a.status = 'Absent' THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS absence_rate
FROM attendance a
JOIN employees e
    ON a.employee_id = e.employee_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name
ORDER BY absence_rate DESC;

SELECT
    EXTRACT(YEAR FROM hire_date) AS hire_year,
    COUNT(*) AS total_hires
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
ORDER BY hire_year ASC;

SELECT
    e.first_name,
    e.last_name,
    e.salary,
    AVG(p.performance_score) AS average_performance
FROM employees e
JOIN performance p
    ON e.employee_id = p.employee_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary
ORDER BY average_performance DESC;

SELECT
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE first_name IS NULL) AS missing_first_name,
    COUNT(*) FILTER (WHERE last_name IS NULL) AS missing_last_name,
    COUNT(*) FILTER (WHERE salary IS NULL) AS missing_salary,
    COUNT(*) FILTER (WHERE department_id IS NULL) AS missing_department
FROM employees;

SELECT
    first_name,
    last_name,
    COUNT(*) AS duplicate_count
FROM employees
GROUP BY
    first_name,
    last_name
HAVING COUNT(*) > 1;

SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE salary <= 0;

SELECT
    SUM(salary) AS total_payroll
FROM employees;

SELECT
    SUM(salary) AS active_payroll
FROM employees
WHERE status = 'Active';

SELECT
    d.department_name,
    SUM(e.salary) AS total_payroll
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE e.status = 'Active'
GROUP BY d.department_name
ORDER BY total_payroll DESC;

SELECT
    e.first_name,
    e.last_name,
    e.salary,
    AVG(p.performance_score) AS average_performance
FROM employees e
JOIN performance p
    ON e.employee_id = p.employee_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary
ORDER BY average_performance DESC;

SELECT
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary,
    MAX(salary) - MIN(salary) AS salary_gap
FROM employees;

SELECT
    first_name,
    last_name,
    salary,
    CASE
        WHEN salary >= 20000 THEN 'High'
        WHEN salary >= 15000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_level
FROM employees
ORDER BY salary DESC;

SELECT
    first_name,
    last_name,
    hire_date,
    AGE(CURRENT_DATE, hire_date) AS service_period
FROM employees;

SELECT
    first_name,
    last_name,
    hire_date,
    EXTRACT(YEAR FROM hire_date) AS hire_year
FROM employees;

SELECT
    EXTRACT(YEAR FROM hire_date) AS hire_year,
    COUNT(*) AS total_hires
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
ORDER BY hire_year ASC;

SELECT
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE status = 'Left') AS left_employees,
    ROUND(
        COUNT(*) FILTER (WHERE status = 'Left') * 100.0 / COUNT(*),
        2
    ) AS attrition_rate
FROM employees;

SELECT
    d.department_name,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE e.status = 'Left') AS left_employees,
    ROUND(
        COUNT(*) FILTER (WHERE e.status = 'Left') * 100.0
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY attrition_rate DESC;

SELECT
    e.first_name,
    e.last_name,
    e.salary,
    AVG(p.performance_score) AS average_performance
FROM employees e
JOIN performance p
    ON e.employee_id = p.employee_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary
ORDER BY average_performance DESC;