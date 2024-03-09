-- Создание базы данных
CREATE DATABASE store;

-- Создание схемы данных
CREATE SCHEMA IF NOT EXISTS store_schema  AUTHORIZATION postgres;

-- Создание ролей, назначение прав доступа для ролей
CREATE ROLE  store_admin WITH PASSWORD 'admin';
ALTER ROLE store_admin SUPERUSER LOGIN;
GRANT ALL PRIVILEGES ON DATABASE store to store_admin;
GRANT ALL ON SCHEMA store_schema TO store_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA store_schema TO store_admin;

CREATE ROLE  store_customer WITH PASSWORD 'customer';
ALTER ROLE store_customer LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION;
GRANT CONNECT ON DATABASE "store" to store_customer;
GRANT USAGE ON SCHEMA store_schema TO store_customer;
GRANT SELECT ON ALL TABLES IN SCHEMA store_schema TO store_customer;
GRANT SELECT, INSERT, UPDATE ON TABLE store_schema.customer, store_schema.order, store_schema.purchase TO store_customer;

-- Создание таблиц в схеме данных
CREATE TABLE IF NOT EXISTS store_schema.status (
	id SERIAL PRIMARY KEY,
	name VARCHAR(32)
	);
CREATE TABLE IF NOT EXISTS store_schema.category (
	id SERIAL PRIMARY KEY,
	name VARCHAR(32)
	);
CREATE TABLE IF NOT EXISTS store_schema.supplier (
	id SERIAL PRIMARY KEY,
	name VARCHAR(32),
	contact_info VARCHAR(32)
	);
CREATE TABLE IF NOT EXISTS store_schema.manufacturer (
	id SERIAL PRIMARY KEY,
	name VARCHAR(32)
	);
CREATE TABLE IF NOT EXISTS store_schema.customer (
	id SERIAL PRIMARY KEY,
	name VARCHAR(32),
	email VARCHAR(32),
	phone VARCHAR(32)
	);
CREATE TABLE IF NOT EXISTS store_schema.product (
	id SERIAL PRIMARY KEY,
	name VARCHAR(128),
	description VARCHAR(1024),
	FK_category INTEGER REFERENCES store_schema.category(id) ON DELETE CASCADE,
	FK_manufacturer INTEGER REFERENCES store_schema.manufacturer(id) ON DELETE CASCADE,
	FK_supplier INTEGER REFERENCES store_schema.supplier(id) ON DELETE CASCADE,
	quantity INTEGER
	);
CREATE TABLE IF NOT EXISTS store_schema.price (
	id SERIAL PRIMARY KEY,
	FK_product INTEGER REFERENCES store_schema.product(id) ON DELETE CASCADE,
	price DECIMAL(10, 2),
	start_date TIMESTAMP,
	end_date TIMESTAMP
	);
CREATE TABLE IF NOT EXISTS store_schema.order (
	id SERIAL PRIMARY KEY,
	FK_customer INTEGER REFERENCES store_schema.customer(id) ON DELETE CASCADE,
	FK_status INTEGER REFERENCES store_schema.status(id) ON DELETE CASCADE,
	address VARCHAR(32),
	order_date TIMESTAMP
	);
CREATE TABLE IF NOT EXISTS store_schema.purchase (
	FK_order INTEGER REFERENCES store_schema.order(id) ON DELETE CASCADE,
	FK_product INTEGER REFERENCES store_schema.product(id) ON DELETE CASCADE,
	quantity INTEGER,
	PRIMARY KEY (FK_order, FK_product)
	);

-- Создание табличных пространств и распередеоение таблиц
	--docker exec -it pg-server bash
	--cd /var/lib/postgresql/data
	--mkdir ts1
	--chown -R postgres:postgres ./ts1

CREATE TABLESPACE ts1 LOCATION '/var/lib/postgresql/data/ts1';
ALTER TABLE store_schema.status SET TABLESPACE ts1;
ALTER TABLE store_schema.category SET TABLESPACE ts1;
ALTER TABLE store_schema.supplier SET TABLESPACE ts1;
ALTER TABLE store_schema.manufacturer SET TABLESPACE ts1;
ALTER TABLE store_schema.customer SET TABLESPACE ts1;
ALTER TABLE store_schema.product SET TABLESPACE ts1;
ALTER TABLE store_schema.price SET TABLESPACE ts1;
ALTER TABLE store_schema.order SET TABLESPACE ts1;
ALTER TABLE store_schema.purchase SET TABLESPACE ts1;
