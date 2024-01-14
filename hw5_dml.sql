--Поиск в таблице product всех позиций серии DWS, с которым не идет к копмлеке кейс в регистронезависомиом формате
SELECT * FROM store_schema.product WHERE name ~~* '%dws%' AND description !~~* '%кейс%'
;

--Запрос с использованием LEFT JOIN позволяет определить производителя товаров которого нет в каталоге. Порядок соединения в FROM определяет строки какой таблицы будут выведены полностью, а из какой будут искаться соответствия.
--В строках из таблицы 1, которым не соответствуют никакие строки в таблице 2 вместо значений столбцов таблицы 2 вставляются NULL;
SELECT * FROM store_schema.manufacturer LEFT JOIN store_schema.product
ON manufacturer.id  = product.fk_manufacturer
WHERE product.name IS NULL
;

--Запрос с использованием INNER JOIN позволяет сделать выборку по конкретному производителю
SELECT * FROM store_schema.product INNER JOIN store_schema.manufacturer
ON  product.fk_manufacturer = manufacturer.id
WHERE manufacturer.name ~~* '%dewalt%' AND product.name ~~* '%dws%' AND description !~~* '%кейс%'
;

--Добавление данных с выводом информации о добавленных строках
INSERT INTO store_schema.manufacturer (name) VALUES
	('Интерскол')
	RETURNING *
;

---------------------------------------------------
CREATE TABLE IF NOT EXISTS store_schema.supplier_order_list (
	id SERIAL PRIMARY KEY,
	product_name VARCHAR(128),
	quantity INTEGER,
	supplier_name VARCHAR(32),
	supplier_contact VARCHAR(32)
	);

UPDATE store_schema.supplier_order_list
SET product_name = product.name, quantity=product.quantity, supplier_name=supplier.name, supplier_contact=supplier.contact_info
from store_schema.product  join store_schema.supplier
		on product.fk_supplier  = supplier.id
		WHERE product.quantity <= 2
		
UPDATE store_schema.supplier_order_list
SET product_name = (select product.name  from store_schema.product  join store_schema.supplier
		on product.fk_supplier  = supplier.id AND product.quantity <= 2)
    quantity = product.quantity, 
    supplier_name = supplier.name, 
    supplier_contact = supplier.contact_info
FROM (select product.name, product.quantity, supplier.name, supplier.contact_info  from store_schema.product  join store_schema.supplier
		on product.fk_supplier  = supplier.id AND product.quantity <= 2)

(store_schema.product 
JOIN store_schema.supplier 
    ON product.fk_supplier = supplier.id AND product.quantity <= 2);
WHERE product.quantity <= 2;		
		
		
		
		
select product.name, product.quantity, supplier.name, supplier.contact_info  from store_schema.product  join store_schema.supplier
		on product.fk_supplier  = supplier.id AND product.quantity <= 2
		WHERE product.quantity <= 2
		;