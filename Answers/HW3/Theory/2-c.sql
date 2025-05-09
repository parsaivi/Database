CREATE OR REPLACE FUNCTION check_max_seats_func()
RETURNS TRIGGER AS $$
DECLARE
    current_enrollment INTEGER;
    max_seats_limit INTEGER;
BEGIN
    SELECT COUNT(*) INTO current_enrollment
    FROM Enrollment
    WHERE course_id = NEW.course_id;
    
    SELECT max_seats INTO max_seats_limit
    FROM Course
    WHERE course_id = NEW.course_id;
    
    IF (current_enrollment + 1) > max_seats_limit THEN
        RAISE EXCEPTION 'The capacity of the course with code % is full. (Maximum capacity: %)', 
                        NEW.course_id, max_seats_limit;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_max_seats_trigger
BEFORE INSERT ON Enrollment
FOR EACH ROW
EXECUTE FUNCTION check_max_seats_func();