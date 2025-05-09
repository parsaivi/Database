WITH
    books_of_the_year AS (
        SELECT
            book_id,
            COUNT(*) AS total_loans_this_year
        FROM
            loans
        WHERE
            EXTRACT(
                YEAR
                FROM
                    loan_date
            ) = EXTRACT(
                YEAR
                FROM
                    CURRENT_DATE
            )
        GROUP BY
            book_id
        HAVING
            COUNT(*) > 0
    ),
    last_month_loans AS (
        SELECT
            book_id,
            COUNT(*) AS total_loans_last_month
        FROM
            loans
        WHERE
            loan_date >= CURRENT_DATE - INTERVAL '1 month'
        GROUP BY
            book_id
        HAVING
            COUNT(*) > 0
    )
SELECT
    b.book_id,
    b.title,
    b.author,
    by.total_loans_this_year AS total_loans_this_year
FROM
    books b
    Join books_of_the_year by ON b.book_id = by.book_id
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            books_of_the_year by
            JOIN last_month_loans lm ON by.book_id = lm.book_id
    )
ORDER BY
    total_loans_this_year DESC;