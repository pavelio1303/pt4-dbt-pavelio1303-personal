WITH source AS (

    SELECT *
    FROM {{ source('bronze', 'raw_products') }}

),

cleaned AS (

    SELECT
        TRIM(product_id) AS product_id,
        INITCAP(TRIM(product_name)) AS product_name,
        UPPER(TRIM(category_code)) AS category_code,
        UPPER(TRIM(brand)) AS brand,
        CAST(base_price AS DECIMAL(12, 2)) AS base_price,

        -- Normalización de booleanos
        CASE 
            WHEN LOWER(TRIM(is_active)) IN ('true', 'y', 'yes', '1', 't', 's') THEN TRUE
            WHEN LOWER(TRIM(is_active)) IN ('false', 'n', 'no', '0', 'f') THEN FALSE
            ELSE NULL 
        END AS is_active,

        -- Casting a VARCHAR para evitar el error de compilación de Snowflake
        TRY_TO_TIMESTAMP(updated_at::VARCHAR) AS updated_at,
        TRY_TO_TIMESTAMP(loaded_at::VARCHAR) AS loaded_at

    FROM source

)

SELECT *
FROM cleaned