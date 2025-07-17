# klaus-qa-dbt

This repository contains the dbt data model for the Klaus QA exercise, designed for Snowflake.

## Structure

- `models/`: Contains all dbt models (one per entity/table).
- `models/schema.yml`: Descriptions and tests for each model.
- `analysis/solutions.sql`: SQL solutions for the technical tasks required.
- `etl_pipeline/`: ETL pipeline for subscription data processing.
- `dbt_project.yml`: dbt project configuration.

## How to use

### dbt Models
1. Clone this repository.
2. Configure your `profiles.yml` for Snowflake.
3. Run `dbt run` to build the models.

### ETL Pipeline
1. Go to to `etl_pipeline/` directory.
2. Install dependencies: `pip install -r requirements.txt`
3. Configure Google Cloud credentials.
4. Update project_id in `etl_pipeline.py`.
5. Run: `python etl_pipeline.py`

## Entities

- **conversation**: Customer support ticket or conversation.
- **autoqa_review**: Automated review for a conversation.
- **autoqa_rating**: Category-level score within an automated review.
- **autoqa_root_cause**: Root causes for an automated rating.
- **manual_review**: Manual review performed by a human reviewer.
- **manual_rating**: Category-level score within a manual review.

## ETL Pipeline Features

- **Incremental Loading**: Only processes new data without reprocessing existing records.
- **Data Separation**: Automatically separates subscription and customer data into different tables.
- **Audit Trail**: Adds timestamps and data source information to all records.
- **BigQuery Integration**: Loads data directly to BigQuery with automatic schema detection.

## Notes

- All models are materialized as views.
- Source tables (e.g., `raw_conversation`) should be replaced with your actual raw data sources.
- Tests for uniqueness and referential integrity are defined in `schema.yml`.
- SQL solutions are tested (in BQ) and ready for production use and can be found within the folder `analysis` in fhe file `solutions.sql`.
- ETL pipeline supports both development (using etl.json) and production (API calls) environments.
