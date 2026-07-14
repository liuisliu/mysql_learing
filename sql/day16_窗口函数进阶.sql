
-- ==================================================
-- 第1题
-- 查询每条订单的订单编号、用户编号、订单日期、实付金额，并计算该用户按日期累计消费金额。
-- 显示字段：order_id, user_id, order_date, actual_amount, running_total_amount
-- ==================================================
SELECT order_id, 
       user_id,
       order_date, 
			 quantity * unit_price - discount_amount AS actual_amount,
			 SUM(quantity * unit_price - discount_amount) over(
			    PARTITION by user_id
					ORDER BY order_date
					) AS running_total_amount 
FROM orders;
 
-- ==================================================
-- 第2题
-- 查询每个商品的商品编号、商品名称、商品分类、价格，并显示同分类平均价格。
-- 显示字段：product_id, product_name, category, price, category_avg_price
-- ==================================================
SELECT product_id, 
       product_name, 
       category,
       price,
       ROUND(
			  avg(price) over (
			   PARTITION by category
				 ) , 2 )AS category_avg_price
FROM products;
-- ==================================================
-- 第3题
-- 查询每个商品的商品编号、商品名称、商品分类、价格，并显示该商品与同分类平均价格的差值。
-- 显示字段：product_id, product_name, category, price, price_diff
-- ==================================================
SELECT product_id, 
       product_name, 
       category,
       price,
       ROUND(
			  price-avg(price) over (
			   PARTITION by category
				 ) , 2 )AS price_diff
				 
FROM products;

-- ==================================================
-- 第4题
-- 查询每个城市的用户明细，并显示该城市的用户数量。
-- 显示字段：user_id, user_name, city, city_user_count
-- ==================================================
SELECT user_id,  
       user_name, 
			 city,
			 COUNT(*) over(
			  PARTITION by city
				) AS city_user_count
FROM users;

-- ==================================================
-- 第5题
-- 查询每条订单的订单编号、用户编号、订单日期、实付金额，并显示该用户上一笔订单金额。
-- 显示字段：order_id, user_id, order_date, actual_amount, previous_amount
-- ==================================================
SELECT order_id, 
       user_id, 
       order_date, 
       unit_price * quantity - discount_amount AS actual_amount,
			 LAG(unit_price * quantity - discount_amount) over (
			  PARTITION by user_id
				ORDER BY order_date
				) AS previous_amount
FROM orders;

-- ==================================================
-- 第6题
-- 查询每条订单的订单编号、用户编号、订单日期、实付金额，并显示该用户下一笔订单金额。
-- 显示字段：order_id, user_id, order_date, actual_amount, next_amount
-- ==================================================
SELECT order_id, 
       user_id, 
       order_date, 
       unit_price * quantity - discount_amount AS actual_amount,
			 LEAD(unit_price * quantity - discount_amount) over (
			  PARTITION by user_id
				ORDER BY order_date
				) AS next_amount
FROM orders;


-- ==================================================
-- 第7题
-- 查询每种支付方式下，每条订单的订单编号、支付方式、实付金额，并显示该支付方式的平均实付金额。
-- 显示字段：order_id, payment_method, actual_amount, payment_avg_amount
-- ==================================================
SELECT order_id, 
       payment_method,
			 unit_price * quantity - discount_amount AS actual_amount,
			 ROUND(AVG( unit_price * quantity - discount_amount) OVER (
			   PARTITION BY payment_method
				 ) ,2) AS  payment_avg_amount
FROM orders;

-- ==================================================
-- 第8题
-- 查询每个用户每条订单的订单编号、订单日期、实付金额，并显示该用户累计实付金额占总实付金额的比例。
-- 显示字段：order_id, user_id, order_date, actual_amount, running_total_amount, total_ratio
-- ==================================================
SELECT order_id, 
       user_id, 
       order_date,
       unit_price * quantity - discount_amount AS actual_amount,
			 ROUND(SUM(unit_price * quantity - discount_amount) OVER (
			   PARTITION BY user_id
			   ORDER BY order_date
			    ) ,2 ) AS running_total_amount,
			   ROUND(ROUND(SUM(unit_price * quantity - discount_amount) OVER (
			     PARTITION BY user_id
			     ORDER BY order_date
			     ) ,2 ) 
					 / 
					 SUM(unit_price * quantity - discount_amount) over( ) , 4 )
					 AS total_ratio
FROM orders;
			 
-- ==================================================
-- 第9题
-- 查询每个用户消费金额最高的前 2 笔订单。
-- 显示字段：order_id, user_id, order_date, actual_amount, amount_rank
-- ==================================================
SELECT  order_id,
        user_id,
	      order_date, 
				actual_amount,
				amount_rank
FROM(
       SELECT order_id,
              user_id,
	            order_date, 
							unit_price * quantity - discount_amount AS actual_amount,
							ROW_NUMBER() over(
							  PARTITION by  user_id
								ORDER BY unit_price * quantity - discount_amount  DESC 
								) AS amount_rank
				FROM orders 
				) AS ranked_actual_amount
WHERE amount_rank <= 2;

-- =================== ===============================
-- 第10题
-- 查询每个城市中年龄高于该城市平均年龄的用户。
-- 显示字段：user_id, user_name, city, age, city_avg_age
-- ==================================================

				
				
SELECT user_id,
       user_name, 
       city,
	     age,
			 city_avg_age
FROM ( 
			SELECT user_id,
             user_name, 
             city,
	           age,
						 AVG(age) over(
			          PARTITION by city
				        ) AS city_avg_age
			FROM users
			) AS avg_agr_city
WHERE  age > city_avg_age;

-- ==================================================
-- 第11题
-- 查询每条订单和上一条订单的金额差。
-- 显示字段：order_id, user_id, order_date, actual_amount, previous_amount, amount_change
-- ==================================================
SELECT order_id, 
       user_id, 
       order_date, 
       unit_price * quantity - discount_amount AS actual_amount,
			 LAG(unit_price * quantity - discount_amount) over(
			   PARTITION by user_id 
				 ORDER BY order_date
				 ) AS previous_amount,
			 unit_price * quantity - discount_amount 
			 - 
			 LAG(unit_price * quantity - discount_amount) over(
			   PARTITION by user_id 
				 ORDER BY order_date
				 ) 
				 AS amount_change
FROM orders; 

-- ==================================================
-- 第12题
-- 查询每个用户的订单金额累计，并按累计金额分成高、中、低三个层级。
-- 显示字段：order_id, user_id, order_date, actual_amount, running_total_amount, spend_level
-- ==================================================
SELECT order_id, 
       user_id,  
       order_date, 
       actual_amount,
			 running_total_amount,
       CASE 
	       WHEN running_total_amount > 1000  THEN  '高'
	       WHEN running_total_amount > 500  THEN  '中'	
	       ELSE '低'
       END AS spend_level
FROM ( SELECT
        order_id, 
        user_id,  
        order_date, 
        unit_price * quantity - discount_amount AS actual_amount, 
			  SUM(unit_price * quantity - discount_amount) over(
			    PARTITION by user_id 
				  ORDER BY order_date 
				 ) AS running_total_amount
			 FROM orders 
			 ) AS ranked_list;


				 
       







