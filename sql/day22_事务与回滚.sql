-- ==================================================
-- 第1题
-- 查询当前会话的自动提交设置。
-- 显示字段：autocommit
-- ==================================================
SELECT @@autocommit;

-- ==================================================
-- 第2题
-- 开始一个事务，查询 order_id 等于 1 的订单编号和优惠金额。
-- 显示字段：order_id, discount_amount
-- ==================================================
START TRANSACTION;

SELECT
		 order_id,
		 discount_amount
FROM orders
WHERE order_id = 'O0001';



-- ==================================================
-- 第3题
-- 在同一事务中，将 order_id 等于 1 的订单优惠金额增加 1。
-- 再查询该订单编号和优惠金额确认修改结果。
-- 显示字段：order_id, discount_amount
-- ==================================================



UPDATE  orders
SET discount_amount = discount_amount + 1
WHERE  order_id = 'O0001'; 

SELECT
		 order_id,
		 discount_amount
FROM orders
WHERE order_id = 'O0001';

-- ==================================================
-- 第4题
-- 回滚当前事务。
-- 回滚后再次查询 order_id 等于 1 的订单编号和优惠金额，确认优惠金额已恢复。
-- 显示字段：order_id, discount_amount
-- ==================================================
ROLLBACK;


SELECT
		 order_id,
		 discount_amount
FROM orders
WHERE order_id = 'O0001';



-- ==================================================
-- 第5题
-- 开始一个事务，将 order_id 等于 1 的订单优惠金额增加 1。
-- 设置保存点 after_order_1。
-- 再将 order_id 等于 2 的订单优惠金额增加 1。
-- ==================================================
START TRANSACTION;

UPDATE orders
SET discount_amount = discount_amount + 1
WHERE order_id = 'O0001';

SAVEPOINT after_order_1;

UPDATE orders
SET discount_amount = discount_amount + 1
WHERE order_id = 'O0002';



-- ==================================================
-- 第6题
-- 在第 5 题的同一事务中，回滚到保存点 after_order_1。
-- 查询 order_id 等于 1 和 2 的订单编号、优惠金额，观察保存点回滚后的结果。
-- 显示字段：order_id, discount_amount



ROLLBACK TO SAVEPOINT after_order_1;

SELECT
		 order_id,
		 discount_amount
FROM orders
WHERE order_id = 'O0001';

SELECT
		 order_id,
		 discount_amount
FROM orders
WHERE order_id = 'O0002';


-- ==================================================
-- 第7题
-- 回滚第 5、6 题开启的整个事务。
-- 查询 order_id 等于 1 和 2 的订单编号、优惠金额，确认两条订单均恢复到修改前。
-- 显示字段：order_id, discount_amount
-- ==================================================

ROLLBACK;

SELECT
		 order_id,
		 discount_amount
FROM orders
WHERE order_id = 'O0001';

SELECT
		 order_id,
		 discount_amount
FROM orders
WHERE order_id = 'O0002';

-- ==================================================
-- 第8题
-- 开始一个事务，将 products 表中 product_id 等于 1 的价格增加 1。
-- 查询该商品编号、商品名称和价格确认修改结果。
-- 显示字段：product_id, product_name, price
-- ==================================================
START  TRANSACTION;

UPDATE products
SET price = price + 1
WHERE product_id = 'P001'

SELECT
      product_id, 
			product_name,
			price
FROM products
WHERE product_id = 'P001'

-- ==================================================
-- 第9题
-- 回滚第 8 题开启的事务。
-- 查询 product_id 等于 1 的商品编号、商品名称和价格，确认价格已恢复。
-- 显示字段：product_id, product_name, price
-- ==================================================


ROLLBACK;

SELECT
      product_id, 
			product_name,
			price
FROM products
WHERE product_id = 'P001';

-- ==================================================
-- 第10题
-- 查询 orders 表中 order_id 等于 1 的订单编号、用户编号、订单日期和优惠金额。
-- 将这条 SELECT 改写为安全的事务练习：优惠金额增加 1，查看后回滚。
-- 显示字段：order_id, user_id, order_date, discount_amount
-- ==================================================
START TRANSACTION;

UPDATE orders
SET discount_amount = discount_amount + 1
WHERE order_id = 'O0001';

SELECT
      order_id, 
			user_id, 
			order_date, 
			discount_amount
FROM orders
WHERE order_id = 'O0001';

ROLLBACK;
-- ==================================================
-- 第11题
-- 写出一段事务 SQL：先查询 user_id 等于 1 的订单数量，再将该用户所有订单的优惠金额增加 1，查看后回滚。
-- 显示字段：order_id, user_id, discount_amount
-- ==================================================
START TRANSACTION;

SELECT 
      user_id,
			count(*) AS amont
FROM orders
WHERE user_id = 'U001'
GROUP BY user_id;

UPDATE orders
SET discount_amount = discount_amount + 1
WHERE user_id = 'U001';

SELECT 
      order_id, 
			user_id, 
			discount_amount
FROM orders
WHERE user_id = 'U001';

ROLLBACK;

			
			

-- ==================================================
-- 第12题
-- 写出一段安全事务 SQL：先查询 product_id 等于 1 的商品价格，再将价格增加 1，查看后回滚。
-- 使用 SAVEPOINT 设置一个保存点，并在最终回滚整个事务。
-- 显示字段：product_id, product_name, price
-- ==================================================
START TRANSACTION;

SELECT 
      product_id, 
      product_name,
      price
FROM products
WHERE product_id = 'P001';


UPDATE products
SET price = price + 1
WHERE product_id = 'P001';

SAVEPOINT  S_price;

SELECT 
      product_id, 
      product_name,
      price
FROM products
WHERE product_id = 'P001';

ROLLBACK;