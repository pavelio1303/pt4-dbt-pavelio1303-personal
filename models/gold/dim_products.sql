{{ config(materialized='table') }}

SELECT

    product_id,

    product_name,
    category_code,
    base_price,

    CURRENT_TIMESTAMP AS created_at

FROM {{ ref('stg_products') }}