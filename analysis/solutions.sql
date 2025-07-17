-- 3.a. Weighted Rating Score Algorithm (ignoring N/A = 42)
-- Calculates the weighted average score per review, as a percentage (0-100).
-- This version normalizes each rating by its category maximum before applying the weight.

SELECT
  review_id,
  ROUND(
    SUM(
      CASE
        WHEN rating != 42 THEN (CAST(rating AS FLOAT64) / NULLIF(rating_max, 0)) * weight
        ELSE 0
      END
    )
    /
    NULLIF(SUM(CASE WHEN rating != 42 THEN weight ELSE 0 END), 0) * 100,
    2
  ) AS weighted_score_pct
FROM
  `klaus.manual_rating`
GROUP BY
  review_id
ORDER BY
  review_id;


-- 3.b. Flag for latest autoqa review per conversation and reviewee
-- Handles ties by using ROW_NUMBER() as a tiebreaker for deterministic results.

WITH latest_per_pair AS (
  SELECT
    external_ticket_id,
    reviewee_internal_id,
    MAX(created_at) AS max_created_at
  FROM
    `klaus.autoqa_reviews_test`
  GROUP BY
    external_ticket_id, reviewee_internal_id
),
latest_with_tiebreaker AS (
  SELECT
    r.external_ticket_id,
    r.reviewee_internal_id,
    r.autoqa_review_id,
    r.created_at,
    ROW_NUMBER() OVER (
      PARTITION BY r.external_ticket_id, r.reviewee_internal_id
      ORDER BY r.created_at DESC, r.autoqa_review_id DESC
    ) AS row_rank
  FROM
    `klaus.autoqa_reviews_test` r
  JOIN
    latest_per_pair l
  ON
    r.external_ticket_id = l.external_ticket_id
    AND r.reviewee_internal_id = l.reviewee_internal_id
    AND r.created_at = l.max_created_at
)
SELECT
  r.*,
  CASE
    WHEN lwt.row_rank = 1 THEN TRUE
    ELSE FALSE
  END AS is_latest
FROM
  `klaus.autoqa_reviews_test` r
LEFT JOIN
  latest_with_tiebreaker lwt
ON
  r.autoqa_review_id = lwt.autoqa_review_id;
