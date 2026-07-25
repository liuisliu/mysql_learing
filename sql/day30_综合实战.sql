-- ==================================================
-- 第1题
-- 查询每笔订单的订单编号、用户编号、用户姓名、商品编号、商品名称、订单日期、支付方式和实付金额。
-- 显示字段：order_id, user_id, user_name, product_id, product_name, order_date, payment_method, actual_amount
-- ==================================================
SELECT 
      o.order_id, 
			u.user_id, 
			u.user_name,
			p.product_id, 
			p.product_name, 
			o.order_date, 
			o.payment_method, 
			o.unit_price * o.quantity - o.discount_amount AS actual_amount
FROM orders AS o
INNER JOIN users AS u
ON o.user_id = u.user_id
INNER JOIN products AS p
ON o.product_id = p.product_id;

-- ==================================================
-- 第2题
-- 使用 CTE 统计每个用户的总实付金额，并按总实付金额从高到低排名。
-- 显示字段：user_id, total_amount, total_amount_rank
-- ==================================================
WITH cte_amount AS(
SELECT 
     user_id,
		 sum(unit_price * quantity - discount_amount) AS  total_amount
FROM orders
GROUP BY 	user_id
)
SELECT 
     user_id,
		 total_amount,
		 ROW_NUMBER() over(
		 ORDER BY total_amount  DESC
		 ) AS total_amount_rank 
FROM cte_amount;



     

-- ==================================================
-- 第3题
-- 使用 CTE 统计每天的总实付金额，并计算累计销售额。
-- 显示字段：order_date, daily_amount, running_amount
-- ==================================================
WITH cte_daily_amount AS(
SELECT
      order_date,
			sum(unit_price * quantity - discount_amount) AS  daily_amount
FROM orders
GROUP BY order_date
)
SELECT
      order_date, 
			daily_amount,
			sum(daily_amount) over(
			ORDER BY order_date
			) AS running_amount
FROM cte_daily_amount;
-- ==================================================
-- 第4题
-- 创建或替换视图 v_order_business_detail，保存订单、用户、商品和实付金额明细。
-- 显示字段：order_id, user_id, user_name, city, product_id, product_name, category, order_date, payment_method, quantity, unit_price, discount_amount, actual_amount
-- ==================================================
CREATE OR REPLACE VIEW   v_order_business_detail AS
SELECT
      o.order_id, 
			u.user_id, 
			u.user_name, 
			u.city, 
			p.product_id, 
			p.product_name, 
			p.category, 
			o.order_date, 
			o.payment_method, 
			o.quantity, 
			o.unit_price, 
			o.discount_amount, 
			o.unit_price * o.quantity - o.discount_amount AS actual_amount
FROM orders AS o
INNER JOIN users AS u
ON o.user_id = u.user_id
INNER JOIN products AS p
ON o.product_id = p.product_id;


-- ==================================================
-- 第5题
-- 查询视图 v_order_business_detail，筛选城市为 Beijing 的订单，并按实付金额从高到低排序。
-- 显示字段：order_id, user_name, city, product_name, actual_amount
-- ==================================================
SELECT 
     order_id, 
		 user_name, 
		 city, 
		 product_name, 
		 actual_amount
FROM v_order_business_detail
WHERE city = 'Beijing'
ORDER BY actual_amount DESC;

-- ==================================================
-- 第6题
-- 使用 EXPLAIN 分析按订单编号 O0001 查询 orders 表的执行计划。
-- 观察字段：possible_keys, key, rows
-- ==================================================
EXPLAIN 
SELECT 
      *
FROM orders
WHERE order_id = 'O0001';

-- ==================================================
-- 第7题
-- 删除存储过程 。p_day30_set_order_discount即使该过程不存在，也不能报错。
-- 再创建该过程，接收订单编号和新优惠金额两个输入参数。
-- 当新优惠金额小于 0 时，过程必须主动报错且不能更新订单。
-- 当新优惠金额不小于 0 时，更新对应订单的优惠金额。
-- ==================================================
DROP PROCEDURE IF EXISTS  p_day30_set_order_discount;
DELIMITER $$
CREATE PROCEDURE  p_day30_set_order_discount
( IN p_order_id VARCHAR(255),
  IN p_new_discount_amount DECIMAL(10,2)
)
BEGIN
IF  p_new_discount_amount < 0 THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'discount_amount cant be negitive';
END IF;

UPDATE orders
SET discount_amount = p_new_discount_amount
WHERE order_id = p_order_id;

END $$
DELIMITER ;


-- ==================================================
-- 第8题
-- 开始事务，锁定读取订单编号 O0001。
-- 调用存储过程 p_day30_set_order_discount，将该订单优惠金额设置为 10。
-- 查询订单编号和优惠金额后回滚事务。
-- 显示字段：order_id, discount_amount
-- ==================================================
START TRANSACTION;

SELECT 
      order_id,
			discount_amount
FROM orders
WHERE order_id = 'O0001'
FOR UPDATE;

CALL p_day30_set_order_discount('O0001',10);

SELECT 
      order_id,
			discount_amount
FROM orders
WHERE order_id = 'O0001';

ROLLBACK;


-- ==================================================
-- 第9题
-- 删除表 order_discount_audit_day30。即使该表不存在，也不能报错。
-- 再创建该表，用于记录订单优惠金额变更。
-- 显示字段：audit_id, order_id, old_discount_amount, new_discount_amount, changed_at
-- ==================================================
DROP TABLE IF EXISTS order_discount_audit_day30;

CREATE TABLE order_discount_audit_day30
(audit_id BIGINT  NOT NULL auto_increment  PRIMARY KEY , 
order_id VARCHAR(255) NOT NULL,
old_discount_amount DECIMAL(10,2), 
new_discount_amount DECIMAL(10,2), 
changed_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ==================================================
-- 第10题
-- 删除触发器 trg_orders_discount_audit_day30。即使该触发器不存在，也不能报错。
-- 再创建该触发器，当 orders 表的 discount_amount 被更新且前后数值不同时，自动向 order_discount_audit_day30 写入一条记录。
-- ==================================================
DROP TRIGGER IF EXISTS trg_orders_discount_audit_day30;

DELIMITER $$
CREATE TRIGGER trg_orders_discount_audit_day30 
AFTER UPDATE ON orders
FOR each ROW
BEGIN
   IF NEW.discount_amount <> OLD.discount_amount THEN 
      INSERT INTO order_discount_audit_day30
			(order_id,
		   old_discount_amount,
		   new_discount_amount
			 )
			 VALUES
			 (NEW.order_id,
			 OLD.discount_amount,
			 NEW.discount_amount
			 );
   END IF;
END $$
DELIMITER ;



-- ==================================================
-- 第11题
-- 开始事务，将订单编号 O0001 的优惠金额增加 1。
-- 查询该订单最新的审计记录后回滚事务。
-- 显示字段：order_id, discount_amount
-- 审计显示字段：audit_id, order_id, old_discount_amount, new_discount_amount, changed_at
-- ==================================================
START TRANSACTION;

UPDATE orders
SET discount_amount = discount_amount + 1
WHERE order_id = 'O0001';

SELECT 
     order_id, 
		 discount_amount
FROM orders
WHERE order_id = 'O0001';

SELECT 
      audit_id, 
			order_id, 
			old_discount_amount, 
			new_discount_amount, 
			changed_at	
FROM order_discount_audit_day30
ORDER BY audit_id DESC 
LIMIT 1;

ROLLBACK;


-- ==================================================
-- 第12题
-- 删除视图 v_order_business_detail。
-- 删除存储过程 p_day30_set_order_discount。
-- 删除触发器 trg_orders_discount_audit_day30。
-- 删除表 order_discount_audit_day30。
-- 删除时即使对象不存在，也不能报错。
-- ==================================================
DROP VIEW IF EXISTS v_order_business_detail;
DROP PROCEDURE IF EXISTS p_day30_set_order_discount;
DROP  TRIGGER  IF EXISTS trg_orders_discount_audit_day30;
DROP TABLE  IF EXISTS order_discount_audit_day30;

