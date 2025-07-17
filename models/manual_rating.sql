{{ config(materialized='view') }}

select
    payment_id,
    team_id,
    review_id,
    category_id,
    rating,
    cause,
    rating_max,
    weight,
    critical,
    category_name
from {{ ref('raw_manual_rating') }}
