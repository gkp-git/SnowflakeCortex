USE ROLE AGENTIC_ANALYTICS_ROLE;
USE WAREHOUSE AGENTIC_ANALYTICS_WH;
USE SCHEMA AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA;


select count(*) from EMPLOYEE_DIM limit 10;

select distinct f.EMPLOYEE_KEY 
from HR_EMPLOYEE_FACT f
left join EMPLOYEE_DIM d
 on d.employee_key = f.employee_key
 where d.employee_key is null;

select distinct d.EMPLOYEE_KEY 
from EMPLOYEE_DIM d
left join HR_EMPLOYEE_FACT f
 on d.employee_key = f.employee_key
 where f.employee_key is null;


 select count(distinct f.EMPLOYEE_KEY) from HR_EMPLOYEE_FACT f;
