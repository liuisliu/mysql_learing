-- ==================================================
-- 第7题（窗口 B）
-- 在另一个查询窗口开始事务，将 order_id 等于 1 的订单优惠金额增加 1。
-- 观察该语句是否等待窗口 A 释放锁。完成后不要提交。
-- ==================================================

START TRANSACTION;

UPDATE orders
SET discount_amount = discount_amount + 1
WHERE  order_id = 'O0001';

SELECT 
      order_id, 
			discount_amount
FROM orders 
WHERE order_id = 'O0001'

ROLLBACK;
-- ==================================================
-- 第10题
-- 使用两个窗口重复第 6 到第 9 题，但把窗口 B 的 UPDATE 条件改为 order_id 等于 2。
-- 对比修改不同订单时是否仍会等待。
-- ==================================================
START TRANSACTION;

UPDATE orders
SET discount_amount = discount_amount + 1
WHERE  order_id = 'O0002';

SELECT 
      order_id, 
			discount_amount
FROM orders 
WHERE order_id = 'O0002';

ROLLBACK;