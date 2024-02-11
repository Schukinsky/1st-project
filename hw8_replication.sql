--Физическая репликация 
--На мастере main:
show wal_level; --проверяем параметр wal_level
alter system set wal_level = replica; --устанавливаем параметр wal_level=replica
select pg_create_physical_replication_slot('standby_slot'); --создаем слот репликации
select pg_drop_replication_slot('slot_name'); --удалям слот
select * from pg_replication_slots; -- проверяем созданный слот репликации
sudo pg_ctlcluster 14 main restart --рестартуем кластер

--Создаем второй кластер main2:
sudo pg_createcluster -d /var/lib/postgresql/14/main2 14 main2 
sudo rm -rf /var/lib/postgresql/14/main2

--Сделаем бэкап мастера. Ключ -R создаст файл standby.signal и добавить параметры конфигурации в файл postgresql.auto.conf в целевом каталоге /var/lib/postgresql/14/main2
sudo -u postgres pg_basebackup -p 5431 -R -D /var/lib/postgresql/14/main2 -P -v -R -X stream -C -S pgstandby1
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

sudo pg_ctlcluster 14 main2 start --стартуем кластер main2
pg_lsclusters --проверяем кластеры
sudo -u postgres psql -p 5433 --подключемемся к кластеру main2 по порту 5433
alter system set primary_slot_name = 'standby_slot'; --настройкa реплики на использование слота репликации
alter system set recovery_min_apply_delay to '5min'; --установим на реплике параметр отсрочки репликации
sudo pg_ctlcluster 14 main2 restart --рестартуем кластер


select * from pg_replication_slots; -- проверяем созданный слот репликации