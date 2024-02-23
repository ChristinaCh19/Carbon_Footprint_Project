CREATE DATABASE db_em;

USE db_em;

RENAME TABLE `carbon emission` TO carbtab;

SELECT * FROM carbtab;



-- Create a view of the profiles with the highest emissions (top 10%) -

CREATE VIEW v_top10 AS
SELECT * FROM carbtab
ORDER BY CarbonEmission DESC
LIMIT 1000;

SELECT * FROM v_top10;

SELECT MIN(CarbonEmission), MAX(CarbonEmission) FROM v_top10;

-- Create a view of the profiles with the lowest emissions (bottom 10%) --

CREATE VIEW v_bot10 AS
SELECT * FROM carbtab
ORDER BY CarbonEmission ASC
LIMIT 1000;

SELECT * FROM v_bot10;

SELECT MIN(CarbonEmission), MAX(CarbonEmission) FROM v_bot10;



-- Create a view showing the average emissions and the 90th percentile of carbon emissions --

CREATE TABLE t_avg_em (
ID int,
Avg_emissions int);

INSERT INTO t_avg_em (ID, Avg_emissions)
SELECT
1 AS ID,
AVG(CarbonEmission) AS Avg_emissions FROM carbtab;

SELECT * FROM t_avg_em;

CREATE TABLE t_lower_lim (
ID int,
Lower_limit_top10per_emissions int);

INSERT INTO t_lower_lim (ID, Lower_limit_top10per_emissions)
SELECT
1 AS ID,
MIN(CarbonEmission) AS Lower_limit_top10per_emissions FROM v_top10;

SELECT * FROM t_lower_lim;

CREATE VIEW v_avg_lowerlim AS
SELECT A.Avg_emissions, B.Lower_limit_top10per_emissions
FROM t_avg_em A
JOIN t_lower_lim B
ON A.ID = B.ID;

SELECT * FROM v_avg_lowerlim;


-- Calculate the percentage of each Heating Source for top 10% --

CREATE VIEW v_heat_cat_top10 AS
SELECT 
	`Heating Energy Source`, 
    COUNT(`Heating Energy Source`) AS Category_count,
    COUNT(`Heating Energy Source`)/(SELECT COUNT(`Heating Energy Source`) FROM v_top10)*100 AS Percentage
FROM v_top10
GROUP BY `Heating Energy Source`;

SELECT * FROM v_heat_cat_top10;

-- Calculate the percentage of each Heating Source for bottom 10% --

CREATE VIEW v_heat_cat_bot10 AS
SELECT 
	`Heating Energy Source`, 
    COUNT(`Heating Energy Source`) AS Category_count,
    COUNT(`Heating Energy Source`)/(SELECT COUNT(`Heating Energy Source`) FROM v_bot10)*100 AS Percentage
FROM v_bot10
GROUP BY `Heating Energy Source`;

SELECT * FROM v_heat_cat_top10;















