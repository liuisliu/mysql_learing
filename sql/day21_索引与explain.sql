-- ==================================================
-- 第1题
-- 查看 orders 表当前已有的索引。
-- ==================================================
SHOW INDEX FROM  orders;

-- ==================================================
-- 第2题
-- 使用 EXPLAIN 分析：查询 user_id 等于 1 的所有订单。
-- 观察字段：table, type, possible_keys, key, rows, Extra
-- ==================================================
EXPLAIN
SELECT
		*
FROM orders 
where  user_id = 001;

-- ==================================================
-- 第3题
-- 为 orders 表的 user_id 字段创建普通索引。
-- 索引名：idx_orders_user_id_practice
-- ==================================================
CREATE INDEX idx_orders_user_id_practice
ON orders(user_id);

-- ==================================================
-- 第4题
-- 再次使用 EXPLAIN 分析：查询 user_id 等于 1 的所有订单。
-- 对比创建索引前后 key 和 rows 的变化。
-- 观察字段：table, type, possible_keys, key, rows, Extra
-- ==================================================
EXPLAIN
SELECT
		*
FROM orders 
where  user_id = 001;

-- ==================================================
-- 第5题
-- 删除练习索引 idx_orders_user_id_practice。
-- ==================================================
DROP INDEX idx_orders_user_id_practice
ON orders;

-- ==================================================
-- 第6题
-- 使用 EXPLAIN 分析：查询 2026-01-01 到 2026-01-31 之间的订单。
-- 观察字段：table, type, possible_keys, key, rows, Extra
-- ==================================================
EXPLAIN
SELECT
      *
FROM orders
WHERE order_date > '2026-01-01'
AND order_date < '2026-01-31';

-- ==================================================
-- 第7题
-- 为 orders 表创建 user_id 和 order_date 的联合普通索引。
-- 索引名：idx_orders_user_date_practice
-- 字段顺序：user_id, order_date
-- ==================================================
CREATE INDEX idx_orders_user_date_practice
ON orders (user_id, order_date);

-- ==================================================
-- 第8题
-- 使用 EXPLAIN 分析：查询 user_id 等于 1，且订单日期在 2026-01-01 到 2026-01-31 之间的订单。
-- 观察字段：table, type, possible_keys, key, rows, Extra
-- ==================================================
EXPLAIN
SELECT 
      *
FROM orders
WHERE user_id = 1 
AND order_date > '2026-01-01'
AND order_date < '2026-01-31';

-- ==================================================
-- 第9题
-- 使用 EXPLAIN 分析：只按订单日期在 2026-01-01 到 2026-01-31 之间查询订单。
-- 对比它与第 8 题对联合索引的使用情况。
-- 观察字段：table, type, possible_keys, key, rows, Extra
-- ==================================================
EXPLAIN
SELECT 
      *
FROM orders
WHERE order_date > '2026-01-01'
AND order_date < '2026-01-31';

-- ==================================================
-- 第10题
-- 删除练习联合索引 idx_orders_user_date_practice。
-- ==================================================
DROP INDEX idx_orders_user_date_practice
ON orders;
SHOW INDEX FROM orders;
-- ==================================================
-- 第11题
-- 使用 EXPLAIN 分析：关联 users 表和 orders 表，查询 user_id 等于 1 的订单及用户姓名。
-- 观察字段：table, type, possible_keys, key, rows, Extra
-- ==================================================
EXPLAIN
SELECT
      u.user_name
FROM users AS u
INNER JOIN orders AS o
ON u.user_id = o.user_id
WHERE o.user_id = 1;

-- ==================================================
-- 第12题
-- 查看 products 表当前已有的索引。
-- 再使用 EXPLAIN 分析：查询 category 等于“电子产品”的商品。
-- 观察字段：table, type, possible_keys, key, rows, Extra
-- ==================================================
SHOW INDEX FROM products;



EXPLAIN 
SELECT 
      *
FROM products
WHERE category = 'Electronics';