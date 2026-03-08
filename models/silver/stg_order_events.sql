WITH source AS (

    SELECT *
    FROM {{ source('bronze', 'raw_order_events') }}

),

cleaned AS (

    SELECT
        TRIM(event_id) AS event_id,
        TRIM(order_id) AS order_id,

        -- Forzamos a VARCHAR antes del TRY_TO_TIMESTAMP para evitar el error de Snowflake
        TRY_TO_TIMESTAMP(event_ts::VARCHAR) AS event_at,
        TRY_TO_TIMESTAMP(loaded_at::VARCHAR) AS loaded_at,

        LOWER(TRIM(event_type)) AS event_type,
        LOWER(TRIM(event_status)) AS event_status

    FROM source

),

final AS (

    SELECT
        *,
        CURRENT_TIMESTAMP() AS processed_at
    FROM cleaned

)

SELECT *
FROM final