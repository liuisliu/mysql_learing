-- ==================================================
-- 第1题
-- 删除存储过程 p_get_order_discount_level。即使该过程不存在，也不能报错。
-- ==================================================
DROP PROCEDURE IF EXISTS p_get_order_discount_level;

-- ==================================================
-- 第2题
-- 创建存储过程 p_get_order_discount_level。
-- 接收订单编号输入参数，通过输出参数返回订单优惠等级。
-- 优惠金额大于等于 20 返回 high，大于等于 5 返回 medium，其余返回 low。
-- ==================================================
DROP PROCEDURE IF EXISTS p_get_order_discount_level;

DELIMITER$$

CREATE PROCEDURE p_get_order_discount_level
( IN p_order_id VARCHAR(255)
 CHARACTER SET utf8mb4
 COLLATE utf8mb4_general_ci,
 OUT p_discount_leval VARCHAR(255)
)
 BEGIN
  DECLARE v_discount DECIMAL(10,2) ;

  SELECT 
       discount_amount
			 INTO v_discount
  FROM orders
  WHERE order_id = p_order_id;
 
  IF v_discount >= 20 THEN 
	  SET p_discount_leval = 'high';
  ELSEIF v_discount>= 5 THEN 
	  SET p_discount_leval = 'medium';
  ELSE 
	  SET p_discount_leval = 'low';
  END IF; 
  END$$
DELIMITER;
-- ==================================================
-- 第3题
-- 调用存储过程 p_get_order_discount_level，查询订单编号 O0001 的优惠等级。
-- 显示字段：discount_level
-- ==================================================
CALL p_get_order_discount_level('O0001',@discount_level);
SELECT @discount_level AS discount_level;

SHOW FULL COLUMNS
FROM orders
LIKE 'order_id';
-- ==================================================
-- 第4题
-- 删除存储过程 p_get_payment_label。即使该过程不存在，也不能报错。
-- 再创建该过程，接收支付方式输入参数，通过输出参数返回支付标签。
-- WeChat Pay 返回 wechat，Alipay 返回 alipay，Credit Card 返回 card，其他值返回 other。
-- ==================================================
DROP PROCEDURE IF EXISTS p_get_payment_label;

DELIMITER$$

CREATE PROCEDURE p_get_payment_label
( IN p_payment_method VARCHAR(255),
	OUT p_payment_lable VARCHAR(255)
	)

BEGIN 
  
IF p_payment_method = 'WeChat Pay' THEN
 SET p_payment_lable = 'wechat';
ELSEIF p_payment_method ='Alipay' THEN
 SET p_payment_lable = 'alipay';
ELSEIF p_payment_method ='Credit Card' THEN
 SET p_payment_lable = 'card';
ELSE
 SET p_payment_lable = 'other';
END IF;
END$$

DELIMITER;



-- ==================================================
-- 第5题
-- 调用存储过程 p_get_payment_label，查询支付方式 WeChat Pay 的支付标签。
-- 显示字段：payment_label
-- ==================================================
CALL p_get_payment_label('WeChat Pay',@payment_label);

SELECT @payment_label AS payment_label;

-- ==================================================
-- 第6题
-- 删除存储过程 p_set_order_discount。即使该过程不存在，也不能报错。
-- 再创建该过程，接收订单编号和新优惠金额两个输入参数。
-- 当新优惠金额小于 0 时，过程必须主动报错且不能更新订单。
-- 当新优惠金额不小于 0 时，更新对应订单的优惠金额。
-- ==================================================
DROP PROCEDURE IF EXISTS p_set_order_discount;

DELIMITER$$
CREATE PROCEDURE p_set_order_discount 
(IN p_order_id VARCHAR(255)
 CHARACTER SET utf8mb4
 COLLATE utf8mb4_general_ci,
	IN p_discount_amount DECIMAL(10,2))
BEGIN
IF p_discount_amount < 0 THEN
SIGNAL SQLSTATE'45000'
SET MESSAGE_TEXT = 'discount_amount cant be negitive';
END IF;

UPDATE orders
SET discount_amount =  p_discount_amount
WHERE order_id = p_order_id;

END$$
DELIMITER;



-- ==================================================
-- 第7题
-- 开始事务，调用存储过程 p_set_order_discount，将订单编号 O0001 的优惠金额设置为 10。
-- 查询订单编号和优惠金额后回滚事务。
-- 显示字段：order_id, discount_amount
-- ==================================================
START TRANSACTION;

CALL p_set_order_discount('O0001' , '9');

SELECT 
      order_id, 
      discount_amount
FROM orders
WHERE order_id = 'O0001';

ROLLBACK;
-- ==================================================
-- 第8题
-- 开始事务，调用存储过程 p_set_order_discount，尝试将订单编号 O0001 的优惠金额设置为 -5。
-- 观察报错结果后回滚事务。
-- ==================================================
START TRANSACTION;

CALL p_set_order_discount('O0001' , '-5');

ROLLBACK;



-- ==================================================
-- 第9题
-- 删除存储过程 p_increase_user_discounts。即使该过程不存在，也不能报错。
-- 再创建该过程，接收用户编号和增加金额两个输入参数。
-- 当增加金额小于等于 0 时，过程必须主动报错。
-- 当增加金额大于 0 时，将该用户全部订单的优惠金额增加指定金额。
-- ==================================================
DROP PROCEDURE IF EXISTS  p_increase_user_discounts;

DELIMITER$$
CREATE PROCEDURE  p_increase_user_discounts 
(
 IN p_user_id VARCHAR(255)
 CHARACTER SET utf8mb4
 COLLATE utf8mb4_general_ci,
 IN p_crease_amount DECIMAL(10,2)
 )
 BEGIN 
 IF p_crease_amount  <= 0 THEN
   SIGNAL SQLSTATE '45000'
	 SET MESSAGE_TEXT = 'crease amount cant be negitive';
 END IF;
 
 UPDATE orders
 SET discount_amount = discount_amount + p_crease_amount
 WHERE user_id = p_user_id;
 END$$
 DELIMITER;

-- ==================================================
-- 第10题
-- 开始事务，调用存储过程 p_increase_user_discounts，将用户编号 U001 的全部订单优惠金额增加 1。
-- 查询该用户的订单编号、用户编号和优惠金额后回滚事务。
-- 显示字段：order_id, user_id, discount_amount
-- ==================================================
START TRANSACTION;

CALL p_increase_user_discounts('U001' , '1');

SELECT 
     order_id, 
     user_id, 
     discount_amount
FROM orders
WHERE user_id = 'U001';

ROLLBACK;

-- ==================================================
-- 第11题
-- 查看存储过程 p_set_order_discount 的完整创建语句。
-- ==========================p_set_order_discount========================
SHOW CREATE PROCEDURE p_set_order_discount;

-- ==================================================
-- 第12题
-- 使用 SQL 注释说明 p_new_discount、v_discount、discount_amount 和 @discount_level 的区别。
-- ==================================================

--p_new_discount,p开头的是过程中的参数，只在过程中有效
--v_discount是过程中的局部变量，用来接收查询到的结果，然后继续判断用的
--discount_amount 是一个数据表的字段，只是用来查询或者显示的普通字段
--@discount_level 是在navitcat连接期间的变量，一般用在输出的结果接收上，把输出的结果赋值给变量