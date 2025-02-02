SELECT
transaction_id,
date,
branch_id,
branch_name,
kota,
provinsi,
customer_name,
product_id,
product_name,
actual_price,
discount_percentage,
persentase_gross_laba,
nett_sales,
ROUND(nett_sales*(persentase_gross_laba/100),2) AS nett_profit,
rating_transaksi FROM (
  SELECT
  kft.transaction_id,
  kft.date,
  kkc.branch_id,
  kkc.branch_name,
  kkc.kota,
  kkc.provinsi,
  kft.customer_name,
  kp.product_id,
  kp.product_name,
  kp.price AS actual_price,
  kft.discount_percentage,

  CASE
  WHEN kp.price <= 50000 THEN 10
  WHEN kp.price <= 100000 THEN 15
  WHEN kp.price <= 300000 THEN 20
  WHEN kp.price <= 500000 THEN 25
  ELSE 30
  END AS persentase_gross_laba,

  kp.price*(1-kft.discount_percentage/100) AS nett_sales,

  kft.rating AS rating_transaksi
  FROM
  kimia_farma.kf_final_transaction kft
  JOIN kimia_farma.kf_kantor_cabang kkc ON
  kft.branch_id = kkc.branch_id
  JOIN kimia_farma.kf_product kp ON
  kft.product_id = kp.product_id
  WHERE
  kft.date >= '2020-01-01' AND kft.date <= '2023-12-31'
) AS profit_calculation
ORDER BY
date DESC,
transaction_id DESC;