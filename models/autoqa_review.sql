{{ config(materialized='view') }}

select
    autoqa_review_id,
    payment_id,
    payment_token_id,
    external_ticket_id,
    created_at,
    conversation_created_at,
    conversation_created_date,
    team_id,
    reviewee_internal_id,
    updated_at
from {{ ref('raw_autoqa_review') }}
