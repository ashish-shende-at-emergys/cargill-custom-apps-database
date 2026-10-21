-- =====================================================================
-- app.usp_team_list - team names for the Admin Configuration team filter / Add Member
-- Request:  none
-- Response: SETOF app.udt_lookup_value_result
-- =====================================================================
CREATE OR REPLACE FUNCTION app.usp_team_list()
RETURNS SETOF app.udt_lookup_value_result
LANGUAGE sql
STABLE
AS $$
    SELECT name::varchar(160), (row_number() OVER (ORDER BY id))::integer
    FROM app.teams
    ORDER BY id;
$$;
