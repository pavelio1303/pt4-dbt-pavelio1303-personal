WITH source AS (

    SELECT *
    FROM {{ source('bronze','raw_orders') }}

),

cleaned AS (

    SELECT
        TRIM(order_id) AS order_id,
        TRIM(customer_id) AS customer_id,
        order_ts,
        TRIM(channel_code) AS channel,
        loaded_at

    FROM source

)

SELECT *
FROM cleaned