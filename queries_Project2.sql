--DROP TABLE 
drop view MASTER_TABLE;
DROP TABLE barrel_price;
DROP TABLE inflation;
DROP TABLE indice;
DROP TABLE gdp;


-- Create tables for raw data to be loaded into

--- BARREL PRICE
CREATE TABLE barrel_price (
id serial PRIMARY KEY,
year int,
month int,
barrel_avg_price FLOAT
);

--- Check information from table
SELECT * FROM barrel_price;

--- INFLATION

CREATE TABLE inflation (
index serial PRIMARY KEY,
Year int,
Inflation FLOAT
);

SELECT * FROM inflation;

--- INPC (CONSUMER PRICE INDEX)

CREATE TABLE indice (
id serial PRIMARY KEY,
period VARCHAR,
INPC FLOAT,
year int,
month int
);

SELECT * FROM indice;

--- GDP
CREATE TABLE gdp (
id serial  PRIMARY KEY,
gdp FLOAT,
year int,
quarter int,
month int	
);

SELECT * FROM gdp



-- Joins tables - CREATE SINGLE MASTER TABLE - VIEW
CREATE VIEW MASTER_TABLE as 
SELECT i.year, quarter, i.month, i.period, inpc, barrel_avg_price as barrelprice , inflation, gdp
FROM indice i
JOIN barrel_price bp
ON i.year = bp.year and i.month=bp.month
join inflation inf
on i.year = inf.year
join gdp
on i.year = gdp.year and i.month=gdp.month

select * from MASTER_TABLE;

-----
--ANALYSIS SECTION:

--1. Inflation vs INPC
select year, month, round( CAST(avg(inpc) as numeric), 2) as av_inpc , round( CAST(avg(inflation) as numeric), 2) as av_inf from MASTER_TABLE
where year >= '2010'
group by year, month 
order by year, month asc;

--2. INPC vs Barrel Price
select year, round( CAST(avg(inflation) as numeric), 2) as av_inpc , round( CAST(avg(barrelprice) as numeric), 2) as av_bp from MASTER_TABLE
where year >= '2000'
group by year 
order by year asc;


--3. GDP vs Barrel Price
-- select year, month, round( CAST(avg("GDP Index") as numeric), 2) as av_gdp , round( CAST(avg("barrel price") as numeric), 2) as av_bp from MASTER_TABLE
select year, quarter, month, round( CAST(min(gdp) as numeric), 2) as av_gdp , round( CAST(min(barrelprice) as numeric), 2) as av_bp from MASTER_TABLE
where year >= '2000' 
group by quarter, year, month
order by year asc;






