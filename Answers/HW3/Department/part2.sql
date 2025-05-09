SELECT 
    e.first_name,
    e.hire_date,
    d.department,
    e.salary,
    SUM(e.salary) OVER (
        PARTITION BY e.department
        ORDER BY e.hire_date
    ) AS running_total
FROM 
    employees e
JOIN 
    departments d ON e.department = d.department
ORDER BY 
    d.department, 
    e.hire_date;
