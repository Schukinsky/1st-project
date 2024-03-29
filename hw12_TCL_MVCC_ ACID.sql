--1. Создаем хранимую процедуру add_purchase на вход принимающую id заказа, id продукта, кол-во продукта. 
--Внутри транзакции добавляется строка в таблицу purchase и изменяется кол-во оставшегося товара в таблице product с учетом добавленного в purchase
DELIMITER //
CREATE PROCEDURE store.add_purchase(IN in_order_id INT, IN in_product_id INT, IN in_quantity INT)
BEGIN
INSERT INTO purchase (FK_orders, FK_product, quantity) VALUES (in_order_id, in_product_id, in_quantity);
UPDATE product SET quantity = quantity - in_quantity WHERE id = in_product_id;
END //
DELIMITER ;
-- проверяем значения до вызова процедуры
CALL add_purchase(4, 100, 4) ; 
-- проверяем значения после вызова процедуры

--2. Загрузить данные из приложенных в материалах csv.
--LOAD DATA:
-- Создаем таблицу с необходимыми полями:
CREATE TABLE store_test.test_csv_tbl (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Handle` VARCHAR(255) NULL,
	`Title` VARCHAR(255) NULL,
	`Body (HTML)` VARCHAR(2048) NULL,
	`Vendor` VARCHAR(255) NULL,
	`Type` VARCHAR(255) NULL,
	`Tags` VARCHAR(255) NULL,
	`Published` VARCHAR(255) NULL,
	`Option1 Name` VARCHAR(255) NULL,
	`Option1 Value` VARCHAR(255) NULL,
	`Option2 Name` VARCHAR(255) NULL,
	`Option2 Value` VARCHAR(255) NULL,
	`Option3 Name` VARCHAR(255) NULL,
	`Option3 Value` VARCHAR(255) NULL,
	`Variant SKU` VARCHAR(255) NULL,
	`Variant Grams` VARCHAR(255) NULL,
	`Variant Inventory Tracker` VARCHAR(255) NULL,
	`Variant Inventory Qty` VARCHAR(255) NULL,
	`Variant Inventory Policy` VARCHAR(255) NULL,
	`Variant Fulfillment Service` VARCHAR(255) NULL,
	`Variant Price` VARCHAR(255) NULL,
	`Variant Compare At Price` VARCHAR(255) NULL,
	`Variant Requires Shipping` VARCHAR(255) NULL,
	`Variant Taxable` VARCHAR(255) NULL,
	`Variant Barcode` VARCHAR(255) NULL,
	`Image Src` VARCHAR(255) NULL,
	`Image Alt Text` VARCHAR(255) NULL,
	`Gift Card` VARCHAR(255) NULL,
	`SEO Title` VARCHAR(255) NULL,
	`SEO Description` VARCHAR(255) NULL,
	`Google Shopping / Google Product Category` VARCHAR(255) NULL,
	`Google Shopping / Gender` VARCHAR(255) NULL,
	`Google Shopping / Age Group` VARCHAR(255) NULL,
	`Google Shopping / MPN` VARCHAR(255) NULL,
	`Google Shopping / AdWords Grouping` VARCHAR(255) NULL,
	`Google Shopping / AdWords Labels` VARCHAR(255) NULL,
	`Google Shopping / Condition` VARCHAR(255) NULL,
	`Google Shopping / Custom Product` VARCHAR(255) NULL,
	`Google Shopping / Custom Label 0` VARCHAR(255) NULL,
	`Google Shopping / Custom Label 1` VARCHAR(255) NULL,
	`Google Shopping / Custom Label 2` VARCHAR(255) NULL,
	`Google Shopping / Custom Label 3` VARCHAR(255) NULL,
	`Google Shopping / Custom Label 4` VARCHAR(255) NULL,
	`Variant Image` VARCHAR(255) NULL,
	`Variant Weight Unit` VARCHAR(255) NULL,
	 PRIMARY KEY (`id`));
	 
	--В linux внутри контейнера создаем каталог mysql-files и назначем ему права:
	docker exec -it mysql_otusdb_1 bash
	cd /var/lib/
	mkdir mysql-files
	chown -R mysql:mysql ./mysql-files
	
	--В конфигурационном файле mysql /etc/mysql/my.cnf добавляем параметр:
	secure-file-priv= "/var/lib/mysql-files/" 
	
	--Перезапускаем кластер:
	cd /home/user/mysql/
	docker-compose restart
	
	--копируем файл Apparel.csv в каталог для загрузки:
	docker cp /home/user/Apparel.csv mysql_otusdb_1:/var/lib/mysql-files/Apparel.csv
	 
	--Загружаем данные из файла:
	LOAD DATA  INFILE '/var/lib/mysql-files/Apparel.csv' INTO table store_test.test_csv_tbl
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES
	(`Handle`, `Title`, `Body (HTML)`, `Vendor`, `Type`, `Tags`, `Published`, `Option1 Name`, `Option1 Value`, `Option2 Name`, `Option2 Value`, `Option3 Name`, `Option3 Value`, `Variant SKU`, `Variant Grams`, `Variant Inventory Tracker`, `Variant Inventory Qty`, `Variant Inventory Policy`, `Variant Fulfillment Service`, `Variant Price`, `Variant Compare At Price`, `Variant Requires Shipping`, `Variant Taxable`, `Variant Barcode`, `Image Src`, `Image Alt Text`, `Gift Card`, `SEO Title`, `SEO Description`, `Google Shopping / Google Product Category`, `Google Shopping / Gender`, `Google Shopping / Age Group`, `Google Shopping / MPN`, `Google Shopping / AdWords Grouping`, `Google Shopping / AdWords Labels`, `Google Shopping / Condition`, `Google Shopping / Custom Product`, `Google Shopping / Custom Label 0`, `Google Shopping / Custom Label 1`, `Google Shopping / Custom Label 2`, `Google Shopping / Custom Label 3`, `Google Shopping / Custom Label 4`, `Variant Image`, `Variant Weight Unit`)
	;
