SELECT
  t.transaction_id,
  t.date,
  t.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  t.customer_name,
  p.product_id,
  p.product_name,
  t.price AS actual_price,
  t.discount_percentage,
  CASE
    WHEN t.price <=50000 THEN 0.10
    WHEN t.price > 50000
  AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000
  AND t.price <= 500000 THEN 0.25
    WHEN t.price > 500000 THEN 0.30
END
  AS persentase_gross_laba,
  (t.price * (1 - t.discount_percentage/100)) AS nett_sales,
  ((t.price * (1 - t.discount_percentage/100)) *
    CASE
      WHEN t.price <=50000 THEN 10/100
      WHEN t.price > 50000
    AND t.price <= 100000 THEN 15/100
      WHEN t.price > 100000 AND t.price <= 300000 THEN 20/100
      WHEN t.price > 300000
    AND t.price <= 500000 THEN 25/100
      WHEN t.price > 500000 THEN 0.30
  END
    ) AS nett_profit,
  t.rating AS rating_transaksi
FROM
  rakamin-kf-analytics-478501.kimia_farma.kf_final_transaction AS t
LEFT JOIN
  rakamin-kf-analytics-478501.kimia_farma.kf_kantor_cabang AS kc
ON
  kc.branch_id = t.branch_id
LEFT JOIN
  rakamin-kf-analytics-478501.kimia_farma.kf_product AS p
ON
  t.product_id = p.product_id