CREATE ASSERTION check_max_seats AS
CHECK (NOT EXISTS (
    SELECT c.course_id, COUNT(e.student_id) AS enrolled_count, c.max_seats
    FROM Course c
    JOIN Enrollment e ON c.course_id = e.course_id
    GROUP BY c.course_id, c.max_seats
    HAVING COUNT(e.student_id) > c.max_seats
));