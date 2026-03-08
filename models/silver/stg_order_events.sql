WITH source AS (

    SELECT *
    FROM {{ source('bronze','raw_order_events') }}

),

cleaned AS (

    SELECT
        TRIM(event_id) AS event_id,
        TRIM(order_id) AS order_id,
        event_ts,
        LOWER(TRIM(event_type)) AS event_type,
        LOWER(TRIM(event_status)) AS event_status,
        loaded_at

    FROM source

)

SELECT *
FROM cleaned