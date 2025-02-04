select
    order_id,
    sum(unit_quantity) as cnt_items_per_order
from {{ ref('stg_raw_data__order_items') }}
group by order_id
having cnt_items_per_order <= 0