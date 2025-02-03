SELECT
    S.staff_id as staff_id,
    S.first_name as staff_first_name,
    S.last_name as staff_last_name,
    CONCAT(first_name,' ',last_name) as staff_name,
    S.store_id as staff_store_id,
    S.active as is_active,
    S.email as staff_email,
    S.phone as staff_phone,
    S.manager_id as manager_id,
    CONCAT(M.first_name,' ',M.last_name) as manager_name
FROM
  {{source("Raw_data","staffs")}} S
LEFT JOIN   {{source("Raw_data","staffs")}} M
ON S.manager_id = M.staff_id