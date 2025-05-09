SELECT DISTINCT
    d.division,
    d.department,
    FIRST_VALUE(d.department) OVER (
        PARTITION BY d.division
        ORDER BY d.department
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_department_in_division,
    LAST_VALUE(d.department) OVER (
        PARTITION BY d.division
        ORDER BY d.department
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_department_in_division
FROM 
    departments d
ORDER BY 
    d.division,
    d.department;
