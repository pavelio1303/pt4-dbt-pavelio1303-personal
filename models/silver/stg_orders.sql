WITH source AS (

    SELECT *
    FROM {{ source('bronze', 'raw_orders') }}

),

cleaned AS (

    SELECT
        -- IDs
        TRIM(order_id) AS order_id,
        
        CASE 
            WHEN TRIM(customer_id) = '' OR customer_id IS NULL THEN 'UNKNOWN'
            WHEN customer_id LIKE 'C_ORPHAN_%' THEN 'ORPHAN'
            ELSE TRIM(customer_id)
        END AS customer_id,

        -- Timestamps con casting a VARCHAR para evitar el error 001065
        TRY_TO_TIMESTAMP(order_ts::VARCHAR) AS order_ts,
        TRY_TO_TIMESTAMP(loaded_at::VARCHAR) AS loaded_at,

        -- Estandarización
        UPPER(TRIM(channel_code)) AS channel_code,
        UPPER(TRIM(currency_code)) AS currency_code,
        LOWER(TRIM(order_status)) AS order_status

    FROM source

),

final AS (

    SELECT
        *,
        CASE 
            WHEN customer_id IN ('UNKNOWN', 'ORPHAN') THEN TRUE 
            ELSE FALSE 
        END AS is_invalid_customer,
        
        CASE 
            WHEN currency_code IS NULL OR currency_code = '' THEN TRUE 
            ELSE FALSE 
        END AS is_currency_missing

    FROM cleaned

)

SELECT *
FROM final