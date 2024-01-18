--С помощью скрипта hw5_dml-insert-data.sql импортируем данные в таблицы базы данных

--1.Поиск в регистронезависомиом формате в таблице product всех позиций серии DWS, с которыми не идет к копмлеке кейс 
SELECT * FROM store_schema.product WHERE name ~~* '%dws%' AND description !~~* '%кейс%'
;

--2.Запрос с использованием LEFT JOIN позволяет определить производителя товаров которого нет в каталоге. Порядок соединения в FROM определяет строки какой таблицы будут выведены полностью, а из какой будут искаться соответствия.
--В строках из таблицы 1, которым не соответствуют никакие строки в таблице 2 вместо значений столбцов таблицы 2 вставляются NULL;
SELECT * FROM store_schema.manufacturer LEFT JOIN store_schema.product
ON manufacturer.id  = product.fk_manufacturer
WHERE product.name IS NULL
;

--3.Запрос с использованием INNER JOIN позволяет сделать выборку по конкретному производителю
SELECT * FROM store_schema.product INNER JOIN store_schema.manufacturer
ON  product.fk_manufacturer = manufacturer.id
WHERE manufacturer.name ~~* '%dewalt%' AND product.name ~~* '%dws%' AND description !~~* '%кейс%'
;

--4.Добавление данных с выводом информации о добавленных строках
INSERT INTO store_schema.manufacturer (name) VALUES
	('Интерскол')
	RETURNING *
;

--5.Использование UPDATE FROM---
--Создаем таблицу supplier_order_list
CREATE TABLE IF NOT EXISTS store_schema.supplier_order_list (
	id SERIAL PRIMARY KEY,
	product_name VARCHAR(128),
	quantity INTEGER,
	supplier_name VARCHAR(32),
	supplier_contact VARCHAR(32)
	);
--Наполняем таблицу supplier_order_list используя данные из таблиц product и supplier
INSERT INTO  store_schema.supplier_order_list (product_name, supplier_name, supplier_contact)
select p.name,  s.name, s.contact_info  from store_schema.product p  join store_schema.supplier s
on p.fk_supplier  = s.id 
;
--С помощью UPDATE FROM обновляем строки таблицы по тем товарам, остаток которых меньше или равен 2 
UPDATE store_schema.supplier_order_list o
SET 
product_name = p.name,
quantity=p.quantity, 
supplier_name=s.name,
supplier_contact=s.contact_info
FROM store_schema.product p  join store_schema.supplier s
ON p.fk_supplier  = s.id and p.quantity <= 2
WHERE o.id= p.id
;
--Выводим спискок товаров с остатком меньше или равеным 2 вместе с информацией о поставщике товара
SELECT * FROM store_schema.supplier_order_list WHERE quantity IS NOT NULL;

--6.С помощью DELETE FROM USING удалем дубликаты из таблицы manufacturer
DELETE FROM store_schema.manufacturer a
USING store_schema.manufacturer b
WHERE  a.id < b.id  AND a.name = b.name;

--7.С помощью ултилиты COPY формируем csv-файлpo
COPY (SELECT * FROM store_schema.supplier_order_list WHERE quantity IS NOT NULL) TO '/var/lib/postgresql/data/ts1/supplier_order_list.csv' WITH CSV HEADER;
