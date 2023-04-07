-- /**
-- * 第4章
-- */

-- ノック33 --
/**
* payment テーブルから顧客 ID ごとに累計売上を合計し、
* 1 顧客あたりの平均売上、最低売上、最高売上を求める
**/

SELECT 
  customer_id, 
  SUM(amount) AS total_sales, 
  AVG(amount) AS average_sales, 
  MIN(amount) AS minimum_sales, 
  MAX(amount) AS maximum_sales
FROM 
  payment
GROUP BY 
  customer_id
LIMIT 10
;

-- ◯
-- サブクエリはインデックスが効かなく可読性も良くないため、なるべくJOINを用いよう

SELECT
  AVG(total_sales),
  MIN(total_sales),
  MAX(total_sales)
FROM
  (SELECT
  customer_id,
  SUM(amount) AS total_sales
  FROM  payment
  GROUP BY customer_id
  ) AS customer_payment
;


-- ノック34 --
/**
* customer テーブルと payment_p2007_05 テーブルから JOIN を用いて、
* 2007年5月に支払いのあった顧客のlast_name を抽出する
**/

SELECT 
  last_name
FROM 
  payment_p2007_05 
  LEFT JOIN 
    customer USING(customer_id)
LIMIT 5;

-- ◯ 
/**
  ある列の値が指定した複数の値のいずれかに一致する行を検索するための演算子
**/

SELECT last_name
  FROM cusomer AS C
  INNER JOIN payment_p2007_05 AS p
  ON c.customer_id = p.customer_id
;

-- ノック35 --
/**
* IN を用いて、2007 年 5 月に支払いの
* あった顧客のlast_nameを抽出する
**/

SELECT last_name 
FROM customer
WHERE payment_date
IN
(SELECT * FROM payment_p2007_05)
;

-- ×
/**
  IN句: WHEREとサブクエリ内INのSELECTが対応している
**/

SELECT last_name
FROM customer
WHERE customer_id IN
(
  SELECT customer_id
  FROM payment_p2007_05
);

-- ノック36 --
/**
* payment_p2007_05 テーブルから、EXISTS を用いて、2007 年 5 月に支払い
* のあった顧客のlast_nameを抽出する
**/

SELECT count(*)
FROM customer
WHERE EXISTS
(
  SELECT customer_id
  FROM payment_p2007_05
)
;

-- ×
-- 上記だとすべてのcustomerが抽出されるだけなので、結合条件が必要

/**
  EXISTS句: 
    SELECT 句のカラムは結果に影響せず、慣例 的に 1 が使われることが多い
    JOINよりも高速
    IN句との使い分け
      - サブクエリの結果が小さくなる場合は、IN を 使う
      - 親クエリの結果が小さくなる場合は、EXISTS を使う
**/

SELECT last_name FROM customer AS c
WHERE EXISTS
(
  SELECT 1 
  FROM payment_p2007_05 AS p
  WHERE c.customer_id = p.customer_id
);

-- ノック37 --
/**
* 1 月と 5 月の支払い履歴(payment_p2007_01/05 テーブル)から、
* どちらかに含まれる customer_id を抽出する
**/

SELECT customer_id 
FROM payment_p2007_01
UNION
SELECT customer_id 
FROM payment_p2007_05;

-- ×
/**
  上記だと重複を削除してしまっているのでNG
**/

SELECT DISTINCT customer_id 
FROM payment_p2007_01
UNION
SELECT DISTINCT customer_id 
FROM payment_p2007_05;

-- ノック38 --
/**
* 1 月と 5 月の支払い履歴(payment_p2007_01/05 テーブル)から、
* 両方に含まれるcustomer_idを抽出する
**/

SELECT customer_id
FROM payment_p2007_01
INTERSECT
SELECT customer_id
FROM payment_p2007_05
;

-- ◯
-- あっているがDISTINCTをつけた方がいいらしい

SELECT DISTINCT customer_id
FROM payment_p2007_01
INTERSECT
SELECT DISTINCT customer_id
FROM payment_p2007_05
;

-- ノック39 --
/**
* 1、2、3 月の支払い履歴(payment_ p2007_01/02/03 テーブル)から、
* すべてに含まれる customer_id を抽出する
**/

SELECT DISTINCT customer_id
FROM payment_p2007_01
INTERSECT
SELECT DISTINCT customer_id
FROM payment_p2007_02
INTERSECT
SELECT DISTINCT customer_id
FROM payment_p2007_03
;

-- ◯


-- ノック40 --
/**
* payment_p2007_01/05 テーブルから、5 月に支払いがあって、
* 1 月には支払いがなかった customer_id を抽出する
**/
SELECT DISTINCT customer_id
FROM payment_p2007_05
EXCEPT
SELECT DISTINCT customer_id
FROM payment_p2007_01
;

-- ◯

-- ノック41 --
/**
* payment_p2007_01/05 テーブルから、1 月または 5 月に支払いがあった顧客を、
*  customer_id の昇順で 3 件のみ抽出する
**/
SELECT customer_id 
FROM(
  SELECT DISTINCT customer_id 
  FROM payment_p2007_01
  UNION
  SELECT DISTINCT customer_id 
  FROM payment_p2007_05
) AS common_customers
ORDER BY customer_id ASC
LIMIT 3
;

-- ◯ 
-- あってるけど冗長

SELECT DISTINCT customer_id 
FROM payment_p2007_01
UNION
SELECT DISTINCT customer_id 
FROM payment_p2007_05
ORDER BY customer_id ASC
LIMIT 3;

-- ノック42 --
/**
* WITH 句を使って、c テーブルから
* 1 月に 7 回以上支払いのあったアクティブなcustomerのemail を抽出する
**/
WITH count_payment_p2007_01 as 
  (
    select customer_id, count(*) 
    from payment_p2007_01 
    group by customer_id 
    order by customer_id asc
  ) 
select email from customer left join count_payment_p2007_01 c 
using(customer_id) where c.count > 6;

-- ◯
WITH loyal_customers AS (
  SELECT
    customer_id,
    COUNT(*) AS cnt
  FROM
    payment_p2007_01
  GROUP BY
    customer_id
  HAVING
    COUNT(*) >= 7
)
SELECT email
FROM
  customer AS c
  INNER JOIN loyal_customers AS lc
    ON c.customer_id = lc.customer_id
WHERE
c.active = 1 ;

-- 補足--
/**
[ウィンドウ関数について]
・グループ化されたデータに対して、集計処理を行うために使用する
・集計やランキング、移動平均などの処理を実行する関数
・OVER句を使用し、PARTITION BYでグループの単位を決め、ORDER BY並び替えを決める

（分かりやすい例）
SELECT
    customer_id,
    amount,
    RANK() OVER (
      PARTITION BY customer_id 
      ORDER BY amount DESC
      ) as ranking
FROM
    payment_p2007_01 LIMIT 10;
**/


-- ノック43 --
/**
* ウィンドウ関数を使って、payment_p2007_01テーブルと 
* customer_list テーブルから1月の利用回数が多かった顧客をその順位と一緒に表示する
**/

-- ×
/**
* [解説]
* payment_p2007_01テーブルとcustomer_listテーブルをINNER JOINし、customer_idに基づいて結合します。
* 1. 結合されたテーブルを、cl.nameでグループ化します。
* 2. グループ化された各レコードについて、COUNT(*)を使用して支払回数をカウントします。
* 3. RANK()関数を使用して、支払回数の多い順にランキングをつけます。
* 
* 具体的には、ランキングはCOUNT()の降順に割り振られます。例えば、COUNT()が10回の顧客は1位、COUNT()が8回の顧客は2位、COUNT()が5回の顧客は3位というように、ランキングが割り振られます。最終的な結果は、顧客の名前、支払回数、ランキングの順に表示されます。
* このようにして、支払回数の多い顧客をランキング形式で表示することができます。
* 
* 参考: https://qiita.com/HiromuMasuda0228/items/0b20d461f1a80bd30cfc
**/
SELECT 
  cl.name, 
  COUNT(*) AS cnt,
  RANK() OVER(
    ORDER BY COUNT(*) DESC
  ) AS ranking
FROM 
  payment_p2007_01 AS p
  INNER JOIN customer_list AS cl
    ON  p.customer_id = cl.id
GROUP BY 
  cl.name
;

-- ノック44 --
/**
* payment_p2007_01 テーブルとcustomer_list テーブルから、
* 1 月の顧客の利用回数順位を国別に表示する
**/
SELECT 
  cl.country,
  COUNT(*) AS cnt,
  RANK() OVER(ORDER BY COUNT(*) DESC) AS ranking 
from payment_p2007_01 as p 
INNER JOIN customer_list AS cl 
  ON p.customer_id = cl.id
GROUP BY cl.country;

-- ×
/**
* [解説]
* 1. payment_p2007_01テーブルとcustomer_listテーブルをINNER JOINし、顧客ごとの取引履歴と国情報を結合します。
* 2. パーティションカラムであるcl.countryでデータを分割します。
* 3. COUNT(*)を使用して、各国の顧客数をカウントします。
* 4. `RANK() OVER(PARTITION BY cl.country ORDER BY COUNT(*) DESC)で、cl.countryで分割したグループごとに、顧客数が多い順にランキングを割り振ります。
**/
SELECT
  cl.id,
  cl.country,
  COUNT(*) AS cnt,
  RANK() OVER(
      PARTITION BY cl.country
      ORDER BY COUNT(*) DESC
    ) AS rank
FROM 
  payment_p2007_01 as p
  INNER JOIN customer_list AS cl 
    ON p.customer_id = cl.id
GROUP BY
  cl.id, cl.country
;

-- ノック45 --
/**
* ノック44の結果にあわせて、国別の平均利用回数も表示する
* 
**/

-- ×
SELECT 
  cl.id,
  cl.country,
  count(*) as cnt,
  ROUND(AVG(COUNT(*)) OVER (
    PARTITION BY cl.country
  ), 2) AS avg_pay,
  RANK() OVER(
    PARTITION BY cl.country
    ORDER BY COUNT(*) DESC
  ) AS rank
FROM
 payment_p2007_01 AS p
 INNER JOIN customer_list AS cl
  ON p.customer_id = cl.id
GROUP BY
  cl.id, cl.country
;

-- ノック46 --
/**
* ノック45 のクエリを変更し、平均回数の代わりに国ごとの合計利用回数を表示する
* 
**/
SELECT 
  cl.id,
  cl.country,
  count(*) as cnt,
  SUM(count(*)) OVER(PARTITION by cl.country order by COUNT(*) DESC) AS sum_country,
  RANK() OVER(
    PARTITION BY cl.country
    ORDER BY COUNT(*) DESC
  ) AS rank
FROM
 payment_p2007_01 AS p
 INNER JOIN customer_list AS cl
  ON p.customer_id = cl.id
GROUP BY
  cl.id, cl.country
;

-- ×
SELECT  
  cl.id,
  cl.country,
  COUNT(*) AS cnt, 
  SUM(COUNT(*)) OVER (
    PARTITION BY cl.country
  ) AS total_pay,
  RANK() OVER (
    PARTITION BY cl.country 
    ORDER BY COUNT(*) DESC
  ) AS rank
FROM 
  payment_p2007_01 AS p
  INNER JOIN customer_list AS cl
    ON p.customer_id = cl.id
GROUP BY 
  cl.id, cl.country
;
 
-- ノック47 --
/**
* 1 月の国別の利用回数を降順に抽出し、累積回数と併せて表示する
* 
**/


-- ×

/**
* [解説]
* SUM(COUNT(*)) OVER()を使用して、国ごとの顧客数の合計値を算出しています。
* ORDER BY句で顧客数を降順に並べ替え、
* ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROWで累積顧客数を算出
* パーティションの最初の行(UNBOUNDED PRECEDING)から現在の行まで(CURRENT ROW)
**/
SELECT 
  cl.country,
  COUNT(*) AS count,
  SUM(COUNT(*)) OVER (
    ORDER BY COUNT(*) DESC
    ROWS BETWEEN
      UNBOUNDED PRECEDING
      AND CURRENT ROW
  ) AS culculative_count
FROM
  payment_p2007_01 AS p
  INNER JOIN customer_list AS cl
    ON  p.customer_id = cl.id
GROUP BY
  cl.country
ORDER BY
  count DESC
;


-- ノック48 --
/**
* payment_p2007_01 テーブルと customer_listテーブルから
* 1月の国別の利用比率を降順に並べ、累積で表示する
**/

--  ×

SELECT 
  cl.country,
  ROUND(
     SUM(COUNT(*)) OVER (
      ORDER BY COUNT(*) DESC
      ROWS BETWEEN
        UNBOUNDED PRECEDING
        AND CURRENT ROW
     ) / SUM(COUNT(*)) OVER (),
     2
  ) AS cumulatice_percent
FROM 
  payment_p2007_01 AS p 
  INNER JOIN customer_list AS cl
    ON p.customer_id = cl.id
GROUP BY
  cl.country
ORDER BY
  COUNT(*) DESC
;

-- ノック49 --
/**
* payment テーブルを使い、
* 2007年4月6日から12日の日別利用回数を集計する
**/

-- ×

SELECT 
  CAST(payment_date AS DATE) AS d,
  COUNT(*)
FROM payment
WHERE 
  CAST(payment_date AS DATE)
    BETWEEN '2007-04-06' and '2007-04-12'
GROUP by d
ORDER BY d ASC
;


-- ノック50 --
/**
* payment テーブルを使い、
* 2007年4月6日から12日の利用回数の3日移動平均を計算する
**/

WITH date_of_sum_payment as
  (
    SELECT 
      CAST(payment_date AS DATE) AS d,
      COUNT(*) as cnt
    FROM payment
    WHERE 
      CAST(payment_date AS DATE)
        BETWEEN '2007-04-06' and '2007-04-12'
    GROUP by d
    ORDER BY d ASC
  )
SELECT 
  d,
  ROUND(AVG (cnt) over (
    ORDER by d
    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW), 2) as moving_avg
from 
  date_of_sum_payment 
;

-- ×
/**
* 理由
* 4日の移動平均になっていた
**/

SELECT 
  CAST(payment_date as DATE) as d,
  COUNT(*),
  ROUND(AVG(COUNT(*)) OVER (
    ORDER BY
      CAST(payment_date as DATE) ASC
      ROWS BETWEEN 
        2 PRECEDING 
        AND CURRENT ROW
  ), 2) AS moving_avg
FROM 
  payment AS p
WHERE
  CAST(payment_date AS DATE)
    BETWEEN '2007-04-06' and '2007-04-12'
GROUP BY d
ORDER BY d ASC
;

