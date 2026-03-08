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

)

SELECT

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

    DATE(o.order_ts) AS order_date,

    ol.quantity,
    ol.unit_price,

    ol.quantity * ol.unit_price AS line_amount,

    o.channel_code,

    ol.loaded_at

FROM order_lines ol

LEFT JOIN orders o
    ON ol.order_id = o.order_id

LEFT JOIN customers c
    ON o.customer_id = c.customer_id

LEFT JOIN products p
    ON ol.product_id = p.product_id