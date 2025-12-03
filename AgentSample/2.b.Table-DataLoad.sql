USE ROLE agentic_analytics_role;
USE WAREHOUSE agentic_analytics_wh;
USE SCHEMA AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA;
-- ========================================================================
-- LOAD DIMENSION DATA FROM INTERNAL STAGE
-- ========================================================================
-- Load Product Category Dimension
TRUNCATE TABLE product_category_dim;
COPY INTO product_category_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/product_category_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Product Dimension
TRUNCATE TABLE product_dim;
COPY INTO product_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/product_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Vendor Dimension
TRUNCATE TABLE vendor_dim;
COPY INTO vendor_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/vendor_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Customer Dimension
TRUNCATE TABLE customer_dim;
COPY INTO customer_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/customer_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Account Dimension
TRUNCATE TABLE account_dim;
COPY INTO account_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/account_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Department Dimension
TRUNCATE TABLE department_dim;
COPY INTO department_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/department_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Region Dimension
TRUNCATE TABLE region_dim;
COPY INTO region_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/region_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Sales Rep Dimension
TRUNCATE TABLE sales_rep_dim;
COPY INTO sales_rep_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/sales_rep_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Campaign Dimension
TRUNCATE TABLE campaign_dim;
COPY INTO campaign_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/campaign_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Channel Dimension
TRUNCATE TABLE channel_dim;
COPY INTO channel_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/channel_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Employee Dimension
TRUNCATE TABLE employee_dim;
COPY INTO employee_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/employee_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Job Dimension
TRUNCATE TABLE job_dim;
COPY INTO job_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/job_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Location Dimension
TRUNCATE TABLE location_dim;
COPY INTO location_dim
FROM
    @INTERNAL_DATA_STAGE/data/dimensions/location_dim.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- ========================================================================
-- LOAD FACT DATA FROM INTERNAL STAGE
-- ========================================================================
-- Load Sales Fact
TRUNCATE TABLE sales_fact;
COPY INTO sales_fact
FROM
    @INTERNAL_DATA_STAGE/data/facts/sales_fact.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Finance Transactions
TRUNCATE TABLE finance_transactions;
COPY INTO finance_transactions
FROM
    @INTERNAL_DATA_STAGE/data/facts/finance_transactions.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Marketing Campaign Fact
TRUNCATE TABLE marketing_campaign_fact;
COPY INTO marketing_campaign_fact
FROM
    @INTERNAL_DATA_STAGE/data/facts/marketing_campaign_fact.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load HR Employee Fact
TRUNCATE TABLE hr_employee_fact;
COPY INTO hr_employee_fact
FROM
    @INTERNAL_DATA_STAGE/data/facts/hr_employee_fact.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- ========================================================================
-- LOAD SALESFORCE DATA FROM INTERNAL STAGE
-- ========================================================================
-- Load Salesforce Accounts
TRUNCATE TABLE sf_accounts;
COPY INTO sf_accounts
FROM
    @INTERNAL_DATA_STAGE/data/salesforce/sf_accounts.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Salesforce Opportunities
TRUNCATE TABLE sf_opportunities;
COPY INTO sf_opportunities
FROM
    @INTERNAL_DATA_STAGE/data/salesforce/sf_opportunities.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';
-- Load Salesforce Contacts
TRUNCATE TABLE sf_contacts;
COPY INTO sf_contacts
FROM
    @INTERNAL_DATA_STAGE/data/salesforce/sf_contacts.csv FILE_FORMAT = CSV_FORMAT ON_ERROR = 'CONTINUE';



-- Verify data loads
SELECT 'DIMENSION TABLES' as category, '' as table_name, NULL as row_count
UNION ALL
SELECT '', 'product_category_dim', COUNT(*) FROM product_category_dim
UNION ALL
SELECT '', 'product_dim', COUNT(*) FROM product_dim
UNION ALL
SELECT '', 'vendor_dim', COUNT(*) FROM vendor_dim
UNION ALL
SELECT '', 'customer_dim', COUNT(*) FROM customer_dim
UNION ALL
SELECT '', 'account_dim', COUNT(*) FROM account_dim
UNION ALL
SELECT '', 'department_dim', COUNT(*) FROM department_dim
UNION ALL
SELECT '', 'region_dim', COUNT(*) FROM region_dim
UNION ALL
SELECT '', 'sales_rep_dim', COUNT(*) FROM sales_rep_dim
UNION ALL
SELECT '', 'campaign_dim', COUNT(*) FROM campaign_dim
UNION ALL
SELECT '', 'channel_dim', COUNT(*) FROM channel_dim
UNION ALL
SELECT '', 'employee_dim', COUNT(*) FROM employee_dim
UNION ALL
SELECT '', 'job_dim', COUNT(*) FROM job_dim
UNION ALL
SELECT '', 'location_dim', COUNT(*) FROM location_dim
UNION ALL
SELECT '', '', NULL
UNION ALL
SELECT 'FACT TABLES', '', NULL
UNION ALL
SELECT '', 'sales_fact', COUNT(*) FROM sales_fact
UNION ALL
SELECT '', 'finance_transactions', COUNT(*) FROM finance_transactions
UNION ALL
SELECT '', 'marketing_campaign_fact', COUNT(*) FROM marketing_campaign_fact
UNION ALL
SELECT '', 'hr_employee_fact', COUNT(*) FROM hr_employee_fact
UNION ALL
SELECT '', '', NULL
UNION ALL
SELECT 'SALESFORCE TABLES', '', NULL
UNION ALL
SELECT '', 'sf_accounts', COUNT(*) FROM sf_accounts
UNION ALL
SELECT '', 'sf_opportunities', COUNT(*) FROM sf_opportunities
UNION ALL
SELECT '', 'sf_contacts', COUNT(*) FROM sf_contacts;

-- Show all tables
SHOW TABLES IN SCHEMA AGENTIC_ANALYTICS_SCHEMA; 