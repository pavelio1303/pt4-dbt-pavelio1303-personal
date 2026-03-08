{% snapshot snapshot_customers %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

SELECT
    customer_id,
    full_name,
    email,
    country_code,
    customer_segment,
    signup_date,
    updated_at

FROM {{ ref('stg_customers') }}

{% endsnapshot %}