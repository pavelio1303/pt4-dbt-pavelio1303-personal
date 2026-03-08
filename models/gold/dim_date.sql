{{ config(materialized='table') }}

WITH dates AS (

    SELECT DISTINCT
        DATE(order_ts) AS date_day
    FROM {{ ref('stg_orders') }}

)

SELECT

    date_day AS date_key,

    EXTRACT(YEAR FROM date_day) AS year,

    EXTRACT(MONTH FROM date_day) AS month,

    EXTRACT(DAY FROM date_day) AS day,

    EXTRACT(QUARTER FROM date_day) AS quarter,

    DAYOFWEEK(date_day) AS day_of_week

FROM dates