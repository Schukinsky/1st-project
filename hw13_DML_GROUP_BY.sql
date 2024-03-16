--1. группировки с использованием CASE, HAVING, ROLLUP, GROUPING() :
--2. для магазина к предыдущему списку продуктов добавить максимальную и минимальную цену и кол-во предложений
SELECT 
c.name,
MIN(pr.price),
MAX(pr.price),
SUM(CASE WHEN p.quantity>0 THEN 1 ELSE 0 END)
AS 'кол-во предложений'
FROM product p LEFT JOIN category c ON p.FK_category=c.id LEFT JOIN price pr ON p.id = pr.FK_product WHERE pr.end_date IS NULL
GROUP BY c.name;

--3. сделать выборку показывающую самый дорогой и самый дешевый товар в каждой категории
SELECT 
c.name,
MIN(pr.price),
MAX(pr.price)
FROM product p LEFT JOIN category c ON p.FK_category=c.id LEFT JOIN price pr ON p.id = pr.FK_product WHERE pr.end_date IS NULL
GROUP BY c.name;

SELECT
p.name, c.name as category, pr.price,
MIN(pr.price) OVER (PARTITION BY c.name) AS min_price_in_category,
MAX(pr.price) OVER (PARTITION BY c.name) AS max_price_in_category
FROM product p LEFT JOIN category c ON p.FK_category=c.id LEFT JOIN price pr ON p.id = pr.FK_product WHERE pr.end_date IS NULL;

--4. сделать rollup с количеством товаров по категориям
SELECT 
IF (GROUPING(c.name), 'ИТОГО', c.name) AS category,
count(*) AS COUNT
FROM product p LEFT JOIN category c ON p.FK_category=c.id LEFT JOIN price pr ON p.id = pr.FK_product WHERE pr.end_date IS NULL
GROUP BY c.name  WITH ROLLUP;
