SELECT
  customer_id,
  first_name as customer_first_name,
  last_name as customer_last_name,
  CONCAT(first_name,' ',last_name) as customer_name,
  email as customer_email,
  phone as customer_phone,
  street as customer_street,
  city as customer_city,
  zip_code as customer_zip_code,
  state as customer_state,
FROM {{ source('Raw_data', 'customers') }}