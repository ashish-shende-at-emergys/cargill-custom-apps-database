-- =====================================================================
-- app.usp_lookup_get_all - dropdown sources for the Create / Bulk invoice modals and filters
-- Request:  none
-- Response: app.udt_lookups_result - vendors = app.udt_vendor_result[] (active, by name),
--           stations / teams = app.udt_lookup_value_result[]
-- =====================================================================
CREATE OR REPLACE FUNCTION app.usp_lookup_get_all()
RETURNS app.udt_lookups_result
LANGUAGE sql
STABLE
AS $$
    SELECT
        coalesce((SELECT jsonb_agg(to_jsonb(ROW(v.id, v.legal_name, v.cuit)::app.udt_vendor_result) ORDER BY v.legal_name)
                  FROM app.vendors v WHERE v.is_active), '[]'::jsonb),
        coalesce((SELECT jsonb_agg(to_jsonb(ROW(s.display_name, s.rn)::app.udt_lookup_value_result) ORDER BY s.rn)
                  FROM (SELECT display_name, (row_number() OVER (ORDER BY display_name))::integer AS rn
                        FROM app.country_stations) s), '[]'::jsonb),
        coalesce((SELECT jsonb_agg(to_jsonb(t) ORDER BY t.sort_order) FROM app.usp_team_list() t), '[]'::jsonb);
$$;
