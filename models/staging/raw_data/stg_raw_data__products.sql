SELECT
    product_id,
    product_name,
    brand_id,
    category_id,
    list_price as unit_price,
    CAST(model_year as STRING) as product_model_year,
FROM 
    {{ source("Raw_data","products")}}