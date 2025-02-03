SELECT
    order_id,
    customer_id,
    staff_id,
    store_id,
    order_date as order_date,
    CAST(order_status as STRING) as order_status,
    required_date as required_date,
    DATE(CASE shipped_date when 'NULL' then NULL else shipped_date END) as shipped_date,
    CASE
        WHEN shipped_date IN ('NULL') THEN NULL
        ELSE DATE_DIFF(DATE(shipped_date),DATE(required_date),DAY)
    END AS shipping_delay_in_days
FROM {{ source("Raw_data","orders") }}   
