-- ==================================================
-- 第 1 题
-- 查询订单编号、用户姓名、城市、订单状态，显示 order_id, user_name, city, order_status
-- ==================================================
SELECT o.order_id,
o.order_status,
u.user_name,
u.city
FROM orders AS o
INNER JOIN users AS u
on o.user_id = u.user_id;

-- ==================================================
-- 第 2 题
-- 查询订单编号、商品名称、商品分类、购买数量，显示 order_id, product_name, category, quantity
-- ==================================================
SELECT o.order_id,o.quantity,
p.product_name,p.category
FROM orders AS o
INNER JOIN products AS p
ON o.product_id = p.product_id;
-- ==================================================
-- 第 3 题
-- 查询订单编号、用户姓名、商品名称、实付金额，显示 order_id, user_name, product_name, actual_amount
-- ==================================================
SELECT o. order_id,
u.user_name,
p.product_name, 
o.quantity * o.unit_price - o.discount_amount AS actual_amount
FROM orders AS o
INNER JOIN users AS u
ON o.user_id = u.user_id
INNER JOIN products AS p
ON o.product_id = p.product_id;

-- ==================================================
-- 第 4 题
-- 查询订单状态为 Paid 的订单，显示 order_id, user_name, product_name, order_status
-- ==================================================
SELECT o.order_id,
u.user_name,
p.product_name, 
o.order_status
FROM orders  as o
INNER JOIN  users AS u
ON o.user_id = u.user_id
INNER JOIN products AS p
ON o.product_id = p.product_id
WHERE o.order_status = 'Paid';


 
-- ==================================================
-- 第 5 题
-- 查询来自 Shanghai 用户的订单，显示 order_id, user_name, city, product_name
-- ==================================================
SELECT o.order_id,
u.user_name,
u.city,
p.product_name
FROM orders  as o
INNER JOIN  users AS u
ON o.user_id = u.user_id
INNER JOIN products AS p
ON o.product_id = p.product_id
WHERE u.city = 'Shanghai';

-- ==================================================
-- 第 6 题
-- 查询每个城市的订单数量，显示 city, order_count
-- ==================================================
SELECT u.city,
COUNT(*) AS order_count
FROM orders AS o 
INNER JOIN users AS u
ON u.user_id = o.user_id
GROUP BY u.city;

-- ============== ====================================
-- 第 7 题
-- 查询每个商品分类的订单数量，显示 category, order_count
-- ======SELECT u.city,
-- ==================================================
SELECT p.category,
COUNT(*) AS order_count
FROM orders AS o 
INNER JOIN products AS p
ON p.product_id = o.product_id
GROUP BY  p.category;


-- ==================================================
-- 第 8 题
-- 查询每个城市的实付总金额，显示 city, total_actual_amount
-- ==================================================
SELECT u.city,
SUM(o.quantity * o.unit_price - o.discount_amount) AS total_actual_amount
FROM orders AS o
INNER JOIN users AS u
ON u.user_id = o.user_id
GROUP BY u.city;


-- ==================================================
-- 第 9 题
-- 查询每个商品分类的购买总件数，显示 category, total_quantity
-- ==================================================
SELECT  p.category,
SUM(o.quantity) AS  total_quantity
FROM orders as o
INNER JOIN products AS p
ON o.product_id = p.product_id
GROUP BY p.category;

-- ==================================================
-- 第 10 题
-- 查询 Paid 订单中，每个城市的实付总金额，显示 city, paid_actual_amount
-- ==================================================
SELECT u.city,
SUM(o.quantity * o.unit_price - o.discount_amount) AS paid_actual_amount
FROM orders AS o
INNER JOIN users AS u
ON u.user_id = o.user_id
WHERE o.order_status = 'Paid'
GROUP BY u.city;


-- ==================================================
-- 第 11 题
-- 查询每个用户的订单数量，显示 user_name, order_count
-- ==================================================
SELECT u.user_name,
COUNT(*) AS order_count
FROM users AS u
INNER JOIN orders AS o
ON u.user_id = o.user_id
GROUP BY u.user_name;


-- ==================================================
-- 第 12 题
-- 查询每个商品的实付su总金额，显示 product_name, total_actual_amount
-- ==================================================
SELECT p.product_name,
SUM(o.quantity * o.unit_price - o.discount_amount) AS total_actual_amount
FROM products as p
INNER JOIN orders AS o
ON o.product_id = p.product_id
GROUP BY p.product_name;
