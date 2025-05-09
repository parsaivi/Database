CREATE OR REPLACE PROCEDURE membership_renewal(p_member_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    total_fines INT DEFAULT 0;
    v_message TEXT;
BEGIN
    SELECT COALESCE(SUM(
        CASE
            WHEN return_date IS NULL AND CURRENT_DATE > due_date
            THEN (CURRENT_DATE - due_date) * 500
            WHEN return_date IS NOT NULL AND return_date > due_date
            THEN (return_date - due_date) * 500
            ELSE 0
        END
    ), 0) INTO total_fines
    FROM loans
    WHERE member_id = p_member_id;

    IF total_fines < 10000 THEN
        v_message := 'Member ID ' || p_member_id || ' has total fines of ' || total_fines || '. Membership renewed successfully.';
    ELSE
        v_message := 'Member ID ' || p_member_id || ' has total fines of ' || total_fines || '. Membership renewal failed due to excessive fines.';
    END IF;

    RAISE NOTICE '%', v_message;
END;
$$;

DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT member_id FROM members WHERE member_id IS NOT NULL
    LOOP
        CALL membership_renewal(rec.member_id);
    END LOOP;
END $$;