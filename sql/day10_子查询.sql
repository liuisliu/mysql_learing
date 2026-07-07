-- ==================================================
-- 第 1 题
-- 查询价格高于商品平均价格的商品，显示 product_id, product_name, price
-- ==================================================
SELECT product_id,product_name, price
FROM  products
WHERE price >
 (SELECT AVG(price)
FROM products);
 

-- ==================================================
-- 第 2 题
-- 查询价格低于商品平均价格的商品，显示 product_id, product_name, price
-- ==================================================
SELECT product_id, product_name, price
FROM products
WHERE price < (SELECT AVG(price)
FROM products);

-- ==================================================
-- 第 3 题
-- 查询下过订单的用户，显示 user_id, user_name, city
-- ==================================================
SELECT user_id, user_name, city
FROM users
WHERE user_id IN (SELECT DISTINCT user_id 
FROM orders);

-- ==================================================
-- 第 4 题
-- 查询没有下过订单的用户，显示 user_id, user_name
-- ==================================================
SELECT user_id, user_name
FROM users
WHERE user_id  NOT IN (SELECT DISTINCT user_id 
FROM orders);

-- ==================================================
-- 第 5 题
-- 查询被购买过的商品，显示 product_id, product_name, category
-- ==================================================
SELECT  product_id, product_name, category
FROM products
WHERE product_id IN (SELECT DISTINCT product_id
FROM orders);

-- ==================================================
-- 第 6 题
-- 查询没有被购买过的商品，显示 product_id, product_name
-- ==================================================
 SELECT  product_id, product_name
FROM products
WHERE product_id NOT IN (SELECT DISTINCT product_id
FROM orders);


-- ==================================================
-- 第 7 题
-- 查询订单金额高于所有订单平均实付金额的订单，显示 order_id, user_id, actual_amount
-- ==================================================
SELECT order_id, user_id, actual_amount
FROM ( SELECT  order_id, user_id, 
avg(quantity * unit_price - discount_amount) AS actual_amount
FROM orders
) AS summy
WHERE  price > actual_amount;



SELECT order_id,
 user_id, 
quantity * unit_price - discount_amount AS actual_amount
FROM orders
WHERE  quantity * unit_price - discount_amount > (
SELECT  AVG(quantity * unit_price - discount_amount) 
FROM orders
);
 
-- ==================================================
-- 第 8 题
-- 查询购买过 Electronics 分类商品的用户，显示 user_id, user_name
-- ==================================================
SELECT user_id, user_name
FROM users 
WHERE user_id IN 
( SELECT user_id 
from orders
WHERE product_id IN 
(SELECT product_id
FROM products
WHERE category = 'Electronics'));



-- ==================================================
-- 第 9 题
-- 先统计每个用户的订单数量，再查询订单数量大于 1 的用户，显示 user_id, order_count
-- ==================================================
SELECT user_id, order_count
FROM (SELECT user_id,
      COUNT(*)  AS order_count
       FROM orders 
       GROUP BY user_id)
			 AS summy
WHERE order_count > 1;


-- ==================================================
-- 第 10 题
-- 先统计每个商品分类的订单数量，再查询订单数量大于 2 的分类，显示 category, order_count
-- ==========category, order_count========================================
SELECT category, 
			 order_count
FROM
 (
 SELECT p.category,
count(*) AS order_count
FROM orders AS o
INNER JOIN products AS p
ON o.product_id = p.product_id
GROUP BY p.category 
)
AS order_count_summary
WHERE order_count > 2;

SELECT category,
       order_count
FROM (
    SELECT p.category,
           COUNT(*) AS order_count
    FROM orders AS o
    INNER JOIN products AS p
    ON o.product_id = p.product_id
    GROUP BY p.category
) AS category_order_summary
WHERE order_count > 2;
 