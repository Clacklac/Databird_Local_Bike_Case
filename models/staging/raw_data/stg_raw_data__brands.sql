SELECT 
    brand_id,
    brand_name
FROM {{ source('Raw_data', 'brands') }}