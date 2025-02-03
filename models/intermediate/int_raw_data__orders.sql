WITH order_item_informations AS (
    SELECT 
        sum(quantity) as cnt_items_per_order,
        count(distinct(product_id)) as cnt_diff_products_per_order,
        sum(total_order_item_amount) as total_order_amount,
        sum(quantity*discount_amount_per_unit) as total_order_discount
    FROM {{ref("stg_raw_data__order_items")}}
    GROUP BY order_id
)



SELECT 
    O.order_id,
    cnt_items_per_order,
    cnt_diff_products_per_order,
    total_order_amount,
    total_order_discount,
    O.customer_id,
    C.customer_name,
    S.staff_name, 
    So.store_name,
    O.order_date,
    O.order_status,
    O.shipping_delay_in_days,
FROM {{ref('stg_raw_data__orders')}} O  
LEFT JOIN {{ref('stg_raw_data__staffs')}} S
ON O.staff_id = S.staff_id 
LEFT JOIN {{ref('stg_raw_data__customers')}} C
ON O.customer_id = C.customer_id 
LEFT JOIN {{ref('stg_raw_data__stores')}} So
ON O.store_id = So.store_id

