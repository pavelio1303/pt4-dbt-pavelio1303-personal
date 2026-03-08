WITH source AS (

    SELECT *
    FROM {{ source('bronze','raw_customers') }}

),

cleaned AS (

    SELECT
        TRIM(customer_id) AS customer_id,
        TRIM(full_name) AS full_name,
        LOWER(TRIM(email)) AS email,
        UPPER(TRIM(country_code)) AS country_code,
        TRIM(customer_segment) AS customer_segment,
        signup_date,
        updated_at,
        loaded_at

    FROM source

)

SELECT *
FROM cleaned