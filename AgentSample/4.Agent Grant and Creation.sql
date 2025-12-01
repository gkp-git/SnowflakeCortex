USE ROLE AGENTIC_ANALYTICS_ROLE;
USE SCHEMA AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA;
CREATE OR REPLACE SCHEMA AGENTIC_ANALYTICS_DB.AGENTS;

GRANT CREATE AGENT ON SCHEMA AGENTIC_ANALYTICS_DB.AGENTS TO ROLE AGENTIC_ANALYTICS_ROLE;

USE ROLE AGENTIC_ANALYTICS_ROLE;

CREATE OR REPLACE AGENT AGENTIC_ANALYTICS_DB.AGENTS.Agentic_Analytics_Chatbot
WITH PROFILE='{ "display_name": "1-Agentic Analytics Chatbot" }'
    COMMENT='This is an agent that can answer questions about company specific Sales, Marketing, HR & Finance questions.'
FROM SPECIFICATION $$
{
  "models": {
    "orchestration": ""
  },
  "instructions": {
    "response": "Answer user questions about Sales, Marketing, HR, and Finance using the provided semantic views. When appropriate, ask clarifying questions, generate safe SQL via the tools, and summarize results clearly."
  },
  "tools": [
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Finance Datamart",
        "description": "Allows users to query finance data for revenue & expenses."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Sales Datamart",
        "description": "Allows users to query sales data such as products and sales reps."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query HR Datamart",
        "description": "Allows users to query HR data; employee_name includes sales rep names."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Marketing Datamart",
        "description": "Allows users to query campaigns, channels, impressions, and spend."
      }
    }
  ],
  "tool_resources": {
    "Query Finance Datamart": {
      "semantic_view": "AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA.FINANCE_SEMANTIC_VIEW"
    },
    "Query HR Datamart": {
      "semantic_view": "AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA.HR_SEMANTIC_VIEW"
    },
    "Query Marketing Datamart": {
      "semantic_view": "AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA.MARKETING_SEMANTIC_VIEW"
    },
    "Query Sales Datamart": {
      "semantic_view": "AGENTIC_ANALYTICS_DB.AGENTIC_ANALYTICS_SCHEMA.SALES_SEMANTIC_VIEW"
    }
  }
}
$$;