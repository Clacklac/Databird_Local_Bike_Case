WITH daily_order_summary AS (
SELECT
    order_date,
    order_month,
    order_year,
    count(*) as daily_cnt_order,
    avg(cnt_items_per_order) as daily_avg_items_per_order,
    avg(cnt_diff_items_per_order) as daily_avg_diff_items_per_order,
    sum(total_order_amount) as daily_profit,
    avg(total_order_amount) as daily_average_order_amount,
    sum(total_order_discount) as daily_discount_made,
    avg(total_order_discount) as daily_average_order_discount,
    sum(CASE 
        WHEN shipping_delay_in_days > 0 then 1
        ELSE 0
        END) as daily_cnt_orders_delayed
FROM `databirdlocalbike`.`dbt_cjouy_Local_Bike`.`int_raw_data__orders`
GROUP BY order_date,order_month,order_year
), monthly_order_summary AS (
SELECT
    order_month,
    order_year,
    avg(daily_cnt_order) as monthly_avg_daily_cnt_order,
    avg(daily_profit) as monthly_average_daily_profit,
    avg(daily_average_order_amount) as monthly_average_order_amount,
    sum(daily_cnt_orders_delayed)/sum(daily_cnt_order)*100 as monthly_order_delayed_percentage
FROM daily_order_summary
GROUP BY order_month,order_year
), yearly_order_summary AS (
SELECT
    order_year,
    avg(daily_cnt_order) as yearly_avg_daily_cnt_order,
    avg(daily_profit) as yearly_average_daily_profit,
    avg(daily_average_order_amount) as yearly_average_order_amount,
    sum(daily_cnt_orders_delayed)/sum(daily_cnt_order)*100 as yearly_order_delayed_percentage
FROM daily_order_summary
GROUP BY order_year
)


SELECT
    OD.order_date,
    OD.order_month,
    OD.order_year,
    OD.daily_cnt_order,
    ROUND(OD.daily_avg_items_per_order,0) AS daily_avg_items_per_order,
    ROUND(OD.daily_avg_diff_items_per_order) AS daily_avg_diff_items_per_order,
    ROUND(OD.daily_profit,2) AS daily_profit ,
    ROUND(OD.daily_average_order_amount,2) AS daily_average_order_amount,
    ROUND(OD.daily_discount_made,2) AS daily_discount_made,
    ROUND(OD.daily_average_order_discount,2) AS daily_average_order_discount ,
    OD.daily_cnt_orders_delayed,
    ROUND(OM.monthly_avg_daily_cnt_order,0) AS monthly_avg_daily_cnt_order,
    ROUND(OM.monthly_average_daily_profit,2) AS monthly_average_daily_profit,
    ROUND(OM.monthly_average_order_amount,2) AS monthly_average_order_amount,
    ROUND(OM.monthly_order_delayed_percentage,2) AS monthly_order_delayed_percentage,
    ROUND(OY.yearly_avg_daily_cnt_order,0) AS yearly_avg_daily_cnt_order,
    ROUND(OY.yearly_average_daily_profit,2) AS yearly_average_daily_profit,
    ROUND(OY.yearly_average_order_amount,2) AS yearly_average_order_amount,
    ROUND(OY.yearly_order_delayed_percentage,2) AS yearly_order_delayed_percentage,
    (CASE 
        WHEN OD.daily_cnt_order >= PERCENTILE_CONT(daily_cnt_order, 0.9) OVER(PARTITION BY OD.order_year)
        THEN TRUE
        ELSE  FALSE
        END) AS best_day_in_cnt_order,
    (CASE 
        WHEN OD.daily_profit >= PERCENTILE_CONT(daily_profit, 0.9) OVER(PARTITION BY OD.order_year) 
        THEN TRUE
        ELSE  FALSE
        END) AS best_day_in_profit
FROM daily_order_summary OD
INNER JOIN monthly_order_summary OM
ON OD.order_month=OM.order_month
    AND OD.order_year=OM.order_year 
INNER JOIN yearly_order_summary OY
ON OD.order_year= OY.order_year
