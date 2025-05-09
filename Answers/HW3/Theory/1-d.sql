CREATE VIEW HighPaidEmployees AS
SELECT e.name AS employee_name, d.name AS department_name, e.salary
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
WHERE e.salary > 50000000
WITH CHECK OPTION;