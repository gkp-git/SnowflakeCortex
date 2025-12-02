USE ROLE AGENTIC_ANALYTICS_ROLE;
USE WAREHOUSE AGENTIC_ANALYTICS_WH;
USE SCHEMA AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA;

-- ========================================================================
-- UNSTRUCTURED DATA
-- ========================================================================

LS @INTERNAL_DATA_STAGE/data/unstructured_docs/;


create or replace table parsed_content as 
select 
  
    relative_path, 
    BUILD_STAGE_FILE_URL('@INTERNAL_DATA_STAGE', relative_path) as file_url,
    TO_File(BUILD_STAGE_FILE_URL('@INTERNAL_DATA_STAGE', relative_path) ) file_object,
        SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
                                    @INTERNAL_DATA_STAGE,
                                    relative_path,
                                    {'mode':'LAYOUT'}
                                    ):content::string as Content
    from directory(@INTERNAL_DATA_STAGE) 
where relative_path ilike '%data/unstructured_docs/%.pdf' ;
--~34 second run time
select * from parsed_content;

-- Create search service for finance documents
-- This enables semantic search over finance-related content
CREATE OR REPLACE CORTEX SEARCH SERVICE Search_finance_docs
        ON content
        ATTRIBUTES relative_path, file_url, title
        WAREHOUSE = AGENTIC_ANALYTICS_WH
        TARGET_LAG = '30 day'
        EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
        AS (
            SELECT
                relative_path,
                file_url,
                REGEXP_SUBSTR(relative_path, '[^/]+$') as title, -- Extract filename as title
                content
            FROM parsed_content
            WHERE relative_path ilike '%/finance/%'
        );

-- Create search service for HR documents
-- This enables semantic search over HR-related content
CREATE OR REPLACE CORTEX SEARCH SERVICE Search_hr_docs
    ON content
    ATTRIBUTES relative_path, file_url, title
    WAREHOUSE = AGENTIC_ANALYTICS_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT
            relative_path,
            file_url,
            REGEXP_SUBSTR(relative_path, '[^/]+$') as title,
            content
        FROM parsed_content
        WHERE relative_path ilike '%/hr/%'
    );

-- Create search service for marketing documents
-- This enables semantic search over marketing-related content
CREATE OR REPLACE CORTEX SEARCH SERVICE Search_marketing_docs
    ON content
    ATTRIBUTES relative_path, file_url, title
    WAREHOUSE = AGENTIC_ANALYTICS_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT
            relative_path,
            file_url,
            REGEXP_SUBSTR(relative_path, '[^/]+$') as title,
            content
        FROM parsed_content
        WHERE relative_path ilike '%/marketing/%'
    );

-- Create search service for sales documents
-- This enables semantic search over sales-related content
CREATE OR REPLACE CORTEX SEARCH SERVICE Search_sales_docs
    ON content
    ATTRIBUTES relative_path, file_url, title
    WAREHOUSE = AGENTIC_ANALYTICS_WH
    TARGET_LAG = '30 day'
    EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
    AS (
        SELECT
            relative_path,
            file_url,
            REGEXP_SUBSTR(relative_path, '[^/]+$') as title,
            content
        FROM parsed_content
        WHERE relative_path ilike '%/sales/%'
    );