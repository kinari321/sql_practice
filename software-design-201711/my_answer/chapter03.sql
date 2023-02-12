-- /**
-- * 第3章
-- */
-- ノック24 --
SELECT
    payment_id,
    last_name,
    first_name
FROM
    payment
    LEFT JOIN customer ON payment.customer_id = customer.customer_id
LIMIT
    3;

-- ◯

SELECT
    payment_id,
    last_name,
    first_name
FROM
    payment
    LEFT JOIN customer USING(customer_id);

-- ノック25 --
SELECT
    payment_id,
    customer_id,
    amount,
    last_name,
    first_name
FROM
    payment
    LEFT JOIN customer USING(customer_id)
WHERE
    customer.last_name = 'WYMAN'
    AND customer.first_name = 'BRIAN';

SELECT
    payment_id,
    p.customer_id,
    amount
FROM
    payment AS p
    INNER JOIN customer AS c ON p.customer_id = c.customer_id
WHERE
    first_name = 'BRIAN'
    AND last_name = 'WYMAN';

-- ×
 
SELECT
    payment_id,
    payment.customer_id,
    amount
FROM
    payment
    INNER JOIN customer ON payment.customer_id = customer.customer_id
WHERE
    first_name = 'BRIAN'
    AND last_name = 'WYMAN';

-- ↓↓↓ テーブル ↓↓↓ --
-- [filmテーブル]
--  film_id
--  title
--  description
--  release_year
--  language_id
--  original_language_id
--  rental_duration
--  rental_rate
--  length
--  replacement_cost
--  rating
-- [film_categoryテーブル]
--  film_id
--  category_id
-- [categoryテーブル]
--  category_id
--  name
-- ↑↑↑ テーブル ↑↑↑ --

-- ノック26 --

-- ×

-- WHERE → GROUP BY → HAVING
SELECT
    category.name AS "Category Name",
    COUNT(film_category.film_id) AS "Number of Films"
FROM
    category
    INNER JOIN film_category ON category.category_id = film_category.category_id
    INNER JOIN film ON film_category.film_id = film.film_id
GROUP BY
    category.name
HAVING
    COUNT(film_category.film_id) >= 65;

SELECT
    category.name AS name,
    COUNT(category.name) AS film_cnt
FROM
    film
    INNER JOIN film_category USING(film_id)
    INNER JOIN category USING(category_id)
GROUP BY
    category.name
HAVING
    COUNT(category.name) >= 65
ORDER BY
    film_cnt DESC;

-- 全体 → HAVING句を削る → WHERE句を削る
SELECT
    category.name AS name,
    COUNT(category.name) AS film_cnt
FROM
    film
    INNER JOIN film_category USING(film_id)
    INNER JOIN category USING(category_id)
WHERE
    category.name IN('Sports', 'Games', 'Travel')
GROUP BY
    category.name
HAVING
    COUNT(category.name) > 60
ORDER BY
    film_cnt DESC;

-- ノック27 --
-- paymentテーブルで、支払い額が5を超える場合はexpensive、 
-- 1を超える場合はmodest、そうでなければcheapと表示する
SELECT
    CASE
        WHEN amount >= 5 THEN 'expensive'
        WHEN amount >= 1 THEN 'modest'
        ELSE 'cheep'
    END AS price
FROM
    payment;

-- ×

SELECT
    payment_id,
    amount,
    CASE
        WHEN amount > 5 THEN 'expensive'
        WHEN amount > 1 THEN 'modest'
        ELSE 'cheep'
    END AS price_range
FROM
    payment;

-- ノック28 --
SELECT
    count(*)
FROM
    film
WHERE
    description LIKE '%Thoughtful%'
    OR description LIKE '%Insightful%';

-- ◯

SELECT
    count(*)
FROM
    film
WHERE
    description ~ '(Thou|Insi)ghtful';

-- ノック29 --
SELECT
    customer_id,
    SUM(amount)
FROM
    payment
GROUP BY
    customer_id
ORDER BY
    SUM(amount) DESC
LIMIT
    5;

-- ◯

-- ノック30 --
SELECT
    SUM(amount) AS total_sales,
    CAST(payment_date AS DATE) AS payment_date
FROM
    payment
GROUP BY
    payment_date
ORDER BY
    total_sales DESC
LIMIT
    5;

-- ×

SELECT
    SUM(amount) AS total_sales,
    CAST(payment_date AS DATE) AS p_date
FROM
    payment
GROUP BY
    p_date
ORDER BY
    total_sales DESC
LIMIT
    5;

-- ノック31 --
SELECT
    SUM(amount) AS total_sales,
    to_char(payment_date, 'YYYY-MM') AS MONTH
FROM
    payment
GROUP BY
    MONTH
ORDER BY
    MONTH DESC
LIMIT
    5;

-- ◯

SELECT
    EXTRACT(
        YEAR
        FROM
            payment_date
    ) AS yyyy,
    EXTRACT(
        MONTH
        FROM
            payment_date
    ) AS mm,
    SUM(amount) AS total_sales
FROM
    payment
GROUP BY
    yyyy,
    mm
ORDER BY
    mm;

SELECT
    LEFT(CAST(payment_date AS VARCHAR), 7) AS yyyymm,
    SUM(amount) AS total_sales
FROM
    payment
GROUP BY
    yyyymm
ORDER BY
    yyyymm;

-- ノック32 --
SELECT
    SUM(amount) AS total_sales
FROM
    payment
WHERE
    payment_date BETWEEN '2007-01-01'
    AND '2007-01-31';

-- ×

-- 自分の答えは時刻情報が丸められていない。
SELECT
    SUM(amount) AS total_sales
FROM
    payment
WHERE
    CAST(payment_date AS DATE) BETWEEN '2007-01-01'
    AND '2007-01-31';