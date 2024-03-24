--1. Проверяем и удаляем ненужные индексы:
	SELECT * FROM sys.schema_redundant_indexes;

	ALTER TABLE `store`.`category` DROP INDEX `id`;
	ALTER TABLE `store`.`customer` DROP INDEX `id`;
	ALTER TABLE `store`.`manufacturer` DROP INDEX `id`;
	ALTER TABLE `store`.`orders` DROP INDEX `id`;
	ALTER TABLE `store`.`price` DROP INDEX `id`;
	ALTER TABLE `store`.`product` DROP INDEX `id`;
	ALTER TABLE `store`.`status` DROP INDEX `id`;
	ALTER TABLE `store`.`supplier` DROP INDEX `id`;

--2. Создаем  индекс idx_Product_name для таблицы product по полю name:
	--Выполняем команду EXPLAIN до создания индекса
	EXPLAIN
	SELECT * FROM product WHERE  name = 'Пила Zubr ZPD-2000';
	--Создаем индекс
	CREATE INDEX idx_Product_name ON product (name);
	--Выполняем команду EXPLAIN после создания индекса
	EXPLAIN
	SELECT * FROM product WHERE  name = 'Пила Zubr ZPD-2000';
	
--3. Создаем полнотекстовый индекс fulltext_idx_product_description для таблицы product на поле description:	
	CREATE FULLTEXT INDEX fulltext_idx_product_description ON product (description);
	
	--Проверяем работу полнотекстового индекса
	SELECT * FROM product WHERE MATCH (description) AGAINST ('кейс');
	
	EXPLAIN
	SELECT * FROM product WHERE MATCH (description) AGAINST ('кейс');

