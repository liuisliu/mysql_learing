-- ==================================================
-- 第 1 题
-- 查询 users 表中每个城市的用户数量，显示 city, user_count
-- ==================================================
SELECT city,
      COUNT(*) AS user_count
FROM users
GROUP BY city;


-- ==================================================
-- 第 2 题
-- 查询 users 表中每个会员等级的用户数量，显示 c, user_count
-- ==================================================
SELECT  member_level,
COUNT(*) AS user_count
FROM users
GROUP BY member_level;

-- ==================================================
-- 第 3 题
-- 查询 users 表中每个性别的用户数量，显示 gender, user_count
-- ==================================================
SELECT gender,
COUNT(*) AS user_count
FROM users
GROUP BY gender;

-- ==================================================
-- 第 4 题
-- 查询 products 表中每个商品分类的商品数量，显示 category, product_count
-- ==================================================
SELECT category,
COUNT(*) AS product_count
FROM products
GROUP BY category;

-- ==================================================
-- 第 5 题
-- 查询 products 表中每个商品分类的平均价格，显示 category, avg_price
-- ==================================================
SELECT category,
AVG(price) AS avg_price
FROM products
GROUP BY category;

-- ==================================================
-- 第 6 题
-- 查询 products 表中每个商品分类的最高价格，显示 category, max_price
-- ==================================================
SELECT category,
MAX(price) AS max_price
FROM products
GROUP BY category;

-- ==================================================
-- 第 7 题
-- 查询 products 表中每个商品分类的最低价格，显示 category, min_price
-- ==================================================
SELECT category,
MIN(price)AS min_price
FROM products
GROUP BY category;

-- ==================================================
-- 第 8 题
-- 查询 products 表中每个供应商的商品数量，显示 supplier, product_count
-- ==================================================
SELECT   supplier,
COUNT(*) AS product_count
FROM  products
GROUP BY supplier;

-- ==================================================
-- 第 9 题
-- 查询 orders 表中每种订单状态的订单数量，显示 order_status, order_count
-- ==================================================
SELECT order_status,
COUNT(*) AS order_count
FROM  orders
GROUP BY order_status;

-- ==================================================
-- 第 10 题
-- 查询 orders 表中每种支付方式的订单数量，显示 payment_method, order_count
-- ==================================================
SELECT payment_method,
COUNT(*) AS order_count
FROM orders
GROUP BY payment_method;

-- ==================================================
-- 第 11 题
-- 查询 orders 表中每种支付方式的购买总件数，显示 payment_method, total_quantity
-- ==================================================
SELECT  payment_method,
sum(quantity) AS total_quantity
FROM orders
GROUP BY payment_method;


-- ==================================================
-- 第 12 题
-- 查询 orders 表中每种支付方式的总优惠金额，显示 payment_method, total_discount
-- ==================================================
SELECT payment_method,
sum(discount_amount) AS total_discount
FROM  orders
GROUP BY payment_method;
-- ==================================================
-- 第 13 题
-- 查询 orders 表中每种订单状态的实付总金额，即 quantity * unit_price - discount_amount 的总和，显示 order_status, total_actual_amount
-- ==================================================
SELECT order_status,
sum(quantity * unit_price - discount_amount) AS total_actual_amount
FROM orders
GROUP BY order_status;

-- ==================================================
-- 第 14 题
-- 查询 orders 表中每种支付方式的平均实付金额，即 quantity * unit_price - discount_amount 的平均值，显示 payment_method, avg_actual_amount
-- ==================================================
SELECT payment_method,
avg(quantity * unit_price - discount_amount) AS avg_actual_amount
FROM orders
GROUP BY payment_method;
-- ==================================================
-- 第 15 题
-- 查询 orders 表中订单状态为 Paid 的订单里，每种支付方式的订单数量，显示 payment_method, paid_order_count
-- ==================================================
SELECT payment_method,
COUNT(*) AS paid_order_count
FROM orders 
WHERE order_status = 'Paid'
GROUP BY payment_method;
-- ==================================================
-- 第 16 题
-- 查询 products 表中价格大于 100 的商品里，每个分类的商品数量，显示 category, expensive_product_count
-- ==================================================
SELECT category,
COUNT(*) AS expensive_product_count
FROM products
WHERE price > 100
GROUP BY category;

-- ==================================================
-- 第 17 题
-- 查询 users 表中年龄大于 25 岁的用户里，每个城市的用户数量，显示 city, user_count
-- ==================================================
SELECT city,
COUNT(*) AS user_count
FROM users
WHERE age > 25
GROUP BY city;

-- ==================================================
-- 第 18 题
-- 查询 orders 表中每种订单状态、每种支付方式的订单数量，显示 order_status, payment_method, order_count
-- ==================================================
SELECT  order_status,payment_method,
COUNT(*) AS order_count
FROM orders
GROUP BY order_status, payment_method;
 
-- ==================================================
-- 第 19 题
-- 查询 users 表中每个城市、每个会员等级的用户数量，显示 city, member_level, user_count
-- ==================================================
SELECT city,member_level,
COUNT(*) AS user_count
FROM users 
GROUP BY city,member_level;
-- ==================================================
-- 第 20 题
-- 查询 products 表中每个商品分类的价格概况：商品数量 product_count，平均价格 avg_price，最高价格 max_price，最低价格 min_price
-- ==================================================

SELECT  category,
COUNT(*) AS product_count,
AVG(price) AS avg_price,
MAX(price) AS max_price,
MIN(price)  AS min_price
FROM products
GROUP BY category;