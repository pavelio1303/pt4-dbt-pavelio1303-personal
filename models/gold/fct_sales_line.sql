{{ config(
    materialized='incremental',
    unique_key='sales_line_id',
    incremental_strategy='merge'
) }}

WITH order_lines AS (

    SELECT *
    FROM {{ ref('stg_order_lines') }}

    {% if is_incremental() %}
        WHERE loaded_at > (SELECT MAX(loaded_at) FROM {{ this }})
    {% endif %}

),

orders AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

),

customers AS (

    SELECT *
    FROM {{ ref('snapshot_customers') }}
    WHERE dbt_valid_to IS NULL

),

products AS (

    SELECT *
    FROM {{ ref('dim_products') }}

),

channels AS (

    SELECT *
    FROM {{ ref('dim_channel') }}

),

dates AS (

    SELECT *
    FROM {{ ref('dim_date') }}

)

SELECT
    -- Llave subrogada única para el modelo incremental
    MD5(
        CAST(
            COALESCE(CAST(ol.order_id AS VARCHAR),'')
            || '-' ||
            COALESCE(CAST(ol.line_number AS VARCHAR),'')
        AS VARCHAR)
    ) AS sales_line_id,

    ol.order_id,
    p.product_id,
    c.customer_id,

    -- Renombramos explícitamente para que coincida con tu YAML y tus dimensiones
    d.date_key,
    ch.channel_key,

    ol.quantity,
    ol.unit_price,
    ol.quantity * ol.unit_price AS line_amount,

    ol.loaded_at

FROM order_lines ol
LEFT JOIN orders o
    ON ol.order_id = o.order_id
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN products p
    ON ol.product_id = p.product_id
LEFT JOIN channels ch
    ON o.channel_code = ch.channel_code
LEFT JOIN dates d
    ON DATE(o.order_ts) = d.date_key