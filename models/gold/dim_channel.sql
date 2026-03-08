{{ config(materialized='table') }}

WITH channels AS (

    SELECT DISTINCT
        channel_code
    FROM {{ ref('stg_orders') }}

)

SELECT

    MD5(channel_code) AS channel_key,

    channel_code,

    CASE
        WHEN channel_code = 'WEB' THEN 'Website'
        WHEN channel_code = 'APP' THEN 'Mobile App'
        WHEN channel_code = 'STORE' THEN 'Physical Store'
        ELSE 'Other'
    END AS channel_name

FROM channels