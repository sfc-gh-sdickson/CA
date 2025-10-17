-- ============================================================================
-- Consolidated Analytics Intelligence Agent - Database and Schema Setup
-- ============================================================================
-- Purpose: Initialize the database, schema, and warehouse for the 
--          Consolidated Analytics Intelligence Agent solution
-- Business: Mortgage and Real Estate Finance
-- ============================================================================

-- Create the database
CREATE DATABASE IF NOT EXISTS CONSOLIDATED_ANALYTICS_DB;

-- Use the database
USE DATABASE CONSOLIDATED_ANALYTICS_DB;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS ANALYTICS;

-- Create a virtual warehouse for query processing
CREATE OR REPLACE WAREHOUSE CA_ANALYTICS_WH WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for Consolidated Analytics Intelligence Agent queries';

-- Set the warehouse as active
USE WAREHOUSE CA_ANALYTICS_WH;

-- Display confirmation
SELECT 'Database, schema, and warehouse setup completed successfully' AS STATUS;

