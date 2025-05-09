SELECT 
    e.employee_id,
    e.first_name,
    d.department_name AS department,
    e.salary,
    dept_avg.avg_salary
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
JOIN 
    (
        SELECT 
            department_id,
            AVG(salary) AS avg_salary
        FROM 
            employees
        GROUP BY 
            department_id
    ) dept_avg ON e.department_id = dept_avg.department_id
WHERE 
    e.salary > dept_avg.avg_salary
ORDER BY 
    d.department_name,
    e.salary DESC;
