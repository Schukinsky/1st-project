-- 1. Создаем таблицу  statistic в схеме homework7:
CREATE TABLE homework7.statistic(
player_name VARCHAR(100) NOT NULL,
player_id INT NOT NULL,
year_game SMALLINT NOT NULL CHECK (year_game > 0),
points DECIMAL(12,2) CHECK (points >= 0),
PRIMARY KEY (player_name,year_game)
);
-- 2. Наполняем таблицу homework7.statistic данными:
INSERT INTO homework7.statistic(player_name, player_id, year_game, points) VALUES 
('Mike',1,2018,18), ('Jack',2,2018,14), ('Jackie',3,2018,30), ('Jet',4,2018,30), ('Luke',1,2019,16), ('Mike',2,2019,14), ('Jack',3,2019,15), ('Jackie',4,2019,28), ('Jet',5,2019,25), ('Luke',1,2020,19), ('Mike',2,2020,17), ('Jack',3,2020,18), ('Jackie',4,2020,29), ('Jet',5,2020,27); 

-- 3. Запрос суммы очков с группировкой и сортировкой по годам:
SELECT  
year_game AS ГОД,
SUM(points) AS СУММА_ОЧКОВ
FROM homework7.statistic   GROUP BY ROLLUP(year_game) ORDER BY year_game;
-- дополнительно ROLLUP выводит сумму

-- 4. Запрос суммы очков с группировкой и сортировкой по годам с использованием CTE:
WITH cte_table AS(
	SELECT
	year_game,
	SUM(points) AS sum
	FROM
	homework7.statistic
	GROUP BY
	year_game
	)
SELECT year_game AS ГОД, sum AS СУММА_ОЧКОВ FROM cte_table ORDER BY year_game;

-- 5. Используя функцию LAG выводим кол-во очков по всем игрокам за текущий год и за предыдущий:
WITH cte_table AS(
	SELECT
	year_game,
	SUM(points) AS sum
	FROM
	homework7.statistic
	GROUP BY
	year_game
	)
SELECT year_game AS ГОД, sum AS СУММА_ТЕКУЩИЙ_ГОД, LAG (sum) OVER (ORDER BY year_game) AS СУММА_ПРЕД_ГОД FROM cte_table ORDER BY year_game;