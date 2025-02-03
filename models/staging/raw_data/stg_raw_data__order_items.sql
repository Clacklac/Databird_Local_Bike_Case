SELECT
  concat(order_id,'_',item_id) as order_item_id,
  item_id,
  order_id,
  product_id,
  list_price as unit_price,
  discount as discount_percentage,
  list_price*discount as discount_amount_per_unit,
  quantity as unit_quantity,
  quantity*(list_price*(1-discount)) as total_order_item_amount
FROM
  {{ source('Raw_data', 'order_items') }}