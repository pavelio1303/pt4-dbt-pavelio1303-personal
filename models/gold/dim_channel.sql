{{ config(materialized='table') }}

WITH base_channels AS (

    SELECT DISTINCT
        -- Forzamos a que si hay un nulo, se convierta en la cadena 'UNKNOWN'
        COALESCE(channel_code, 'UNKNOWN') AS channel_code
    FROM {{ ref('stg_orders') }}

)

SELECT
    -- Aplicamos MD5 sobre una columna que ya sabemos que no tiene nulos
    MD5(channel_code) AS channel_key,

    channel_code,

    CASE
        WHEN channel_code = 'WEB' THEN 'Website'
        WHEN channel_code = 'APP' THEN 'Mobile App'
        WHEN channel_code = 'STORE' THEN 'Physical Store'
        WHEN channel_code = 'UNKNOWN' THEN 'Unknown / Not Specified'
        ELSE 'Other'
    END AS channel_name

FROM base_channels