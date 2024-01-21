--1.Создать индекс к какой-либо из таблиц вашей БД. Создаем btree индекс idx_Product_name для таблицы product по полю name.
CREATE INDEX IF NOT EXISTS idx_Product_name ON store_schema.product USING btree (name);
ANALYZE store_schema.product;
--2.Прислать текстом результат команды explain, в которой используется данный индекс
EXPLAIN (costs, verbose, format json, analyze) SELECT * FROM store_schema.product WHERE  name = 'Пила Zubr ZPD-2000'
--До создания индекса: Seq Scan on store_schema.product as product (cost=0..663.26 rows=1 width=551) (actual=0.062..4.612 rows=1 loops=1)
--После создания индекса: Index Scan using idx_product_name on store_schema.product as product (cost=0.28..8.3 rows=1 width=551) (actual=0.084..0.087 rows=1 loops=1)

--3.Реализовать индекс для полнотекстового поиска. Создаем GIN индекс search_index_desce для таблицы product по полю desc_lexeme
ALTER TABLE store_schema.product ADD COLUMN desc_lexeme tsvector;
UPDATE store_schema.product
SET desc_lexeme = to_tsvector(description);
SELECT name, desc_lexeme FROM store_schema.product;
 
EXPLAIN ANALYZE SELECT name FROM store_schema.product WHERE desc_lexeme @@ to_tsquery('кейс' ); 
--До создания индекса: Seq Scan on product  (cost=0.00..3827.51 rows=1736 width=44) (actual time=1.057..114.422 rows=1736 loops=1)
CREATE INDEX search_index_desc ON store_schema.product USING GIN (desc_lexeme);
ANALYZE store_schema.product;
EXPLAIN ANALYZE SELECT name FROM store_schema.product WHERE desc_lexeme @@ to_tsquery('кейс' ); 
--После создания индекса: Bitmap Index Scan on search_index_desc  (cost=0.00..21.74 rows=1736 width=0) (actual time=0.939..0.939 rows=1736 loops=1)

--4.Реализовать индекс на часть таблицы или индекс на поле с функцией. Создаем btree индекс idx_MD5_Product_name на поле name c функцией MD5
CREATE INDEX IF NOT EXISTS idx_MD5_Product_name ON store_schema.product USING btree (MD5(name));
ANALYZE store_schema.product;
EXPLAIN (costs, verbose, format json, analyze)SELECT * FROM store_schema.product WHERE  MD5(name) like '1aecf66d9c700a7d99755deba27be000'
--До создания индекса: Seq Scan on store_schema.product as product (cost=0..682.72 rows=39 width=551) (actual=0.843..81.157 rows=1 loops=1)
--После создания индекса: Bitmap Index Scan using idx_md5_product_name (cost=0..4.58 rows=39 width=0) (actual=0.113..0.113 rows=1 loops=1)

--5.Создать индекс на несколько полей. Создаем составной btree индекс idx_Product_name_quantity для таблицы product по полям name, quantity.
CREATE INDEX IF NOT EXISTS idx_Product_name_quantity ON store_schema.product USING btree (name, quantity);
ANALYZE store_schema.product;
EXPLAIN (costs, verbose, format json, analyze) SELECT * FROM store_schema.product WHERE  
name LIKE 'Пила Zubr ZPD-2000' AND quantity =6;
--Index Scan using idx_product_name_quantity on store_schema.product as product (cost=0.28..8.3 rows=1 width=551) (actual=0.072..0.076 rows=1 loops=1)

EXPLAIN (costs, verbose, format json, analyze) SELECT * FROM store_schema.product WHERE  quantity =18
--Index Scan using idx_product_name_quantity on store_schema.product as product (cost=0.28..346.65 rows=1 width=551) (actual=1.152..1.153 rows=0 loops=1)
--составной индекс работает при выборке по одному полю

EXPLAIN (costs, verbose, format json, analyze) SELECT * FROM store_schema.product WHERE  quantity =6
--Seq Scan on store_schema.product as product (cost=0..663.26 rows=565 width=551) (actual=0.046..5.228 rows=565 loops=1)
--индекс не работает при выводе 565 строк из 7781.Используется последовательное сканирование.
