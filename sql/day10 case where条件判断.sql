-- ==================================================
-- 第 1 题
-- 查询 products 表，给商品价格打标签：price >= 300 为 High，price >= 100 为 Medium，其余为 Low，显示 product_id, product_name, price, price_level
-- ==================================================
SELECT  product_id, 
				product_name, 
				price,
				
CASE 
	WHEN price >= 300 THEN 'High'
	WHEN price >= 100 THEN 'Medium'	
	ELSE  'low'
END AS price_level
FROM products;


-- ==================================================
-- 第 2 题
-- 查询 users 表，给用户年龄分组：age < 25 为 Young，age <= 35 为 Adult，其余为 Senior，显示 user_id, user_name, age, age_group
-- ==================================================
SELECT user_id,
			 user_name,
			 age,
	CASE 
		WHEN age < 25 THEN 'Young'
		WHEN age <= 35 THEN 'Adult'
		ELSE   'Senior'
  END  AS  age_group
FROM  users;


-- ==================================================
-- 第 3 题
-- 查询 orders 表，把订单状态转成中文：Paid 为 已支付，Pending 为 待支付，Cancelled 为 已取消，其余为 其他，显示 order_id, order_status, status_cn
-- ==================================================
SELECT order_id, 
       order_status,
			 CASE 
				WHEN order_status = 'Paid' THEN '已支付'
				WHEN order_status = 'Pending' THEN '待支付'
				WHEN order_status = 'Cancelled' THEN '已取消'
				ELSE '其他' 	
			END AS status_cn
FROM orders;


-- ==================================================
-- 第 4 题
-- 统计 High、Medium、Low 三类商品数量，显示 price_level, product_count
-- ==================================================
SELECT  
COUNT(*) AS product_count,
CASE 
	WHEN price >= 300 THEN 'High'
	WHEN price >= 100 THEN 'Medium'	
	ELSE  'low'
END AS price_level 
FROM products
GROUP BY 
CASE 
	WHEN price >= 300 THEN 'High'
	WHEN price >= 100 THEN 'Medium'	
	ELSE  'low'
END ;


-- ==================================================
-- 第 5 题
-- 统计每种订单状态的中文标签数量，显示 status_cn, order_count
-- ==================================================
SELECT COUNT(*) AS order_count,
			 CASE 
				WHEN order_status = 'Paid' THEN '已支付'
				WHEN order_status = 'Pending' THEN '待支付'
				WHEN order_status = 'Cancelled' THEN '已取消'
				ELSE '其他' 	
			END AS status_cn
FROM orders
GROUP BY CASE 
				WHEN order_status = 'Paid' THEN '已支付'
				WHEN order_status = 'Pending' THEN '待支付'
				WHEN order_status = 'Cancelled' THEN '已取消'
				ELSE '其他' 	
			END;

-- ==================================================
-- 第 6 题
-- 统计 orders 表中 Paid、Pending、Cancelled 三种订单数量，并放在同一行显示
-- ==================================================
SELECT SUM(CASE WHEN order_status = 'Paid' THEN 1 ELSE 0 END) AS Paid_count,
			 SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END) AS Pending_count,
			 SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled_count
FROM orders;

-- ==================================================
-- 第 7 题
-- 统计 Paid 订单的实付总金额，显示 paid_actual_amount
-- ==================================================
SELECT 
SUM(CASE WHEN order_status = 'Paid' THEN unit_price * quantity - discount_amount  ELSE 0 END) 
AS paid_actual_amount
FROM orders;

SELECT  
SUM(unit_price * quantity - discount_amount) AS paid_actual_amount
FROM orders 
WHERE order_status = 'Paid';

-- ==================================================
-- 第 8 题
-- 按支付方式统计 Paid 订单数量和所有订单数量，显示 payment_method, paid_order_count, total_order_count
-- ==================================================
SELECT payment_method,
SUM(CASE WHEN order_status = 'Paid' THEN 1 ELSE 0 END) AS paid_order_count, 
COUNT(*) AS total_order_count
FROM orders 
GROUP BY payment_method;


-- ==================================================
-- 第 9 题
-- 按城市统计成年用户数量：age >= 18 计入 adult_user_count，显示 city, adult_user_count
-- ==================================================
SELECT city, 
SUM(CASE WHEN age > 18 THEN 1 ELSE 0 END) AS adult_user_count
FROM users
GROUP BY city;

-- ==================================================
-- 第 10 题
-- 查询每个商品分类下，高价商品数量，规则 price >= 300 为高价，显示 category, high_price_product_count
-- ==================================================
SELECT category, 
SUM(CASE WHEN price >= 300 THEN 1 ELSE 0 END) AS high_price_product_count
FROM products
GROUP BY category;
