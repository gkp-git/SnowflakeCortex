    USE ROLE accountadmin;


   -- Step 1: Create Role to be used for creating the objects
   CREATE OR REPLACE ROLE agentic_analytics_role;
   
   -- Step 2: Use the variable to grant the role
   SET current_user_name = CURRENT_USER();
   GRANT ROLE agentic_analytics_role TO USER IDENTIFIER($current_user_name);

   GRANT ROLE agentic_analytics_role TO ROLE ACCOUNTADMIN;
   GRANT CREATE DATABASE ON ACCOUNT TO ROLE agentic_analytics_role;
  
   -- Create a dedicated warehouse with auto-suspend/resume
   CREATE OR REPLACE WAREHOUSE agentic_analytics_wh 
       WITH WAREHOUSE_SIZE = 'XSMALL'
       AUTO_SUSPEND = 300
       AUTO_RESUME = TRUE;
   -- Grant usage on warehouse to admin role
   GRANT USAGE ON WAREHOUSE agentic_analytics_wh TO ROLE agentic_analytics_role;

 -- Alter current user's default role and warehouse to the ones used here
    ALTER USER IDENTIFIER($current_user_name) SET DEFAULT_ROLE = agentic_analytics_role;
    ALTER USER IDENTIFIER($current_user_name) SET DEFAULT_WAREHOUSE = agentic_analytics_wh;