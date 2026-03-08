WITH source AS (

    SELECT *
    FROM {{ source('bronze','raw_products') }}

),

cleaned AS (

    SELECT
        TRIM(product_id) AS product_id,
        TRIM(product_name) AS product_name,
        TRIM(category_code) AS category_code,
        base_price,
        updated_at,
        loaded_at

    FROM source

)

SELECT *
FROM cleaned