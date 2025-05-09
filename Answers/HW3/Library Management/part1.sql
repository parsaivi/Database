DROP FUNCTION calculate_lateness();
CREATE OR REPLACE FUNCTION calculate_lateness()
RETURNS TABLE (
    member_id_result INTEGER,
    first_name_result VARCHAR(50),
    last_name_result VARCHAR(50),
    membership_status_result BOOLEAN,
    total_debt_result NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH late_loans AS (
        SELECT
            l.member_id,
            m.first_name,
            m.last_name,
            m.membership_status,
            l.book_id,
            l.loan_date,
            l.return_date,
            l.due_date,
            CASE
                WHEN l.return_date IS NULL THEN
                    GREATEST(0, CURRENT_DATE - l.due_date)
                ELSE
                    GREATEST(0, l.return_date - l.due_date)
            END AS days_late,
            CASE
                WHEN l.return_date IS NULL THEN
                    CAST(GREATEST(0, CURRENT_DATE - l.due_date) * 5000 AS NUMERIC)
                ELSE
                    CAST(GREATEST(0, l.return_date - l.due_date) * 5000 AS NUMERIC)
            END AS debt_amount
        FROM loans l
        JOIN members m ON l.member_id = m.member_id
    ),
    member_debts AS (
        SELECT
            late_loans.member_id,
            late_loans.first_name,
            late_loans.last_name,
            late_loans.membership_status,
            SUM(late_loans.debt_amount) AS total_debt
        FROM late_loans
        GROUP BY late_loans.member_id, late_loans.first_name, late_loans.last_name, late_loans.membership_status
    )
    SELECT
        member_debts.member_id,
        member_debts.first_name,
        member_debts.last_name,
        member_debts.membership_status,
        CAST(member_debts.total_debt AS NUMERIC)
    FROM member_debts
    ORDER BY member_debts.total_debt DESC;
END;
$$ LANGUAGE plpgsql;

-- فراخوانی تابع برای مشاهده نتیجه
SELECT * FROM calculate_lateness();