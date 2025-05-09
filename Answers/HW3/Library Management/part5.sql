CREATE TABLE IF NOT EXISTS book_copies (
    book_id INTEGER PRIMARY KEY REFERENCES books(book_id),
    total_copies INTEGER DEFAULT 5 NOT NULL,
    available_copies INTEGER DEFAULT 5 NOT NULL,
    CHECK (available_copies >= 0 AND available_copies <= total_copies)
);

INSERT INTO book_copies (book_id)
SELECT book_id FROM books
ON CONFLICT (book_id) DO NOTHING;

UPDATE book_copies bc
SET available_copies = total_copies - (
    SELECT COUNT(*) 
    FROM loans l 
    WHERE l.book_id = bc.book_id AND l.return_date IS NULL
);

CREATE OR REPLACE FUNCTION check_book_availability()
RETURNS TRIGGER AS $$
DECLARE
    available INT;
BEGIN
    SELECT available_copies INTO available
    FROM book_copies
    WHERE book_id = NEW.book_id;
    
    IF available <= 0 THEN
        RAISE EXCEPTION 'No available copies for book ID %', NEW.book_id;
    END IF;

    UPDATE book_copies
    SET available_copies = available_copies - 1
    WHERE book_id = NEW.book_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_book_copies_trigger
BEFORE INSERT ON loans
FOR EACH ROW
EXECUTE FUNCTION check_book_availability();

CREATE OR REPLACE FUNCTION update_book_availability_on_return()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.return_date IS NOT NULL AND OLD.return_date IS NULL THEN
        RAISE NOTICE 'Book with ID % has been returned', NEW.book_id;
        UPDATE book_copies
        SET available_copies = available_copies + 1
        WHERE book_id = NEW.book_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER book_return_trigger
AFTER UPDATE ON loans
FOR EACH ROW
EXECUTE FUNCTION update_book_availability_on_return();

