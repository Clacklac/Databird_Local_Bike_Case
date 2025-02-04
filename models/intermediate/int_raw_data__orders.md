{% docs int_raw_data__orders %}

This model provides an aggregated view of orders, combining data from multiple sources such as order items, user details, store and staff. It enriches the order data with the following metrics:

Total Order Amount: The sum of all order items for each order.
Count Items Per Order: The total quantity of items in the order.
Count Different Items Per Order: The count of distinct product types in the order.
Total Order Discount: The total amount of discount on items in the order.
Customer Name/ City/ State: Enriches the order with user-specific data, such as name, city and state.
Staff Name/ Manager Name: Enriches the order with staff specific data such as name and manager name.
Store Name: Enrichies the order with the store name to ease lisibility.
It provides a comprehensive view of each order, allowing for easy analysis of order performance, customer demographics, and feedback.

{% enddocs %}