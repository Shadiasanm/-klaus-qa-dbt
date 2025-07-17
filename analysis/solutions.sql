-- 3.a. Weighted Rating Score Algorithm (ignoring N/A = 42)
-- Calculates the weighted average score per review, as a percentage (0-100).
SELECT
  review_id,
  ROUND(
    100 * SUM(CASE WHEN rating != 42 THEN rating * weight ELSE 0 END)
      / NULLIF(SUM(CASE WHEN rating != 42 THEN rating_max * weight ELSE 0 END), 0)
  , 2) AS weighted_score_pct
FROM
  `klaus.manual_rating`
GROUP BY
  review_id
ORDER BY
  review_id;

-- 3.b. Flag for latest autoqa review per conversation and reviewee
-- Adds a boolean field 'is_latest' indicating if the review is the most recent for each (conversation, reviewee) pair.
SELECT
  *,
  CASE
    WHEN created_at = MAX(created_at) OVER (
      PARTITION BY external_ticket_id, reviewee_internal_id
    )
    THEN TRUE ELSE FALSE
  END AS is_latest
FROM
  `klaus.autoqa_reviews_test`;
