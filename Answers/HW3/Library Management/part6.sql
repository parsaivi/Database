CREATE
OR REPLACE VIEW Active_loans AS
SELECT
    m.first_name,
    m.last_name,
    b.title,
    b.author
FROM
    loans l
    JOIN members m ON l.member_id = m.member_id
    JOIN books b ON l.book_id = b.book_id
WHERE
    l.return_date IS NULL
ORDER BY
    m.last_name,
    m.first_name;

SELECT
    *
FROM
    Active_loans;

CREATE
OR REPLACE VIEW Popular_books AS
SELECT
    b.title,
    b.author,
    COUNT(l.book_id) AS total_loans
FROM
    books b
    LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY
    b.book_id,
    b.title,
    b.author
ORDER BY
    total_loans DESC;

SELECT
    *
FROM
    Popular_books;