WITH salary_groups AS (
    SELECT 
        employee_id,
        salary,
        NTILE(5) OVER (ORDER BY salary) AS rank_of_salary
    FROM 
        employees
)
SELECT 
    rank_of_salary,
    AVG(salary) AS avg_SALARY
FROM 
    salary_groups
GROUP BY 
    rank_of_salary
ORDER BY 
    rank_of_salary;
