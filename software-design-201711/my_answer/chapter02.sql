-- /**
-- * 第2章
-- * 
-- * ※ 第1章は環境構築のため2章から
-- */

-- ノック1 --
SELECT
  *
FROM
  payment;

-- ◯

-- ノック2 --
SELECT
  *
FROM
  customer
WHERE
  first_name = 'KELLY' -- ×

SELECT
  payment_id,
  customer_id
FROM
  payment
WHERE
  customer_id = 1;

-- ノック3 --
SELECT
  *
FROM
  customer
WHERE
  first_name = 'KELLY';

-- ◯

-- ノック4 --
SELECT
  *
FROM
  customer
WHERE
  first_name = 'KELLY'
  AND last_name = 'KNOTT';

-- ◯

-- ノック5 --
SELECT
  *
FROM
  customer
WHERE
  first_name = 'KELLY'
  OR first_name = 'MARIA';

-- ◯

-- ノック6 --
SELECT
  *
FROM
  customer
WHERE
  first_name <> 'KELLY'
  OR first_name <> 'MARIA';

-- ◯

SELECT
  first_name,
  last_name
FROM
  customer
WHERE
  NOT (
    first_name = 'KELLY'
    OR first_name = 'MARIA'
  );

-- ノック7 --
SELECT
  first_name,
  last_name
FROM
  customer
WHERE
  first_name = 'ARRON'
  OR first_name = 'ADAM'
  OR first_name = 'ANN';

-- ×

SELECT
  first_name,
  last_name
FROM
  customer
WHERE
  first_name IN ('AARON', 'ADAM', 'ANN');

-- ノック8 --
SELECT
  *
FROM
  payment
WHERE
  amount > 6.99;

-- ×

SELECT
  *
FROM
  payment
WHERE
  amount >= 6.99;

-- ノック9 --
SELECT
  *
FROM
  payment
WHERE
  amount != 0.99;

-- ◯

-- ノック10 --
SELECT
  rental_id,
  return_date
FROM
  rental
WHERE
  return_date IS NULL;

-- ◯

-- ノック11 --
SELECT
  rental_id,
  return_date
FROM
  rental
WHERE
  return_date IS NOT NULL;

-- ◯

-- ノック12 --
SELECT
  customer_id,
  first_name,
  last_name
FROM
  customer
WHERE
  customer_id BETWEEN 11
  AND 13;

-- ◯

-- ノック13 --
SELECT
  title,
  description
FROM
  film
WHERE
  description LIKE '%Amazing%';

-- ◯

-- ノック14 --
SELECT
  title,
  description
FROM
  film
WHERE
  description NOT LIKE '%Amazing%';

-- ◯

-- ノック15 --
SELECT
  count(*)
FROM
  payment;

-- ◯

-- ノック16 --
SELECT
  DISTINCT payment_id
FROM
  payment;

-- ×

SELECT
  DISTINCT customer_id
FROM
  payment;

-- ノック17 --
SELECT
  count (DISTINCT customer_id)
FROM
  payment;

-- ◯

-- ノック18 --
SELECT
  customer_id,
  last_name
FROM
  customer
ORDER BY
  last_name ASC;

-- ◯

-- ノック19 --
SELECT
  customer_id,
  first_name,
  last_name
FROM
  customer
ORDER BY
  customer_id DESC;

-- ◯

-- ノック20 --
SELECT
  customer_id,
  first_name,
  last_name
FROM
  customer
ORDER BY
  customer_id DESC
LIMIT
  3;

-- ◯

-- ノック21 --
SELECT
  customer_id,
  count(*)
FROM
  payment
GROUP BY
  customer_id
ORDER BY
  count(*) DESC
LIMIT
  3;

-- ◯

-- ノック22 --
SELECT
  customer_id,
  ROUND(amount * 109, 0)
FROM
  payment
LIMIT
  10;

-- ×

SELECT
  amount * 110 AS amount_yen
FROM
  payment
LIMIT
  3;

-- ノック23 --
SELECT
  customer_id,
  ROUND(amount * 110, 0) || 'yen'
FROM
  payment
LIMIT
  10;

-- ◯

SELECT
  CONCAT(ROUND(amount * 110), 'yen') AS amount_yen
FROM
  payment
LIMIT
  3;