WITH source AS (

    SELECT *
    FROM {{ source('bronze','raw_order_lines') }}

),

cleaned AS (

    SELECT
        TRIM(order_id) AS order_line_id,
        TRIM(order_id) AS order_id,
        TRIM(product_id) AS product_id,
        quantity,
        unit_price,
        loaded_at

    FROM source

)

SELECT *
FROM cleaned