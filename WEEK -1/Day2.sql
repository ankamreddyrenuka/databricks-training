-- 21. Total salary for each department
SELECT department_id, SUM(salary) AS total_salary
FROM Employees
GROUP BY department_id;

-- 22. Average age of employees in each department
SELECT department_id, AVG(age) AS avg_age
FROM Employees
GROUP BY department_id;

-- 23. Number of employees hired in each year
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS total_employees
FROM Employees
GROUP BY YEAR(hire_date);

-- 24. Highest salary in each department
SELECT department_id, MAX(salary) AS highest_salary
FROM Employees
GROUP BY department_id;

-- 25. Department with the highest average salary
SELECT department_id
FROM Employees
GROUP BY department_id
ORDER BY AVG(salary) DESC
LIMIT 1;

-- 26. Departments with more than 2 employees
SELECT department_id
FROM Employees
GROUP BY department_id
HAVING COUNT(*) > 2;

-- 27. Departments with an average salary greater than 55000
SELECT department_id
FROM Employees
GROUP BY department_id
HAVING AVG(salary) > 55000;

-- 28. Years with more than 1 employee hired
SELECT YEAR(hire_date) AS hire_year
FROM Employees
GROUP BY YEAR(hire_date)
HAVING COUNT(*) > 1;

-- 29. Departments with a total salary expense less than 100000
SELECT department_id
FROM Employees
GROUP BY department_id
HAVING SUM(salary) < 100000;

-- 30. Departments with the maximum salary above 75000
SELECT department_id
FROM Employees
GROUP BY department_id
HAVING MAX(salary) > 75000;

-- 31. Employees ordered by salary ascending
SELECT *
FROM Employees
ORDER BY salary ASC;

-- 32. Employees ordered by age descending
SELECT *
FROM Employees
ORDER BY age DESC;

-- 33. Employees ordered by hire date ascending
SELECT *
FROM Employees
ORDER BY hire_date ASC;

-- 34. Employees ordered by department and salary
SELECT *
FROM Employees
ORDER BY department_id, salary ASC;

-- 35. Departments ordered by total salary of employees
SELECT department_id, SUM(salary) AS total_salary
FROM Employees
GROUP BY department_id
ORDER BY total_salary DESC;

-- 36. Employee names along with their department names
SELECT e.emp_name, d.department_name
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id;

-- 37. Project names along with department names
SELECT p.project_name, d.department_name
FROM Projects p
JOIN Departments d
ON p.department_id = d.department_id;

-- 38. Employee names and corresponding project names
SELECT e.emp_name, p.project_name
FROM Employees e
JOIN EmployeeProjects ep ON e.emp_id = ep.emp_id
JOIN Projects p ON ep.project_id = p.project_id;

-- 39. All employees and their departments, including those without a department
SELECT e.emp_name, d.department_name
FROM Employees e
LEFT JOIN Departments d
ON e.department_id = d.department_id;

-- 40. All departments and their employees, including departments without employees
SELECT d.department_name, e.emp_name
FROM Departments d
LEFT JOIN Employees e
ON d.department_id = e.department_id;

-- 41. Employees not assigned to any project
SELECT e.emp_name
FROM Employees e
LEFT JOIN EmployeeProjects ep
ON e.emp_id = ep.emp_id
WHERE ep.project_id IS NULL;

-- 42. Employees and the number of projects their department is working on
SELECT e.emp_name, COUNT(p.project_id) AS total_projects
FROM Employees e
LEFT JOIN Projects p
ON e.department_id = p.department_id
GROUP BY e.emp_id, e.emp_name;

-- 43. Departments that have no employees
SELECT d.department_name
FROM Departments d
LEFT JOIN Employees e
ON d.department_id = e.department_id
WHERE e.emp_id IS NULL;

-- 44. Employees who share the same department as John Doe
SELECT emp_name
FROM Employees
WHERE department_id = (
    SELECT department_id
    FROM Employees
    WHERE emp_name = 'John Doe'
);

-- 45. Department name with the highest average salary
SELECT d.department_name
FROM Departments d
JOIN Employees e
ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY AVG(e.salary) DESC
LIMIT 1;

-- 46. Employee with the highest salary
SELECT *
FROM Employees
WHERE salary = (
    SELECT MAX(salary)
    FROM Employees
);
-- 47. Employees whose salary is above the average salary
SELECT *
FROM Employees
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
);

-- 48. Second highest salary
SELECT MAX(salary) AS second_highest_salary
FROM Employees
WHERE salary < (
    SELECT MAX(salary)
    FROM Employees
);

-- 49. Department with the most employees
SELECT department_id
FROM Employees
GROUP BY department_id
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 50. Employees who earn more than the average salary of their department
SELECT *
FROM Employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE department_id = e.department_id
);

-- 51. 3rd highest salary (change OFFSET for nth highest)
SELECT salary
FROM Employees
ORDER BY salary DESC
LIMIT 1 OFFSET 2;

-- 52. Employees older than all employees in the HR department
SELECT *
FROM Employees
WHERE age > (
    SELECT MAX(age)
    FROM Employees e
    JOIN Departments d
    ON e.department_id = d.department_id
    WHERE d.department_name = 'HR'
);

-- 53. Departments where average salary is greater than 55000
SELECT department_id
FROM Employees
GROUP BY department_id
HAVING AVG(salary) > 55000;

-- 54. Employees who work in a department with at least 2 projects
SELECT *
FROM Employees
WHERE department_id IN (
    SELECT department_id
    FROM Projects
    GROUP BY department_id
    HAVING COUNT(*) >= 2
);

-- 55. Employees hired on the same date as Jane Smith
SELECT *
FROM Employees
WHERE hire_date = (
    SELECT hire_date
    FROM Employees
    WHERE emp_name = 'Jane Smith'
);

-- 56. Total salary of employees hired in the year 2020
SELECT SUM(salary) AS total_salary
FROM Employees
WHERE YEAR(hire_date) = 2020;

-- 57. Average salary of employees in each department ordered by average salary descending
SELECT department_id, AVG(salary) AS avg_salary
FROM Employees
GROUP BY department_id
ORDER BY avg_salary DESC;

-- 58. Departments with more than 1 employee and average salary greater than 55000
SELECT department_id
FROM Employees
GROUP BY department_id
HAVING COUNT(*) > 1
AND AVG(salary) > 55000;

-- 59. Employees hired in the last 2 years ordered by hire date
SELECT *
FROM Employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
ORDER BY hire_date;

-- 60. Total employees and average salary for departments with more than 2 employees
SELECT department_id,
       COUNT(*) AS total_employees,
       AVG(salary) AS avg_salary
FROM Employees
GROUP BY department_id
HAVING COUNT(*) > 2;

-- 61. Name and salary of employees whose salary is above their department average
SELECT emp_name, salary
FROM Employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE department_id = e.department_id
);

-- 62. Employees hired on the same date as the oldest employee
SELECT emp_name
FROM Employees
WHERE hire_date = (
    SELECT hire_date
    FROM Employees
    ORDER BY age DESC
    LIMIT 1
);

-- 63. Department names along with total number of projects
SELECT d.department_name,
       COUNT(p.project_id) AS total_projects
FROM Departments d
LEFT JOIN Projects p
ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_projects DESC;

-- 64. Employee name with the highest salary in each department
SELECT e.department_id,
       e.emp_name,
       e.salary
FROM Employees e
WHERE e.salary = (
    SELECT MAX(salary)
    FROM Employees
    WHERE department_id = e.department_id
);

-- 65. Names and salaries of employees older than the average age of their department
SELECT emp_name, salary
FROM Employees e
WHERE age > (
    SELECT AVG(age)
    FROM Employees
    WHERE department_id = e.department_id
);