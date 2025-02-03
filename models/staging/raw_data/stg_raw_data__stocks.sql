SELECT
    CONCAT(product_id,'_',store_id) as product_store_stock_id,
    product_id,
    stock_quantity,
    store_id
FROM
  {{source("Raw_data","stocks")}};