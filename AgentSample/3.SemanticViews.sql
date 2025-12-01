


-- Creates business unit-specific semantic views for natural language queries

-- Set role, database and schema
USE ROLE AGENTIC_ANALYTICS_ROLE;
USE WAREHOUSE AGENTIC_ANALYTICS_WH;
USE SCHEMA AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA;

-- FINANCE SEMANTIC VIEW
create or replace semantic view FINANCE_SEMANTIC_VIEW
    tables (
        TRANSACTIONS as FINANCE_TRANSACTIONS primary key (TRANSACTION_ID) with synonyms=('finance transactions','financial data') comment='All financial transactions across departments',
        ACCOUNTS as ACCOUNT_DIM primary key (ACCOUNT_KEY) with synonyms=('chart of accounts','account types') comment='Account dimension for financial categorization',
        DEPARTMENTS as DEPARTMENT_DIM primary key (DEPARTMENT_KEY) with synonyms=('business units','departments') comment='Department dimension for cost center analysis',
        VENDORS as VENDOR_DIM primary key (VENDOR_KEY) with synonyms=('suppliers','vendors') comment='Vendor information for spend analysis',
        PRODUCTS as PRODUCT_DIM primary key (PRODUCT_KEY) with synonyms=('products','items') comment='Product dimension for transaction analysis',
        CUSTOMERS as CUSTOMER_DIM primary key (CUSTOMER_KEY) with synonyms=('clients','customers') comment='Customer dimension for revenue analysis'
    )
    relationships (
        TRANSACTIONS_TO_ACCOUNTS as TRANSACTIONS(ACCOUNT_KEY) references ACCOUNTS(ACCOUNT_KEY),
        TRANSACTIONS_TO_DEPARTMENTS as TRANSACTIONS(DEPARTMENT_KEY) references DEPARTMENTS(DEPARTMENT_KEY),
        TRANSACTIONS_TO_VENDORS as TRANSACTIONS(VENDOR_KEY) references VENDORS(VENDOR_KEY),
        TRANSACTIONS_TO_PRODUCTS as TRANSACTIONS(PRODUCT_KEY) references PRODUCTS(PRODUCT_KEY),
        TRANSACTIONS_TO_CUSTOMERS as TRANSACTIONS(CUSTOMER_KEY) references CUSTOMERS(CUSTOMER_KEY)
    )
    facts (
        TRANSACTIONS.TRANSACTION_AMOUNT as amount comment='Transaction amount in dollars',
        TRANSACTIONS.TRANSACTION_RECORD as 1 comment='Count of transactions'
    )
    dimensions (
        TRANSACTIONS.TRANSACTION_DATE as date with synonyms=('date','transaction date') comment='Date of the financial transaction',
        TRANSACTIONS.TRANSACTION_MONTH as MONTH(date) comment='Month of the transaction',
        TRANSACTIONS.TRANSACTION_YEAR as YEAR(date) comment='Year of the transaction',
        ACCOUNTS.ACCOUNT_NAME as account_name with synonyms=('account','account type') comment='Name of the account',
        ACCOUNTS.ACCOUNT_TYPE as account_type with synonyms=('type','category') comment='Type of account (Income/Expense)',
        DEPARTMENTS.DEPARTMENT_NAME as department_name with synonyms=('department','business unit') comment='Name of the department',
        VENDORS.VENDOR_NAME as vendor_name with synonyms=('vendor','supplier') comment='Name of the vendor',
        PRODUCTS.PRODUCT_NAME as product_name with synonyms=('product','item') comment='Name of the product',
        CUSTOMERS.CUSTOMER_NAME as customer_name with synonyms=('customer','client') comment='Name of the customer',
        TRANSACTIONS.APPROVAL_STATUS as approval_status with synonyms=('approval','status','approval state') comment='Transaction approval status (Approved/Pending/Rejected)',
        TRANSACTIONS.PROCUREMENT_METHOD as procurement_method with synonyms=('procurement','method','purchase method') comment='Method of procurement (RFP/Quotes/Emergency/Contract)',
        TRANSACTIONS.APPROVER_ID as approver_id with synonyms=('approver','approver employee id') comment='Employee ID of the approver from HR',
        TRANSACTIONS.APPROVAL_DATE as approval_date with synonyms=('approved date','date approved') comment='Date when transaction was approved',
        TRANSACTIONS.PURCHASE_ORDER_NUMBER as purchase_order_number with synonyms=('PO number','PO','purchase order') comment='Purchase order number for tracking',
        TRANSACTIONS.CONTRACT_REFERENCE as contract_reference with synonyms=('contract','contract number','contract ref') comment='Reference to related contract'
    )
    metrics (
        TRANSACTIONS.AVERAGE_AMOUNT as AVG(transactions.amount) comment='Average transaction amount',
        TRANSACTIONS.TOTAL_AMOUNT as SUM(transactions.amount) comment='Total transaction amount',
        TRANSACTIONS.TOTAL_TRANSACTIONS as COUNT(transactions.transaction_record) comment='Total number of transactions'
    )
    comment='Semantic view for financial analysis and reporting';


-- SALES SEMANTIC VIEW
create or replace semantic view SALES_SEMANTIC_VIEW
  tables (
    CUSTOMERS as CUSTOMER_DIM primary key (CUSTOMER_KEY) with synonyms=('clients','customers','accounts') comment='Customer information for sales analysis',
    PRODUCTS as PRODUCT_DIM primary key (PRODUCT_KEY) with synonyms=('products','items','SKUs') comment='Product catalog for sales analysis',
    PRODUCT_CATEGORY_DIM primary key (CATEGORY_KEY),
    REGIONS as REGION_DIM primary key (REGION_KEY) with synonyms=('territories','regions','areas') comment='Regional information for territory analysis',
    SALES as SALES_FACT primary key (SALE_ID) with synonyms=('sales transactions','sales data') comment='All sales transactions and deals',
    SALES_REPS as SALES_REP_DIM primary key (SALES_REP_KEY) with synonyms=('sales representatives','reps','salespeople') comment='Sales representative information',
    VENDORS as VENDOR_DIM primary key (VENDOR_KEY) with synonyms=('suppliers','vendors') comment='Vendor information for supply chain analysis'
  )
  relationships (
    PRODUCT_TO_CATEGORY as PRODUCTS(CATEGORY_KEY) references PRODUCT_CATEGORY_DIM(CATEGORY_KEY),
    SALES_TO_CUSTOMERS as SALES(CUSTOMER_KEY) references CUSTOMERS(CUSTOMER_KEY),
    SALES_TO_PRODUCTS as SALES(PRODUCT_KEY) references PRODUCTS(PRODUCT_KEY),
    SALES_TO_REGIONS as SALES(REGION_KEY) references REGIONS(REGION_KEY),
    SALES_TO_REPS as SALES(SALES_REP_KEY) references SALES_REPS(SALES_REP_KEY),
    SALES_TO_VENDORS as SALES(VENDOR_KEY) references VENDORS(VENDOR_KEY)
  )
  facts (
    SALES.SALE_AMOUNT as amount comment='Sale amount in dollars',
    SALES.SALE_RECORD as 1 comment='Count of sales transactions',
    SALES.UNITS_SOLD as units comment='Number of units sold'
  )
  dimensions (
    CUSTOMERS.CUSTOMER_INDUSTRY as INDUSTRY with synonyms=('industry','customer type') comment='Customer industry',
    CUSTOMERS.CUSTOMER_KEY as CUSTOMER_KEY,
    CUSTOMERS.CUSTOMER_NAME as customer_name with synonyms=('customer','client','account') comment='Name of the customer',
    PRODUCTS.CATEGORY_KEY as CATEGORY_KEY with synonyms=('category_id','product_category','category_code','classification_key','group_key','product_group_id') comment='Unique identifier for the product category.',
    PRODUCTS.PRODUCT_KEY as PRODUCT_KEY,
    PRODUCTS.PRODUCT_NAME as product_name with synonyms=('product','item') comment='Name of the product',
    PRODUCT_CATEGORY_DIM.CATEGORY_KEY as CATEGORY_KEY with synonyms=('category_id','category_code','product_category_number','category_identifier','classification_key') comment='Unique identifier for a product category.',
    PRODUCT_CATEGORY_DIM.CATEGORY_NAME as CATEGORY_NAME with synonyms=('category_title','product_group','classification_name','category_label','product_category_description') comment='The category to which a product belongs, such as electronics, clothing, or software as a service.',
    PRODUCT_CATEGORY_DIM.VERTICAL as VERTICAL with synonyms=('industry','sector','market','category_group','business_area','domain') comment='The industry or sector in which a product is categorized, such as retail, technology, or manufacturing.',
    REGIONS.REGION_KEY as REGION_KEY,
    REGIONS.REGION_NAME as region_name with synonyms=('region','territory','area') comment='Name of the region',
    SALES.CUSTOMER_KEY as CUSTOMER_KEY,
    SALES.PRODUCT_KEY as PRODUCT_KEY,
    SALES.REGION_KEY as REGION_KEY,
    SALES.SALES_REP_KEY as SALES_REP_KEY,
    SALES.SALE_DATE as date with synonyms=('date','sale date','transaction date') comment='Date of the sale',
    SALES.SALE_ID as SALE_ID,
    SALES.SALE_MONTH as MONTH(date) comment='Month of the sale',
    SALES.SALE_YEAR as YEAR(date) comment='Year of the sale',
    SALES.VENDOR_KEY as VENDOR_KEY,
    SALES_REPS.SALES_REP_KEY as SALES_REP_KEY,
    SALES_REPS.SALES_REP_NAME as REP_NAME with synonyms=('sales rep','representative','salesperson') comment='Name of the sales representative',
    VENDORS.VENDOR_KEY as VENDOR_KEY,
    VENDORS.VENDOR_NAME as vendor_name with synonyms=('vendor','supplier','provider') comment='Name of the vendor'
  )
  metrics (
    SALES.AVERAGE_DEAL_SIZE as AVG(sales.amount) comment='Average deal size',
    SALES.AVERAGE_UNITS_PER_SALE as AVG(sales.units) comment='Average units per sale',
    SALES.TOTAL_DEALS as COUNT(sales.sale_record) comment='Total number of deals',
    SALES.TOTAL_REVENUE as SUM(sales.amount) comment='Total sales revenue',
    SALES.TOTAL_UNITS as SUM(sales.units) comment='Total units sold'
  )
  comment='Semantic view for sales analysis and performance tracking'
;


-- MARKETING SEMANTIC VIEW
create or replace semantic view MARKETING_SEMANTIC_VIEW
  tables (
    ACCOUNTS as SF_ACCOUNTS primary key (ACCOUNT_ID) with synonyms=('customers','accounts','clients') comment='Customer account information for revenue analysis',
    CAMPAIGNS as MARKETING_CAMPAIGN_FACT primary key (CAMPAIGN_FACT_ID) with synonyms=('marketing campaigns','campaign data') comment='Marketing campaign performance data',
    CAMPAIGN_DETAILS as CAMPAIGN_DIM primary key (CAMPAIGN_KEY) with synonyms=('campaign info','campaign details') comment='Campaign dimension with objectives and names',
    CHANNELS as CHANNEL_DIM primary key (CHANNEL_KEY) with synonyms=('marketing channels','channels') comment='Marketing channel information',
    CONTACTS as SF_CONTACTS primary key (CONTACT_ID) with synonyms=('leads','contacts','prospects') comment='Contact records generated from marketing campaigns',
    CONTACTS_FOR_OPPORTUNITIES as SF_CONTACTS primary key (CONTACT_ID) with synonyms=('opportunity contacts') comment='Contact records generated from marketing campaigns, specifically for opportunities, not leads',
    OPPORTUNITIES as SF_OPPORTUNITIES primary key (OPPORTUNITY_ID) with synonyms=('deals','opportunities','sales pipeline') comment='Sales opportunities and revenue data',
    PRODUCTS as PRODUCT_DIM primary key (PRODUCT_KEY) with synonyms=('products','items') comment='Product dimension for campaign-specific analysis',
    REGIONS as REGION_DIM primary key (REGION_KEY) with synonyms=('territories','regions','markets') comment='Regional information for campaign analysis'
  )
  relationships (
    CAMPAIGNS_TO_CHANNELS as CAMPAIGNS(CHANNEL_KEY) references CHANNELS(CHANNEL_KEY),
    CAMPAIGNS_TO_DETAILS as CAMPAIGNS(CAMPAIGN_KEY) references CAMPAIGN_DETAILS(CAMPAIGN_KEY),
    CAMPAIGNS_TO_PRODUCTS as CAMPAIGNS(PRODUCT_KEY) references PRODUCTS(PRODUCT_KEY),
    CAMPAIGNS_TO_REGIONS as CAMPAIGNS(REGION_KEY) references REGIONS(REGION_KEY),
    CONTACTS_TO_ACCOUNTS as CONTACTS(ACCOUNT_ID) references ACCOUNTS(ACCOUNT_ID),
    CONTACTS_TO_CAMPAIGNS as CONTACTS(CAMPAIGN_NO) references CAMPAIGNS(CAMPAIGN_FACT_ID),
    CONTACTS_TO_OPPORTUNITIES as CONTACTS_FOR_OPPORTUNITIES(OPPORTUNITY_ID) references OPPORTUNITIES(OPPORTUNITY_ID),
    OPPORTUNITIES_TO_ACCOUNTS as OPPORTUNITIES(ACCOUNT_ID) references ACCOUNTS(ACCOUNT_ID),
    OPPORTUNITIES_TO_CAMPAIGNS as OPPORTUNITIES(CAMPAIGN_ID) references CAMPAIGNS(CAMPAIGN_FACT_ID)
  )
  facts (
    PUBLIC CAMPAIGNS.CAMPAIGN_RECORD as 1 comment='Count of campaign activities',
    PUBLIC CAMPAIGNS.CAMPAIGN_SPEND as spend comment='Marketing spend in dollars',
    PUBLIC CAMPAIGNS.IMPRESSIONS as IMPRESSIONS comment='Number of impressions',
    PUBLIC CAMPAIGNS.LEADS_GENERATED as LEADS_GENERATED comment='Number of leads generated',
    PUBLIC CONTACTS.CONTACT_RECORD as 1 comment='Count of contacts generated',
    PUBLIC OPPORTUNITIES.OPPORTUNITY_RECORD as 1 comment='Count of opportunities created',
    PUBLIC OPPORTUNITIES.REVENUE as AMOUNT comment='Opportunity revenue in dollars'
  )
  dimensions (
    PUBLIC ACCOUNTS.ACCOUNT_ID as ACCOUNT_ID,
    PUBLIC ACCOUNTS.ACCOUNT_NAME as ACCOUNT_NAME with synonyms=('customer name','client name','company') comment='Name of the customer account',
    PUBLIC ACCOUNTS.ACCOUNT_TYPE as ACCOUNT_TYPE with synonyms=('customer type','account category') comment='Type of customer account',
    PUBLIC ACCOUNTS.ANNUAL_REVENUE as ANNUAL_REVENUE with synonyms=('customer revenue','company revenue') comment='Customer annual revenue',
    PUBLIC ACCOUNTS.EMPLOYEES as EMPLOYEES with synonyms=('company size','employee count') comment='Number of employees at customer',
    PUBLIC ACCOUNTS.INDUSTRY as INDUSTRY with synonyms=('industry','sector') comment='Customer industry',
    PUBLIC ACCOUNTS.SALES_CUSTOMER_KEY as CUSTOMER_KEY with synonyms=('Customer No','Customer ID') comment='This is the customer key thank links the Salesforce account to customers table.',
    PUBLIC CAMPAIGNS.CAMPAIGN_DATE as date with synonyms=('date','campaign date') comment='Date of the campaign activity',
    PUBLIC CAMPAIGNS.CAMPAIGN_FACT_ID as CAMPAIGN_FACT_ID,
    PUBLIC CAMPAIGNS.CAMPAIGN_KEY as CAMPAIGN_KEY,
    PUBLIC CAMPAIGNS.CAMPAIGN_MONTH as MONTH(date) comment='Month of the campaign',
    PUBLIC CAMPAIGNS.CAMPAIGN_YEAR as YEAR(date) comment='Year of the campaign',
    PUBLIC CAMPAIGNS.CHANNEL_KEY as CHANNEL_KEY,
    PUBLIC CAMPAIGNS.PRODUCT_KEY as PRODUCT_KEY with synonyms=('product_id','product identifier') comment='Product identifier for campaign targeting',
    PUBLIC CAMPAIGNS.REGION_KEY as REGION_KEY,
    PUBLIC CAMPAIGN_DETAILS.CAMPAIGN_KEY as CAMPAIGN_KEY,
    PUBLIC CAMPAIGN_DETAILS.CAMPAIGN_NAME as CAMPAIGN_NAME with synonyms=('campaign','campaign title') comment='Name of the marketing campaign',
    PUBLIC CAMPAIGN_DETAILS.CAMPAIGN_OBJECTIVE as OBJECTIVE with synonyms=('objective','goal','purpose') comment='Campaign objective',
    PUBLIC CHANNELS.CHANNEL_KEY as CHANNEL_KEY,
    PUBLIC CHANNELS.CHANNEL_NAME as CHANNEL_NAME with synonyms=('channel','marketing channel') comment='Name of the marketing channel',
    PUBLIC CONTACTS.ACCOUNT_ID as ACCOUNT_ID,
    PUBLIC CONTACTS.CAMPAIGN_NO as CAMPAIGN_NO,
    PUBLIC CONTACTS.CONTACT_ID as CONTACT_ID,
    PUBLIC CONTACTS.DEPARTMENT as DEPARTMENT with synonyms=('department','business unit') comment='Contact department',
    PUBLIC CONTACTS.EMAIL as EMAIL with synonyms=('email','email address') comment='Contact email address',
    PUBLIC CONTACTS.FIRST_NAME as FIRST_NAME with synonyms=('first name','contact name') comment='Contact first name',
    PUBLIC CONTACTS.LAST_NAME as LAST_NAME with synonyms=('last name','surname') comment='Contact last name',
    PUBLIC CONTACTS.LEAD_SOURCE as LEAD_SOURCE with synonyms=('lead source','source') comment='How the contact was generated',
    PUBLIC CONTACTS.OPPORTUNITY_ID as OPPORTUNITY_ID,
    PUBLIC CONTACTS.TITLE as TITLE with synonyms=('job title','position') comment='Contact job title',
    PUBLIC OPPORTUNITIES.ACCOUNT_ID as ACCOUNT_ID,
    PUBLIC OPPORTUNITIES.CAMPAIGN_ID as CAMPAIGN_ID with synonyms=('campaign fact id','marketing campaign id') comment='Campaign fact ID that links opportunity to marketing campaign',
    PUBLIC OPPORTUNITIES.CLOSE_DATE as CLOSE_DATE with synonyms=('close date','expected close') comment='Expected or actual close date',
    PUBLIC OPPORTUNITIES.OPPORTUNITY_ID as OPPORTUNITY_ID,
    PUBLIC OPPORTUNITIES.OPPORTUNITY_LEAD_SOURCE as lead_source with synonyms=('opportunity source','deal source') comment='Source of the opportunity',
    PUBLIC OPPORTUNITIES.OPPORTUNITY_NAME as OPPORTUNITY_NAME with synonyms=('deal name','opportunity title') comment='Name of the sales opportunity',
    PUBLIC OPPORTUNITIES.OPPORTUNITY_STAGE as STAGE_NAME comment='Stage name of the opportinity. Closed Won indicates an actual sale with revenue',
    PUBLIC OPPORTUNITIES.OPPORTUNITY_TYPE as TYPE with synonyms=('deal type','opportunity type') comment='Type of opportunity',
    PUBLIC OPPORTUNITIES.SALES_SALE_ID as SALE_ID with synonyms=('sales id','invoice no') comment='Sales_ID for sales_fact table that links this opp to a sales record.',
    PUBLIC PRODUCTS.PRODUCT_CATEGORY as CATEGORY_NAME with synonyms=('category','product category') comment='Category of the product',
    PUBLIC PRODUCTS.PRODUCT_KEY as PRODUCT_KEY,
    PUBLIC PRODUCTS.PRODUCT_NAME as PRODUCT_NAME with synonyms=('product','item','product title') comment='Name of the product being promoted',
    PUBLIC PRODUCTS.PRODUCT_VERTICAL as VERTICAL with synonyms=('vertical','industry') comment='Business vertical of the product',
    PUBLIC REGIONS.REGION_KEY as REGION_KEY,
    PUBLIC REGIONS.REGION_NAME as REGION_NAME with synonyms=('region','market','territory') comment='Name of the region'
  )
  metrics (
    PUBLIC CAMPAIGNS.AVERAGE_SPEND as AVG(CAMPAIGNS.spend) comment='Average campaign spend',
    PUBLIC CAMPAIGNS.TOTAL_CAMPAIGNS as COUNT(CAMPAIGNS.campaign_record) comment='Total number of campaign activities',
    PUBLIC CAMPAIGNS.TOTAL_IMPRESSIONS as SUM(CAMPAIGNS.impressions) comment='Total impressions across campaigns',
    PUBLIC CAMPAIGNS.TOTAL_LEADS as SUM(CAMPAIGNS.leads_generated) comment='Total leads generated from campaigns',
    PUBLIC CAMPAIGNS.TOTAL_SPEND as SUM(CAMPAIGNS.spend) comment='Total marketing spend',
    PUBLIC CONTACTS.TOTAL_CONTACTS as COUNT(CONTACTS.contact_record) comment='Total contacts generated from campaigns',
    PUBLIC OPPORTUNITIES.AVERAGE_DEAL_SIZE as AVG(OPPORTUNITIES.revenue) comment='Average opportunity size from marketing',
    PUBLIC OPPORTUNITIES.CLOSED_WON_REVENUE as SUM(CASE WHEN OPPORTUNITIES.opportunity_stage = 'Closed Won' THEN OPPORTUNITIES.revenue ELSE 0 END) comment='Revenue from closed won opportunities',
    PUBLIC OPPORTUNITIES.TOTAL_OPPORTUNITIES as COUNT(OPPORTUNITIES.opportunity_record) comment='Total opportunities from marketing',
    PUBLIC OPPORTUNITIES.TOTAL_REVENUE as SUM(OPPORTUNITIES.revenue) comment='Total revenue from marketing-driven opportunities'
  )
  comment='Enhanced semantic view for marketing campaign analysis with complete revenue attribution and ROI tracking'
;

-- Display the semantic views
SHOW SEMANTIC VIEWS;



-- SELECT * FROM SEMANTIC_VIEW(
--   MARKETING_SEMANTIC_VIEW 
--   DIMENSIONS 
--     campaign_details.campaign_name,
--     channels.channel_name 
--   METRICS 
--     opportunities.total_revenue, 
--     campaigns.total_spend,
--     campaigns.total_leads
--   WHERE
--     campaigns.campaign_year = 2025
--                         )
-- WHERE total_revenue > 0
-- ORDER BY total_revenue DESC
-- ;


create or replace semantic view HR_SEMANTIC_VIEW  
    tables (  
        EMPLOYEE_DIM AS AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA.EMPLOYEE_DIM primary key (EMPLOYEE_KEY) with synonyms=('employee','employees') comment='This table stores dimensional data about employees, including a unique identifier, name, gender, and hire date, providing a single source of truth for employee information.',  
        DEPARTMENT_DIM AS AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA.DEPARTMENT_DIM primary key (DEPARTMENT_KEY) with synonyms=('department','departments') comment='This table stores information about the various departments within an organization, with each department uniquely identified by a department key and described by a department name.',  
        JOB_DIM AS AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA.JOB_DIM primary key (JOB_KEY) with synonyms=('job','jobs') comment='This table stores information about different job roles within an organization, with a unique identifier (JOB_KEY) for each job, a descriptive title (JOB_TITLE), and a hierarchical level (JOB_LEVEL) indicating the job''s position within the organizational structure.',  
        LOCATION_DIM AS AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA.LOCATION_DIM primary key (LOCATION_KEY) with synonyms=('location','locations') comment='This table stores unique locations with a corresponding unique identifier, allowing for efficient referencing and analysis of location-based data across the organization.',  
        WORKFORCE_METRICS AS AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA.HR_EMPLOYEE_FACT comment='This table contains employee-related facts and metrics.'
    )  
	relationships (
		WORKFORCE_METRICS_TO_EMPLOYEE as WORKFORCE_METRICS(EMPLOYEE_KEY) references EMPLOYEE_DIM(EMPLOYEE_KEY),
		WORKFORCE_METRICS_TO_DEPARTMENT as WORKFORCE_METRICS(DEPARTMENT_KEY) references DEPARTMENT_DIM(DEPARTMENT_KEY),
        WORKFORCE_METRICS_TO_JOB as WORKFORCE_METRICS(JOB_KEY) references JOB_DIM(JOB_KEY),
		WORKFORCE_METRICS_TO_LOCATION as WORKFORCE_METRICS(LOCATION_KEY) references LOCATION_DIM(LOCATION_KEY)
	)
	facts (
		WORKFORCE_METRICS.SALARY as SALARY
	)
    dimensions (  
        EMPLOYEE_DIM.EMPLOYEE_KEY as EMPLOYEE_KEY comment='Unique identifier for each employee in the organization.',  
        EMPLOYEE_DIM.EMPLOYEE_NAME as EMPLOYEE_NAME comment='The full name of the employee.',  
        EMPLOYEE_DIM.GENDER as GENDER comment='The gender of the employee, either Female (F) or Male (M).',  
        EMPLOYEE_DIM.HIRE_DATE as HIRE_DATE comment='Date on which the employee was hired by the company.',  
        DEPARTMENT_DIM.DEPARTMENT_KEY as DEPARTMENT_KEY comment='Unique identifier for a department within the organization.',  
        DEPARTMENT_DIM.DEPARTMENT_NAME as DEPARTMENT_NAME comment='The name of the department within the organization.',  
        JOB_DIM.JOB_KEY as JOB_KEY comment='Unique identifier for a job or role within the organization.',  
        JOB_DIM.JOB_LEVEL as JOB_LEVEL comment='The level or rank of an employee''s job within the organization.',  
        JOB_DIM.JOB_TITLE as JOB_TITLE comment='The specific job or role held by an individual.',  
        LOCATION_DIM.LOCATION_KEY as LOCATION_KEY comment='Unique identifier for a specific geographic location.',  
        LOCATION_DIM.LOCATION_NAME as LOCATION_NAME comment='The name of the location.',
        WORKFORCE_METRICS.DATE AS DATE comment='Record Date for HR Fact or employee detail change',
        WORKFORCE_METRICS.EMPLOYEE_KEY as EMPLOYEE_KEY comment='Employee Key in HR Fact or Employee Detail Change',
        WORKFORCE_METRICS.DEPARTMENT_KEY as DEPARTMENT_KEY comment='Department Key in HR Fact or Employee Detail Change',
        WORKFORCE_METRICS.JOB_KEY as JOB_KEY comment='Job Key in HR Fact or Employee Detail Change',
        WORKFORCE_METRICS.LOCATION_KEY as LOCATION_KEY comment='Location Key in HR Fact or Employee Detail Change'
    )

    metrics (  
        WORKFORCE_METRICS.avg_tenure_months AS AVG(DATEDIFF('MONTH', EMPLOYEE_DIM.HIRE_DATE, WORKFORCE_METRICS.DATE)) comment='Average employee tenure in months' ,
        WORKFORCE_METRICS.distinct_employees AS COUNT(DISTINCT WORKFORCE_METRICS.EMPLOYEE_KEY) comment='Count of unique employees' ,
        WORKFORCE_METRICS.male_employees AS COUNT(DISTINCT CASE WHEN EMPLOYEE_DIM.GENDER = 'M' THEN WORKFORCE_METRICS.EMPLOYEE_KEY END) comment='Count of male employees' ,
        WORKFORCE_METRICS.female_employees AS COUNT(DISTINCT CASE WHEN EMPLOYEE_DIM.GENDER = 'F' THEN WORKFORCE_METRICS.EMPLOYEE_KEY END) comment='Count of female employees' ,
        WORKFORCE_METRICS.total_attrition AS ROUND(SUM(WORKFORCE_METRICS.ATTRITION_FLAG)) comment='Total employee attrition'  ,
        WORKFORCE_METRICS.salary_75th_percentile AS PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY WORKFORCE_METRICS.SALARY) comment='75th percentile of salary' ,
        WORKFORCE_METRICS.min_salary AS MIN(WORKFORCE_METRICS.SALARY) comment='Minimum salary' , 
        WORKFORCE_METRICS.max_salary AS MAX(WORKFORCE_METRICS.SALARY) comment='Maximum salary' , 
        WORKFORCE_METRICS.distinct_locations AS COUNT(DISTINCT WORKFORCE_METRICS.LOCATION_KEY) comment='Count of unique locations' ,
        WORKFORCE_METRICS.salary_90th_percentile AS PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY WORKFORCE_METRICS.SALARY) comment='90th percentile of salary' ,
        WORKFORCE_METRICS.avg_tenure_days AS AVG(DATEDIFF('DAY', EMPLOYEE_DIM.HIRE_DATE, WORKFORCE_METRICS.DATE)) comment='Average employee tenure in days'   
    )  
    comment='This semantic view uses HR Data';  