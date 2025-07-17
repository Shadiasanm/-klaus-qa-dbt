# klaus-qa-dbt

This repository contains the dbt data model for the Klaus QA exercise, designed for Snowflake.

## Structure

- `models/`: Contains all dbt models (one per entity/table).
- `models/schema.yml`: Descriptions and tests for each model.
- `analysis/solutions.sql`: SQL solutions for the technical tasks required.
- `dbt_project.yml`: dbt project configuration.

## How to use

1. Clone this repository.
2. Configure your `profiles.yml` for Snowflake.
3. Run `dbt run` to build the models.
4. Run `dbt test` to validate uniqueness and relationships.

## Entities

- **conversation**: Customer support ticket or conversation.
- **autoqa_review**: Automated review for a conversation.
- **autoqa_rating**: Category-level score within an automated review.
- **autoqa_root_cause**: Root causes for an automated rating.
- **manual_review**: Manual review performed by a human reviewer.
- **manual_rating**: Category-level score within a manual review.

## Notes

- All models are materialized as views.
- Source tables (e.g., `raw_conversation`) should be replaced with your actual raw data sources.
- Tests for uniqueness and referential integrity are defined in `schema.yml`.
- SQL solutions are tested (in BQ) and ready for production use and can be found within the folder `analysis` in fhe file `solutions.sql`.
