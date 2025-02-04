SELECT 
    OI.order_item_id,
    OI.order_id,
    OI.product_id,
    P.product_name,
    P.brand_id,
    P.category_id,
    B.brand_name,
    C.category_name,
    O.customer_id,
    O.customer_name,
    O.customer_state,
    O.store_name,
    O.staff_name,
    O.manager_name,
    OI.discount_amount_per_unit, 
    OI.unit_quantity,
    OI.discount_amount_per_unit * unit_quantity as total_order_item_discount_amount,
    OI.total_order_item_amount
FROM {{ ref('stg_raw_data__order_items')}} OI
LEFT JOIN {{ ref('stg_raw_data__products')}} P
ON OI.product_id = P.product_id
LEFT JOIN {{ ref('stg_raw_data__brands')}} B
ON P.brand_id = B.brand_id
LEFT JOIN {{ ref('stg_raw_data__categories')}} C
ON P.category_id = C.category_id
LEFT JOIN {{ ref('int_raw_data__orders')}} O
ON OI.order_id = O.order_id