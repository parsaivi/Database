WITH RECURSIVE EmployeeHierarchy AS (
    -- Base case: select all employees
    SELECT 
        EmployeeId,
        FirstName,
        LastName,
        ReportsTo,
        1 AS Level
    FROM 
        Employee
    
    UNION ALL
    
    -- Recursive case: join with employees who report to the current employee
    SELECT 
        e.EmployeeId,
        e.FirstName,
        e.LastName,
        e.ReportsTo,
        eh.Level + 1
    FROM 
        Employee e
        INNER JOIN EmployeeHierarchy eh ON e.ReportsTo = eh.EmployeeId
)

SELECT 
    m.EmployeeId,
    m.FirstName || ' ' || m.LastName AS ManagerName,
    COUNT(e.EmployeeId) AS total_managed
FROM 
    Employee m
    INNER JOIN EmployeeHierarchy e ON e.ReportsTo = m.EmployeeId
GROUP BY 
    m.EmployeeId, 
    m.FirstName, 
    m.LastName
ORDER BY 
    total_managed DESC;