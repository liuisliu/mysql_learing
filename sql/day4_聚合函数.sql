-- ==================================================
-- 第 1 题
-- 查询 users 表中的用户总数，结果列别名为 user_count
-- ==================================================
SELECT COUNT(*) as user_count
FROM users;

-- ==================================================
-- 第 2 题
-- 查询 products 表中的商品总数，结果列别名为 product_count
-- ==================================================
SELECT count(*) as product_count
FROM products;

-- ==================================================
-- 第 3 题
-- 查询 orders 表中的订单总数，结果列别名为 
-- ==================================================
SELECT count(*)  as orders_count
from  orders;

-- ==================================================
-- 第 4 题
-- 查询 users 表中不重复城市数量，结果列别名为 city_count
-- ==================================================
SELECT COUNT(DISTINCT city) as city_count
FROM users;
-- ==================================================
-- 第 5 题
-- 查询 orders 表中不重复下单用户数量，结果列别名为 buyer_count
-- ==================================================
SELECT count(DISTINCT user_id) as buyer_count
FROM orders;

-- ==================================================
-- 第 6 题
-- 查询 orders 表中商品购买总件数，结果列别名为 
-- ==================================================
SELECT sum(quantity) as total_quantity
FROM  orders;

-- ==================================================
-- 第 7 题
-- 查询 orders 表中的总优惠金额，结果列别名为 total_discount
-- ==================================================
SELECT sum(discount_amount) as total_discount
FROM  orders;

-- ==================================================
-- 第 8 题
-- 查询 products 表中的平均商品价格，结果列别名为 avg_price
-- ==================================================
select  AVG(price) as avg_price 
FROM products;

-- ==================================================
-- 第 9 题
-- 查询 products 表中的最高商品价格，结果列别名为 max_price
-- ==================================================
SELECT MAX(price) as max_price
FROM  products;
;
-- ==================================================
-- 第 10 题
-- 查询 products 表中的最低商品价格，结果列别名为 min_price
-- ==================================================
SELECT MIN(price) as min_price
FROM products;

-- ==================================================
-- 第 11 题
-- 查询 orders 表中订单状态为 Paid 的订单数量，结果列别名为 paid_order_count
-- ========================= =========================
SELECT COUNT(*) as paid_order_count
FROM orders
WHERE order_status = 'Paid';

-- ==================================================
-- 第 12 题
-- 查询 users 表中城市为 Shanghai 的用户数量，结果列别名为 shanghai_user_count
-- ==================================================
SELECT COUNT(*) as shanghai_user_count
FROM users 
WHERE city = 'shanghai';
-- ==================================================
-- 第 13 题
-- 查询 products 表中价格大于 100 的商品数量，结果列别名为 expensive_product_count
-- ==================================================
SELECT COUNT(*) as expensive_product_count
FROM products
WHERE price > 100;

-- ==================================================
-- 第 14 题
-- 查询 orders 表中的原始总金额，即 quantity * unit_price 的总和，结果列别名为 total_gross_amount
-- ==================================================
SELECT SUM(quantity * unit_price) as  total_gross_amount
FROM orders;


-- ==================================================
-- 第 15 题
-- 查询 orders 表中的实付总金额，即 quantity * unit_price - discount_amount 的总和，结果列别名为 total_actual_amount
-- ==================================================
SELECT SUM(quantity * unit_price - discount_amount) as total_actual_amount
from orders;

-- ==================================================
-- 第 16 题
-- 查询 orders 表中的平均实付金额，即 quantity * unit_price - discount_amount 的平均值，结果列别名为 avg_actual_amount
-- ==================================================

SELECT avg(quantity * unit_price - discount_amount) as avg_actual_amount
from orders;
-- ==================================================
-- 第 17 题
-- 查询 orders 表中订单状态为 Paid 的实付总金额，结果列别名为 paid_actual_amount
-- ==================================================
SELECT SUM(quantity * unit_price - discount_amount) as paid_actual_amount
from orders
WHERE order_status = 'paid';

-- ==================================================
-- 第 18 题
-- 查询 products 表的价格概况：商品总数 product_count，平均价格 avg_price，最高价格 max_price，最低价格 min_price
-- ==================================================
SELECT COUNT(*) as product_count,
				AVG(price) as  avg_price,
				MAX(price) as   max_price,
				MIN(price) as  min_price
FROM products;

-- ==================================================
-- 第 19 题
-- 查询 orders 表的订单概况：订单总数 order_count，购买总件数 total_quantity，总优惠金额 total_discount，实付总金额 total_actual_amount
-- ==================================================
SELECT COUNT(*) as order_count,
								SUM(quantity),
								sUM(discount_amount),
								sum(quantity * unit_price - discount_amount)
FROM orders;

-- ==================================================
-- 第 20 题
-- 查询 orders 表中最大实付金额，即 quantity * unit_price - discount_amount 的最大值，结果列别名为 max_actual_amount
-- ==================================================
SELECT MAX(quantity * unit_price - discount_amount) as max_actual_amount
FROM orders;