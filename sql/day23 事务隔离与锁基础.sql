-- ==================================================
-- 第1题
-- 查询当前会话的事务隔离级别。
-- 显示字段：transaction_isolation
-- ==================================================
SELECT @@transaction_isolation;
-- ==================================================
-- 第2题
-- 查询当前会话的自动提交设置。
-- 显示字段：autocommit
-- ==================================================
SELECT @@autocommit;

-- ==================================================
-- 第3题
-- 开始一个事务，查询 order_id 等于 1 的订单编号和优惠金额。
-- 最后回滚事务。
-- 显示字段：order_id, discount_amount
-- ==================================================
START TRANSACTION;

SELECT 
      order_id, 
			discount_amount
FROM orders 
WHERE order_id = 'O0001';

ROLLBACK;

-- ==================================================
-- 第4题
-- 开始一个事务，使用 SELECT ... FOR UPDATE 锁定读取 order_id 等于 1 的订单。
-- 查询订单编号和优惠金额，最后回滚事务。
-- 显示字段：order_id, discount_amount
-- ==================================================
START TRANSACTION;

SELECT 
      order_id, 
			discount_amount
FROM orders 
WHERE order_id = 'O0001'
FOR UPDATE;
      
ROLLBACK;
-- ==================================================
-- 第5题
-- 开始一个事务，使用 SELECT ... FOR UPDATE 锁定读取 product_id 等于 1 的商品。
-- 查询商品编号、商品名称和价格，最后回滚事务。
-- 显示字段：product_id, product_name, price
-- ==================================================
START TRANSACTION;

SELECT
      product_id, 
			product_name, 
			price
FROM products
WHERE product_id = 'P001'
FOR UPDATE;

ROLLBACK;

-- ==================================================
-- 第6题（窗口 A）
-- 开始一个事务，使用 SELECT ... FOR UPDATE 锁定读取 order_id 等于 1 的订单。
-- 不要立即提交或回滚，保留事务等待窗口 B 的操作。
-- 显示字段：order_id, discount_amount
-- ==================================================
START TRANSACTION;

SELECT 
      order_id, 
			discount_amount
FROM orders 
WHERE order_id = 'O0001'
FOR UPDATE;

-- ==================================================
-- 第7题（窗口 B）
-- 在另一个查询窗口开始事务，将 order_id 等于 1 的订单优惠金额增加 1。
-- 观察该语句是否等待窗口 A 释放锁。完成后不要提交。
-- ==================================================


-- ==================================================
-- 第8题（窗口 A）
-- 回滚窗口 A 的事务，释放 order_id 等于 1 的锁。
-- ==================================================
ROLLBACK;

-- ==================================================
-- 第9题（窗口 B）
-- 在窗口 B 的 UPDATE 执行结束后，查询 order_id 等于 1 的订单编号和优惠金额。
-- 再回滚窗口 B 的事务，恢复练习数据。
-- 显示字段：order_id, discount_amount
-- ==================================================


-- ==================================================
-- 第10题
-- 使用两个窗口重复第 6 到第 9 题，但把窗口 B 的 UPDATE 条件改为 order_id 等于 2。
-- 对比修改不同订单时是否仍会等待。
-- ==================================================
START TRANSACTION;

SELECT 
      order_id, 
			discount_amount
FROM orders 
WHERE order_id = 'O0002'
FOR UPDATE;

ROLLBACK;

-- ==================================================
-- 第11题
-- 使用 EXPLAIN 分析：按 order_id 等于 1 查询 orders 表。
-- 说明为什么按主键定位更适合用于精确修改。
-- 观察字段：key, rows
-- ==================================================
EXPLAIN

SELECT 
     *
FROM orders
WHERE order_id = 'O0001';
-- ==================================================
-- 第12题
-- 写出一段安全事务 SQL：先锁定读取 order_id 等于 1 的订单，再将优惠金额增加 1，查询修改结果后回滚。
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
