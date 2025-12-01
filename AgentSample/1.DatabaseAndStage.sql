USE ROLE agentic_analytics_role;
--USE WAREHOUSE agentic_analytics_wh;

    -- Create database and schemas
    CREATE OR REPLACE DATABASE AGENTIC_ANALYTICS_DB;
    USE DATABASE AGENTIC_ANALYTICS_DB;

    CREATE SCHEMA IF NOT EXISTS AGENTIC_ANALYTICS_SCHEMA;
    USE SCHEMA AGENTIC_ANALYTICS_SCHEMA;

-- Data Files Staging Objects

    CREATE OR REPLACE FILE FORMAT CSV_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    RECORD_DELIMITER = '\n'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    TRIM_SPACE = TRUE
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
    ESCAPE = 'NONE'
    ESCAPE_UNENCLOSED_FIELD = '\134'
    DATE_FORMAT = 'YYYY-MM-DD'
    TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS'
    NULL_IF = ('NULL', 'null', '', 'N/A', 'n/a');

    -- Create internal stage for copied data files
    CREATE OR REPLACE STAGE INTERNAL_DATA_STAGE
        FILE_FORMAT = CSV_FORMAT
        COMMENT = 'Internal stage for copied demo data files'
        DIRECTORY = ( ENABLE = TRUE)
        ENCRYPTION = (   TYPE = 'SNOWFLAKE_SSE');

--- File Source for Demo
    CREATE OR REPLACE GIT REPOSITORY SNOWFLAKECORTEX_REPO
        API_INTEGRATION = GIT_SNOWFLAKECORTEX_INTEGRATION
        ORIGIN = 'https://github.com/gkp-git/SnowflakeCortex';

    ALTER GIT REPOSITORY SNOWFLAKECORTEX_REPO FETCH;
    
    LS @SNOWFLAKECORTEX_REPO/branches/main/AgentSample/data/dimensions;
    LS @SNOWFLAKECORTEX_REPO/branches/main/AgentSample/data/facts;
    LS @SNOWFLAKECORTEX_REPO/branches/main/AgentSample/data/salesforce;
    

--- Copy Files from Git Repo to Internal stage
    COPY FILES
    INTO @INTERNAL_DATA_STAGE/data/
    FROM @SNOWFLAKECORTEX_REPO/branches/main/AgentSample/data/dimensions;

    COPY FILES
    INTO @INTERNAL_DATA_STAGE/data/
    FROM @SNOWFLAKECORTEX_REPO/branches/main/AgentSample/data/facts;

    COPY FILES
    INTO @INTERNAL_DATA_STAGE/data/
    FROM @SNOWFLAKECORTEX_REPO/branches/main/AgentSample/data/salesforce;

-- Verify files were copied
    LS @INTERNAL_DATA_STAGE;
    ALTER STAGE INTERNAL_DATA_STAGE refresh;


    