------------------------------------------
/* GRANT on schema - once per database */
------------------------------------------

/* User */


DO
$$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname='tww_user_{db_identifier}') THEN
	GRANT ALL ON SCHEMA tww_ag6496 TO tww_user_{db_identifier};
	GRANT ALL ON ALL TABLES IN SCHEMA tww_ag6496 TO tww_user_{db_identifier};
	GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_ag6496 TO tww_user_{db_identifier};
	GRANT ALL ON ALL TABLES IN SCHEMA tww_cfg TO tww_user_{db_identifier};
	ALTER DEFAULT PRIVILEGES IN SCHEMA tww_ag6496 GRANT ALL ON TABLES TO tww_user_{db_identifier};
	ALTER DEFAULT PRIVILEGES IN SCHEMA tww_ag6496 GRANT ALL ON SEQUENCES TO tww_user_{db_identifier};
  ELSE
	GRANT ALL ON SCHEMA tww_ag6496 TO tww_user;
	GRANT ALL ON ALL TABLES IN SCHEMA tww_ag6496 TO tww_user;
	GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_ag6496 TO tww_user;
	GRANT ALL ON ALL TABLES IN SCHEMA tww_cfg TO tww_user;
	ALTER DEFAULT PRIVILEGES IN SCHEMA tww_ag6496 GRANT ALL ON TABLES TO tww_user;
	ALTER DEFAULT PRIVILEGES IN SCHEMA tww_ag6496 GRANT ALL ON SEQUENCES TO tww_user;
  END IF;
END;
$$