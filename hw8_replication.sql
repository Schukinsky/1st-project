--Физическая репликация--master порт 5433, replica порт 5432
--На мастере main:
show wal_level; --проверяем, что установлен параметр wal_level = replica

--Создаем второй кластер main2:
sudo pg_createcluster -d /var/lib/postgresql/12/main2 12 main2 
sudo rm -rf /var/lib/postgresql/12/main2 

--Сделаем бэкап мастера. Ключ -R создаст файл standby.signal и добавить параметры конфигурации в файл postgresql.auto.conf в целевом каталоге /var/lib/postgresql/12/main2
sudo -u postgres pg_basebackup -p 5433 -R -D /var/lib/postgresql/12/main2 -P -v -R -X stream -C -S pgstandby1
/*
http://snakeproject.ru/rubric/article.php?art=postgres_1213_slave_14032021
pg_basebackup -h 10.20.20.9 -D /var/lib/pgsql/12/data -U replicator -P -v  -R -X stream -C -S pgstandby1
-h - указывает хост, который является главным сервером.
-D - указывает каталог данных.
-U - указывает пользователя подключения.
-P - включает отчет о прогрессе.
-v - включает подробный режим.
-R - включает создание конфигурации восстановления:
создает файл standby.signal добавляет параметры подключения к postgresql.auto.conf в каталоге данных.
-X - используется для включения необходимых файлов журнала упреждающей записи (файлов WAL) в резервную копию.
Значение stream означает потоковую передачу WAL во время создания резервной копии.
-C - позволяет создать слот репликации, названный параметром -S, перед запуском резервного копирования.
-S - указывает имя слота репликации.
*/

sudo pg_ctlcluster 12 main2 start --стартуем кластер main2
pg_lsclusters --проверяем кластеры
sudo -u postgres psql -p 5434 --подключамемся к кластеру main2 по порту 5434
alter system set recovery_min_apply_delay to '5min'; --установим на реплике параметр отсрочки репликации
sudo pg_ctlcluster 12 main2 restart; --рестартуем кластер

sudo -u postgres psql -p 5433 --подключамемся к кластеру main по порту 5433
select * from pg_replication_slots; -- проверяем созданный слот репликации
create database otus; --создаем базу otus
\c otus	--подключаемся к базе otus
create table student as select generate_series(1,10) as id, md5(random()::text)::char(10) as fio; -- наполняем базу
--провряем работу репликации:
--на мастере
SELECT * FROM pg_stat_replication \gx
SELECT * FROM pg_current_wal_lsn();
--на реплике
select * from pg_stat_wal_receiver \gx
select pg_last_wal_receive_lsn();
select pg_last_wal_replay_lsn();

--Дополнительные комадны*:
select pg_create_physical_replication_slot('standby_slot'); --создаем слот репликации
select pg_drop_replication_slot('slot_name'); --удалям слот
alter system set primary_slot_name = 'standby_slot'; --настройкa реплики на использование слота репликации


--Логическая репликация----master порт 5433, replica порт 5432
sudo -u postgres psql -p 5433 --подключаемся к кластеру main по порту 5433
ALTER SYSTEM SET wal_level = logical; --устанавливаем параметр wal_level = logical
sudo pg_ctlcluster 12 main restart --рестартуем кластер

sudo -u postgres psql -p 5433 --подключаемся к кластеру main по порту 5433
\c otus	--подключаемся к базе otus
CREATE PUBLICATION test_pub FOR TABLE student; -- создаем публикацию test_pub для таблицы student
\dRp+  -- проверяем созданную публикацию

sudo -u postgres psql -p 5432 --подключаемся к кластеру main2 по порту 5432
create table student as select   generate_series(1,10) as id,   md5(random()::text)::char(10) as fio; -- создаем таблицу student 
CREATE SUBSCRIPTION otus_sub 
CONNECTION 'host=localhost port=5433 user=postgres password=postgres dbname=otus' 
PUBLICATION test_pub WITH (copy_data = true); --создадим подписку к БД по Порту с Юзером и Паролем и Копированием данных= true
\dRs --проверяем созданную подписку 

