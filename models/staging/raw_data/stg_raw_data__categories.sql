SELECT 
    category_id,
    category_name
FROM {{ source('Raw_data', 'categories') }}