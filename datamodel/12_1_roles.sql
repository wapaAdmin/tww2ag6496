------------------------------------------
/* GRANT on schemas - once per database */
------------------------------------------

/* Viewer */
GRANT USAGE ON SCHEMA tww_od  TO tww_viewer;
GRANT USAGE ON SCHEMA tww_sys TO tww_viewer;
GRANT USAGE ON SCHEMA tww_vl  TO tww_viewer;
GRANT USAGE ON SCHEMA tww_cfg  TO tww_viewer;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_od  TO tww_viewer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_sys TO tww_viewer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_vl  TO tww_viewer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA tww_cfg  TO tww_viewer;

GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_od  TO tww_viewer;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_sys TO tww_viewer;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_vl  TO tww_viewer;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tww_cfg  TO tww_viewer;

ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_cfg  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO tww_viewer;


/* User */
GRANT ALL ON SCHEMA tww_od TO tww_user;
GRANT ALL ON ALL TABLES IN SCHEMA tww_od TO tww_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_od TO tww_user;
GRANT ALL ON ALL TABLES IN SCHEMA tww_cfg TO tww_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od GRANT ALL ON TABLES TO tww_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od GRANT ALL ON SEQUENCES TO tww_user;

DO $$ BEGIN EXECUTE 'GRANT CREATE ON DATABASE ' || (SELECT current_database()) || ' TO "tww_user"'; END $$;  -- required for ili2pg imports/exports

/* Manager */
GRANT ALL ON SCHEMA tww_vl TO tww_manager;
GRANT ALL ON ALL TABLES IN SCHEMA tww_vl TO tww_manager;
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_vl TO tww_manager;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl GRANT ALL ON TABLES TO tww_manager;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl GRANT ALL ON SEQUENCES TO tww_manager;

/* SysAdmin */
GRANT ALL ON SCHEMA tww_sys TO tww_sysadmin;
GRANT ALL ON ALL TABLES IN SCHEMA tww_sys TO tww_sysadmin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA tww_sys TO tww_sysadmin;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys GRANT ALL ON TABLES TO tww_sysadmin;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys GRANT ALL ON SEQUENCES TO tww_sysadmin;

/*
-- Revoke

REVOKE ALL ON SCHEMA tww_od  FROM tww_viewer;
REVOKE ALL ON SCHEMA tww_sys FROM tww_viewer;
REVOKE ALL ON SCHEMA tww_vl  FROM tww_viewer;

REVOKE ALL ON ALL TABLES IN SCHEMA tww_od  FROM tww_viewer;
REVOKE ALL ON ALL TABLES IN SCHEMA tww_sys FROM tww_viewer;
REVOKE ALL ON ALL TABLES IN SCHEMA tww_vl  FROM tww_viewer;

ALTER DEFAULT PRIVILEGES IN SCHEMA tww_od  REVOKE ALL ON TABLES  FROM tww_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_sys REVOKE ALL ON TABLES  FROM tww_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA tww_vl  REVOKE ALL ON TABLES  FROM tww_viewer;

*/
