------------------------------------------
/* GRANT on schema - once per database */
------------------------------------------

/* User */

DO
$$
DECLARE
	viewer_role text;
	user_role text;	
BEGIN
 SELECT  rolname FROM pg_roles WHERE rolname='tww_user_'||regexp_replace(current_catalog, 'tww_|teksi_', '') INTO user_role;
  IF FOUND THEN
	BEGIN
		EXECUTE FORMAT('GRANT ALL ON SCHEMA tww_ag6496 TO %I', user_role);
		EXECUTE FORMAT('GRANT ALL ON ALL TABLES IN SCHEMA tww_ag6496 TO %I', user_role);
		EXECUTE FORMAT('ALTER DEFAULT PRIVILEGES IN SCHEMA tww_ag6496 GRANT ALL ON TABLES TO %s TO %I', user_role);
    END
  ELSE
	GRANT ALL ON SCHEMA tww_ag6496 TO tww_user;
	GRANT ALL ON ALL TABLES IN SCHEMA tww_ag6496 TO tww_user;
	ALTER DEFAULT PRIVILEGES IN SCHEMA tww_ag6496 GRANT ALL ON TABLES TO tww_user;
  END IF; 

END;
$$