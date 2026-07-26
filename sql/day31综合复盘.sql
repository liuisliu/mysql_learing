-- 第1题
-- 查询当前数据库名称，并查询 orders 表中订单编号 O0001 的全部字段。
-- 用于确认当前数据库、订单编号格式和目标订单是否存在。
-- =================================================
SELECT DATABASES() AS current_datebase;

SELECT 
      *
FROM orders
WHERE order_id = 'O0001';
-- ==================================================
-- 第2题
-- 查询每个用户的订单数量和总实付金额。
-- 没有订单的用户也要显示，订单数量和总实付金额显示为 0。
-- 显示字段：user_id, user_name, order_count, total_amount
-- ==================================================
WITH cte_order_count AS
(
SELECT
		  user_id,  
			count(*) AS order_count, 
			SUM(unit_price * quantity - discount_amount) AS total_amount
FROM orders
GROUP BY user_id
)
SELECT 
     u.user_id,
		 u.user_name,
     COALESCE(coc.order_count,0) AS order_count,
		 COALESCE(coc.total_amount,0) AS total_amount
FROM users AS u
LEFT JOIN cte_order_count AS coc
ON u.user_id = coc.user_id;
-- ==================================================
-- 第3题
-- 使用 CTE 统计每个用户的总实付金额。
-- 在所有用户之间按总实付金额从高到低生成连续排名。
-- 显示字段：user_id, total_amount, total_amount_rank
-- ==================================================
WITH cte_total_amount AS(
SELECT 
      user_id,
			sum(unit_price * quantity - discount_amount) AS  total_amount
FROM orders
GROUP BY  user_id
),cte_all_users AS
( SELECT
        u.user_id,
				COALESCE(cta.total_amount,0) AS total_amount
	FROM users AS u
	LEFT JOIN cte_total_amount AS cta
	ON u.user_id = cta.user_id
	)
SELECT 
     user_id, 
		 total_amount,
		 ROW_NUMBER() over(
		 ORDER BY total_amount DESC
		 ) AS total_amount_rank
FROM cte_all_users
ORDER BY total_amount DESC;
 

-- ==================================================
-- 第4题
-- 统计每个订单日期的订单数量和总实付金额。
-- 只显示订单数量不少于 2 的日期，并按总实付金额从高到低排序。
-- 显示字段：order_date, order_count, daily_amount
-- ==================================================
SELECT 
      order_date,
			count(*) AS order_count,
			sum(unit_price * quantity - discount_amount) AS daily_amount
FROM orders
GROUP BY order_date
HAVING order_count >= 2
ORDER BY daily_amount DESC;

-- ==================================================
-- 第5题
-- 使用 CTE 统计每天的总实付金额。
-- 再计算按订单日期从早到晚的累计销售额。
-- 显示字段：order_date, daily_amount, running_amount
-- ==================================================
WITH cte_daily_amount AS(
SELECT 
      order_date,
			sum(unit_price * quantity - discount_amount) AS daily_amount
FROM orders 
GROUP BY order_date
)
SELECT
      order_date,
			daily_amount,
			sum(daily_amount) over(
			   ORDER BY  order_date
				 ) AS running_amount
FROM cte_daily_amount
ORDER BY order_date ASC;

-- ==================================================
-- 第6题
-- 创建或替换视图 v_day31_user_totals，保存每个用户的订单数量和总实付金额。
-- 显示字段：user_id, order_count, total_amount
-- ==================================================
CREATE OR REPLACE VIEW v_day31_user_totals AS
SELECT 
      user_id, 
			count(*) AS order_count, 
			sum(unit_price * quantity - discount_amount) AS  total_amount
FROM orders
GROUP BY user_id;

-- ==================================================
-- 第7题
-- 查询视图 v_day31_user_totals，关联 users 表显示用户姓名、城市、订单数量和总实付金额。
-- 只显示总实付金额大于 0 的用户，并按总实付金额从高到低排序。
-- 显示字段：user_id, user_name, city, order_count, total_amount
-- ==================================================
SELECT
      vd.user_id, 
			u.user_name, 
			u.city, 
			vd.order_count, 
			vd.total_amount
FROM v_day31_user_totals AS vd
INNER JOIN users AS u
ON vd.user_id = u.user_id
WHERE total_amount > 0
ORDER BY total_amount DESC;

-- ==================================================
-- 第8题
-- 使用 EXPLAIN 分析按订单编号 O0001 查询 orders 表的执行计划。
-- 观察字段：possible_keys, key, rows
-- ==================================================

EXPLAIN 
SELECT
      *
FROM orders
WHERE order_id = 'O0001';
-- ==================================================
-- 第9题
-- 删除表 orders_backup_day31。即使该表不存在，也不能报错。
-- 再创建 orders_backup_day31，使其拥有与 orders 表相同的表结构和索引。
-- 将 orders 表当前全部数据复制到 orders_backup_day31。
-- ==================================================
DROP TABLE IF EXISTS orders_backup_day31;

CREATE TABLE orders_backup_day31 LIKE orders;

INSERT INTO  orders_backup_day31
SELECT
		 *
FROM orders;

-- ==================================================
-- 第10题
-- 使用一条查询分别统计 orders 和 orders_backup_day31 的订单数量。
-- 显示字段：source_order_count, backup_order_count
-- ==================================================
SELECT
( SELECT 
      count(*)
	FROM orders
)	 AS source_order_count,
 (SELECT 
        count(*) 
	FROM  orders_backup_day31
	) AS  backup_order_count;

-- ==================================================
-- 第11题
-- 开始事务，锁定读取订单编号 O0001。
-- 将该订单的优惠金额增加 1，查询修改结果后回滚事务。
-- 显示字段：order_id, discount_amount
-- ==================================================
START TRANSACTION;

SELECT 
      order_id, 
			discount_amount
FROM orders
WHERE order_id = 'O0001'
FOR UPDATE;

UPDATE orders
SET discount_amount = discount_amount + 1
WHERE order_id = 'O0001';

SELECT 
      order_id, 
			discount_amount
FROM orders
WHERE order_id = 'O0001';


ROLLBACK;

-- ==================================================
-- 第12题
-- 使用 SQL 注释说明以下四个对象的作用范围：CTE、临时表、视图和事务。
-- 删除视图 v_day31_user_totals 和备份表 orders_backup_day31。
-- 删除时即使对象不存在，也不能报错。
-- ==================================================

-- cte作用范围只在当前的整个sql查询中
-- 临时表是在整个数据库的连接中，断开连接之后自动删除
-- 视图保存的是定义，可以一直存在，除非手动删除
-- 事务作用于当前数据库连接。
-- 从 START TRANSACTION 开始，到 COMMIT 或 ROLLBACK 结束。
-- 同一个连接在事务未结束前，后续可回滚的 DML 语句通常属于该事务。
-- CREATE、DROP、ALTER 等 DDL 语句会导致隐式提交，因此不能放进希望回滚的数据修改流程中。
drop VIEW IF EXISTS v_day31_user_totals;

drop TABLE IF EXISTS orders_backup_day31;
