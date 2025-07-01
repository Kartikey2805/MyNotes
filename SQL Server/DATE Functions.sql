select current_date as dt_;
select getdate() as dt_;
select sysdatetime() as dt_;
select CURRENT_TIMESTAMP as dt_;

SELECT DATEADD(DAY, -5, '2025-06-30'); -- 2025-07-05
SELECT DATEDIFF(DAY, '2025-06-01', '2025-06-30'); -- 29

SELECT DATEPART(MONTH, '2025-06-30'); -- 2025
SELECT DATEPART(WEEKDAY, '2025-06-30'); -- 2 (Monday by default)
SELECT MONTH('2025-06-30');
SELECT DATETRUNC(YEAR, '2025-06-30');

SELECT DATENAME(MONTH, '2025-06-30'); -- June
SELECT DATENAME(WEEKDAY, '2025-06-30'); -- Monday

SELECT FORMAT(GETDATE(), 'MM/dd/yyyy');

