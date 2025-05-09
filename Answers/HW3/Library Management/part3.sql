CREATE OR REPLACE FUNCTION validate_loan()
RETURNS TRIGGER AS $$
DECLARE
    is_book_available BOOLEAN;
    is_member_active BOOLEAN;
BEGIN
    SELECT availability_status INTO is_book_available
    FROM books
    WHERE book_id = NEW.book_id;

    IF NOT is_book_available THEN
        RAISE EXCEPTION 'Book with ID % is not available for loan', NEW.book_id;
    END IF;

    SELECT membership_status INTO is_member_active
    FROM members
    WHERE member_id = NEW.member_id;

    IF NOT is_member_active THEN
        RAISE EXCEPTION 'Member with ID % does not have an active membership', NEW.member_id;
    END IF;

    UPDATE books
    SET availability_status = FALSE
    WHERE book_id = NEW.book_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER loan_validation_trigger
BEFORE INSERT ON loans
FOR EACH ROW
EXECUTE FUNCTION validate_loan();