-- =====================================================================
-- app.usp_invoice_update_status - change an invoice's workflow status
-- Request:  p_invoice_code, p_status (Pending | Approved | Processed | Rejected)
-- Response: app.udt_row_count_result
-- Errors:   CA400 invalid status, CA404 invoice not found
-- =====================================================================
CREATE OR REPLACE FUNCTION app.usp_invoice_update_status(p_invoice_code text, p_status text)
RETURNS app.udt_row_count_result
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows integer;
BEGIN
    IF p_status IS NULL OR p_status NOT IN ('Pending', 'Approved', 'Processed', 'Rejected') THEN
        RAISE EXCEPTION 'Status must be one of Pending, Approved, Processed, Rejected.' USING ERRCODE = 'CA400';
    END IF;

    UPDATE app.invoices SET status = p_status, updated_at = now() WHERE invoice_code = p_invoice_code;
    GET DIAGNOSTICS v_rows = ROW_COUNT;
    IF v_rows = 0 THEN
        RAISE EXCEPTION 'Invoice not found.' USING ERRCODE = 'CA404';
    END IF;

    RETURN ROW(v_rows)::app.udt_row_count_result;
END;
$$;
