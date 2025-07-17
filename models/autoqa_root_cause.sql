{{ config(materialized='view') }}

select
    autoqa_rating_id,
    category,
    root_cause,
    count
from {{ ref('raw_autoqa_root_cause') }}
