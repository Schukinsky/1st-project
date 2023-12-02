## Концептуальная модель базы данных для интернет-магазина
### Сущности:

##### 1. Продукты (Products):

- product_id (Primary Key)
- name (название продукта)
- description (описание продукта)
- category_id (внешний ключ, связанный с таблицей Categories)
- manufacturer_id (внешний ключ, связанный с таблицей Manufacturers)
- supplier_id (внешний ключ, связанный с таблицей Suppliers)
- quantity (количество продукта)

##### 2. Категории продуктов (Categories):

- category_id (Primary Key)
- name (название категории)

##### 3. Цены (Prices):

- price_id (Primary Key)
- product_id (внешний ключ, связанный с таблицей Products)
- price (цена продукта)
- start_date (дата начала действия цены)
- end_date (дата окончания действия цены)

##### 4. Поставщики (Suppliers):

- supplier_id (Primary Key)
- name (название поставщика)
- contact_info (контактная информация)

##### 5. Производители (Manufacturers):

- manufacturer_id (Primary Key)
- name (название производителя)

##### 6. Покупатели (Customers):

- customer_id (Primary Key)
- name (имя покупателя)
- email (электронная почта покупателя)
- phone (контактный телефон)
- address (адрес доставки)

##### 7. Покупки (Purchases):

- purchase_id (Primary Key)
- customer_id (внешний ключ, связанный с таблицей Customers)
- product_id (внешний ключ, связанный с таблицей Products)
- quantity (количество купленных продуктов)
- purchase_date (дата покупки)

### Связи:

Products.category_id связан с Categories.category_id
Products.manufacturer_id связан с Manufacturers.manufacturer_id
Products.supplier_id связан с Suppliers.supplier_id
Prices.product_id связан с Products.product_id
Purchases.customer_id связан с Customers.customer_id
Purchases.product_id связан с Products.product_id

### Бизнес-задачи:

1. Отслеживание товара:

   База данных помогает отслеживать количество продуктов в наличии и предотвращать нехватку товаров.

2. Ценообразование:

   Система цен позволяет управлять ценами на продукты в разные периоды времени и анализировать, какие цены наиболее эффективны.

3. Анализ покупок:

   Используя данные о покупках, можно проводить анализ предпочтений покупателей и формировать стратегии маркетинга.

4. Управление поставками:

   Отслеживание поставщиков и связанных с ними данных помогает эффективно управлять поставками и поддерживать сотрудничество с надежными поставщиками.

5. Профили покупателей:

   Хранение данных о покупателях позволяет создавать персонализированные предложения, учитывая предпочтения каждого клиента.

### ER-диаграмма:

![](C:\Users\User\Documents\GitHub\1st-project\erd.drawio.png)
123
