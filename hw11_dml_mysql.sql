--Запрос с inner join:
	SELECT * FROM manufacturer INNER JOIN product
	ON  manufacturer.id = product.fk_manufacturer;

--Запрос  с left join
	SELECT  purchase.FK_orders AS 'Номер заказа', product.name AS 'Наименование', purchase.quantity AS 'Кол-во'  
	FROM purchase LEFT JOIN product
	ON purchase.FK_product = product.id;

--5 запросов с WHERE с использованием разных операторов

	--1. Запрос позволяет определить актуальную(действующую) цену для конкретного с применением оператора продукта IS NULL:
		SELECT * FROM price WHERE FK_product=1; 
		SELECT product.name, price.price  FROM product LEFT JOIN price ON  product.id = price.FK_product 
		WHERE product.id = 1 AND end_date IS NULL;

	--2. Поиск в регистронезависимом формате всех позиций серии DWS7 с применением оператора LIKE:
		SELECT * FROM product INNER JOIN manufacturer
		ON  product.fk_manufacturer = manufacturer.id
		WHERE  product.name LIKE '%dws7%';

	--3. Поиск в регистронезависимом формате всех позиций серии DWS с применением регулярных выражений:
		SELECT * FROM product INNER JOIN manufacturer
		ON  product.fk_manufacturer = manufacturer.id
		WHERE  product.name REGEXP 'dws';

	--4. Поиск всех товаров производителей Bosch, DeWALT, Makita с сортировкой по количеству товара на складе с применением оператора IN:
		SELECT * FROM manufacturer INNER JOIN product
		ON  manufacturer.id = product.fk_manufacturer 
		WHERE manufacturer.name IN ('Bosch', 'DeWALT', 'Makita') 
		ORDER BY product.quantity ; 

	--5.1 Поиск всех товаров цена, которых от 13630 до 13900 с применением оператора BETWEEN:
		SELECT product.name, price.price, price.start_date, price.end_date FROM product LEFT JOIN price ON  product.id = price.FK_product 
		WHERE price.price BETWEEN 13630 AND 13900;

	--5.2 Поиск цены товара на определенную дату 2024-03-18 13:14:07 с применением оператора BETWEEN:
		SELECT product.name, price.price, price.start_date, price.end_date FROM product LEFT JOIN price ON  product.id = price.FK_product 
		WHERE '2024-03-18 13:14:07' BETWEEN price.start_date AND price.end_date;

	--5* Поиск поставщиков остатки товаров, у которых <= 2 с применением оператора EXISTS:
		SELECT name, contact_info
		FROM supplier s
		WHERE EXISTS (SELECT 1 FROM product p WHERE s.id = p.FK_supplier AND quantity <= 2);



