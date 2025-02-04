WITH customer_order_summary AS (
    SELECT 
        customer_id,
        count(*) as registered_orders,
        Sum(total_order_amount) as total_amount_spent,
        AVG(total_order_amount) as avg_amount_per_order,
        MAX(order_date) as last_purchase,
        MIN(order_date)  as first_purchase,
        DATE_DIFF(MAX(order_date),MIN(order_date),DAY) as longevity,
        count(*)/DATE_DIFF(MAX(order_date),MIN(order_date),DAY)*100 as frequency_for_100days,
        sum(CASE 
        WHEN shipping_delay_in_days > 0 then 1
        ELSE 0
        END) as cnt_orders_delayed,
        sum(CASE 
        WHEN shipping_delay_in_days > 0 then 1
        ELSE 0
        END)/count(*)* 100 as cnt_orders_delayed_percentage,
        sum(CASE 
        WHEN shipping_delay_in_days > 0 then 1
        ELSE 0
        END) as cnt_orders_delayed,
        sum(CASE 
        WHEN customer_state = store_state 
        THEN 1 
        ELSE 0 END) as home_state_order,
    FROM {{ref("int_raw_data__orders")}}
    GROUP BY customer_id
), 
customer_fav_product AS (
    SELECT
        customer_id,
        product_id AS favorite_product_id,
        product_name AS favorite_product_name,
        category_name AS favorite_product_category,
        brand_name AS favorite_brand_name,
        SUM(unit_quantity) AS total_quantity,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY SUM(unit_quantity) DESC) AS ranked_product
FROM
    {{ref("int_raw_data__order_items")}}
GROUP BY
    customer_id, product_id, product_name, category_name, brand_name
),
customer_fav_brand AS (
    SELECT
        customer_id,
        brand_name as favorite_brand,
        row_number() over (PARTITION BY customer_id,brand_name ORDER BY sum(unit_quantity) DESC) as ranked_brand 
    FROM {{ref("int_raw_data__order_items")}}
    GROUP BY customer_id, favorite_brand
),
customer_fav_cat AS (
    SELECT
        customer_id,
        category_name as favorite_brand,
        row_number() over (PARTITION BY customer_id,category_name ORDER BY sum(unit_quantity) DESC) as ranked_cat
    FROM {{ref("int_raw_data__order_items")}}
    GROUP BY customer_id,favorite_brand
),
customer_store_habits AS (
    SELECT
        customer_id,
        store_name,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY COUNT(*) DESC) AS ranked_store,
        SUM(CASE 
            WHEN customer_state = store_state THEN 0 
            ELSE 1 
        END) as diff_state_buyer
    FROM {{ref("int_raw_data__orders")}}
    GROUP BY customer_id, store_name,customer_state,store_state
)

SELECT customer_id,
    home_state_order,
    registered_orders
FROM customer_order_summary
