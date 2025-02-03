SELECT
    store_id,
    store_name,
    street as store_street,
    city as store_city,
    zip_code as store_zip_code, 
    state as store_state,
    email as store_email,
    phone as store_phone,
FROM
    {{ source("Raw_data","stores")}}