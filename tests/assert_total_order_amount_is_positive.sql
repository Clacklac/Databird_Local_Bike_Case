select
    order_id,
    sum(total_order_item_amount) as total_order_amount
from {{ ref('stg_raw_data__order_items') }}
group by order_id
having total_order_amount < 0