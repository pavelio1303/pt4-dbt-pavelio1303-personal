WITH source AS (

    SELECT *
    FROM {{ source('bronze', 'raw_order_lines') }}

),

cleaned AS (

    SELECT
        -- Identificadores
        TRIM(order_id) AS order_id,
        CAST(line_number AS INT) AS line_number,
        TRIM(product_id) AS product_id,

        -- Métricas (Conversión segura a numérico)
        TRY_TO_NUMBER(quantity::VARCHAR) AS quantity,
        TRY_TO_DECIMAL(unit_price::VARCHAR, 12, 2) AS unit_price,
        TRY_TO_DECIMAL(discount_amount::VARCHAR, 12, 2) AS discount_amount,

        -- Timestamps (Blindados contra el error 001065)
        TRY_TO_TIMESTAMP(loaded_at::VARCHAR) AS loaded_at

    FROM source

),

transformed AS (

    SELECT
        *,
        -- Cálculos de negocio derivados
        COALESCE(quantity, 0) * COALESCE(unit_price, 0) AS gross_item_sales_amount,
        (COALESCE(quantity, 0) * COALESCE(unit_price, 0)) - COALESCE(discount_amount, 0) AS net_item_sales_amount,
        
        CASE 
            WHEN product_id LIKE '%UNKNOWN%' THEN TRUE 
            ELSE FALSE 
        END AS is_product_id_placeholder

    FROM cleaned

)

SELECT *
FROM transformed