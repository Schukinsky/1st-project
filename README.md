## Концептуальная модель базы данных для интернет-магазина
### Сущности:

##### 1. Продукты (Product):

- id (Primary Key)
- name (название продукта)
- description (описание продукта)
- FK_category (внешний ключ, связанный с таблицей Сategory)
- FK_manufacturer (внешний ключ, связанный с таблицей Manufacturer)
- FK_supplier (внешний ключ, связанный с таблицей Supplier)
- quantity (количество продукта)

##### 2. Категории продуктов (Сategory):

- id (Primary Key)
- name (название категории)

##### 3. Цены (Price):

- id (Primary Key)
- FK_product (внешний ключ, связанный с таблицей Product)
- price (цена продукта)
- start_date (дата начала действия цены)
- end_date (дата окончания действия цены)

##### 4. Поставщики (Supplier):

- id (Primary Key)
- name (название поставщика)
- contact_info (контактная информация)

##### 5. Производители (Manufacturer):

- id (Primary Key)
- name (название производителя)

##### 6. Покупатели (Customer):

- id (Primary Key)
- name (имя покупателя)
- email (электронная почта покупателя)
- phone (контактный телефон)

##### 7. Покупки (Purchase):

- FK_order, FK_product (Primary Key)
- FK_order (внешний ключ, связанный с таблицей Order)
- FK_product (внешний ключ, связанный с таблицей Product)
- quantity (количество купленных продуктов)

##### 8. Заказы (Order):

- id (Primary Key)
- FK_customer (внешний ключ, связанный с таблицей Customer)
- FK_status (внешний ключ, связанный с таблицей Status)
- address (адрес доставки)
- order_date (дата заказа)

##### 9. Статус (Status):

- id (Primary Key)
- name (наименование статуса)


### Связи:

Product.FK_category связан с Сategory.id

Product.FK_manufacturer связан с Manufacturer.id

Product.FK_supplier связан с Supplier.id

Price.FK_product связан с Product.id

Purchase.FK_order связан с Order.id

Purchase.FK_product связан с Product.id

Order.FK_customer связан с Order.id

Order.FK_status связан с Status.id

### Бизнес-задачи:

1. Отслеживание товара:
   База данных помогает отслеживать количество продуктов в наличии и предотвращать нехватку товаров.

2. Ценообразование:
   Система цен позволяет управлять ценами на продукты в разные периоды времени и анализировать, какие цены наиболее эффективны.

3. Анализ покупок:
   Используя данные о покупках, можно проводить анализ предпочтений покупателей и формировать стратегии маркетинга.
   
5. Управление поставками:
   Отслеживание поставщиков и связанных с ними данных помогает эффективно управлять поставками и поддерживать сотрудничество с надежными поставщиками.

6. Профили покупателей:
   Хранение данных о покупателях позволяет создавать персонализированные предложения, учитывая предпочтения каждого клиента.

### ER-диаграмма:

![](erd.drawio.png)

### Анализ возможных запросов, отчетов, поиска данных:

Запросы:

- Запрос на поиск продуктов по его названию или описанию.
- Запрос на поиск всех продуктов определенной категории.
- Запрос на поиск всех продуктов определенного бренда.
- Запрос на поиск всех продуктов с определенной ценой или ценовым диапазоном.

Отчеты:

- Запрос на получение отчета о продаж за определенный период времени.
- Запрос на получение отчета о наиболее популярных товарах или категориях товаров.
- Запрос на получение отчета о продуктах с минимальным остатком на складе.

Поиск данных:
- Запрос на получение данных о заказах, сделанных определенным клиентом (например: история заказов, статус).
- Запрос на получение данных о клиентах (например: информация о покупках, контактные данные).
- Запрос на поиск всех заказов, сделанных за определенный период времени.
- Запрос на поиск всех заказов определенного статуса (выполненных, отмененных и т. д.).

| Поле                    | Тип поля        | Кардинальность | Ограничения       | Индексы         |
|:----------------------- |:---------------:|:--------------:|:-----------------:|:---------------:|
| Product.id              | PRIMARY KEY     |       -        |*UNIQUE + NOT NULL |*                |
| Product.name            |                 | Высокая        | NOT NULL          |                 |
| Product.description     |                 | Высокая        | NOT NULL          |                 | 
| Product.FK_category     | FOREIGN KEY     |       -        |                   |                 |
| Product.FK_manufacturer | FOREIGN KEY     |       -        |                   |                 |
| Product.FK_supplier     | FOREIGN KEY     |       -        |                   |                 |
| Product.quantity        |                 | Высокая        | NOT NULL          |                 |
| Сategory.id             | PRIMARY KEY     |       -        |*UNIQUE + NOT NULL |*                |
| Сategory.name           |                 | Низкая         | NOT NULL                            |                 |
| Price.id                | PRIMARY KEY     |       -        |*UNIQUE + NOT NULL |*                |
| Price.FK_product        | FOREIGN KEY     |       -        |                   |                 |
| Price.price             |                 | Высокая        | NOT NULL          |                 |
| Price.start_date        |                 | Высокая        | NOT NULL          |                 |
| Price.end_date          |                 | Высокая        | CHECK(>start_date)|                 |
| Supplier.id             | PRIMARY KEY     |       -        |*UNIQUE + NOT NULL |*                |
| Supplier.name           |                 | Высокая        | UNIQUE, NOT NULL  |                 |
| Supplier.contact_info   |                 | Высокая        | NOT NULL          |                 |
| Manufacturer.id         | PRIMARY KEY     |       -        |*UNIQUE + NOT NULL |*                |
| Manufacturer.name       |                 |Низкая, среднняя| UNIQUE, NOT NULL  |                 |
| Customer.id             | PRIMARY KEY     |       -        |*UNIQUE + NOT NULL |*                |
| Customer.name           |                 | Высокая        | NOT NULL          |                 |
| Customer.email          |                 | Высокая        | NOT NULL          |                 |
| Customer.phone          |                 | Высокая        | NOT NULL          |                 |
| Purchase.FK_order       | FOREIGN KEY     |       -        |                   |                 |
| Purchase.FK_product     | FOREIGN KEY     |       -        |                   |                 |
| Purchase.quantity       |                 |Низкая, среднняя| NOT NULL          |                 |
| Order.id                | PRIMARY KEY     |       -        |*UNIQUE + NOT NULL |*                |
| Order.FK_customer       | FOREIGN KEY     |       -        |                   |                 |
| Order.FK_status         | FOREIGN KEY     |       -        |                   |                 |
| Order.address           |                 | Высокая        | NOT NULL          |                 |
| Order.order_date        |                 | Высокая        | NOT NULL          |                 |
| Status.id               | PRIMARY KEY     |        -       |*UNIQUE + NOT NULL |*                |
| Status.name             |                 | Низкая         | UNIQUE, NOT NULL  |                 |

'*' Ограничения/индексы по умолчанию, накладываемые типом поля  
