WITH source AS (

    SELECT *
    FROM {{ source('bronze', 'raw_customers') }}

),

cleaned AS (

    SELECT
        UPPER(TRIM(customer_id)) AS customer_id,
        
        -- Si necesitas separar el nombre (asumiendo formato "Nombre Apellido")
        UPPER(TRIM(SPLIT_PART(full_name, ' ', 1))) AS first_name,
        UPPER(TRIM(SPLIT_PART(full_name, ' ', 2))) AS last_name,
        
        -- O simplemente limpiar el nombre completo
        UPPER(TRIM(full_name)) AS full_name,
        
        UPPER(TRIM(email)) AS email,
        UPPER(TRIM(country_code)) AS country_code,
        UPPER(TRIM(customer_segment)) AS customer_segment,

        -- Timestamps con el casting a VARCHAR que ya aprendimos
        TRY_TO_DATE(signup_date::VARCHAR) AS signup_date,
        TRY_TO_TIMESTAMP(updated_at::VARCHAR) AS updated_at,
        TRY_TO_TIMESTAMP(loaded_at::VARCHAR) AS loaded_at

    FROM source

)

SELECT *
FROM cleaned