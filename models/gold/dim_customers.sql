{{ config(materialized='table') }}

SELECT

    dbt_scd_id AS customer_key,

    customer_id,
    full_name,
    email,
    country_code,

    dbt_valid_from,
    dbt_valid_to

FROM {{ ref('snapshot_customers') }}