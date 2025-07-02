------------------------------ TRANSACTIONS ---------------------------------------------

create table Employee(
employee_id int,
employee_name varchar(255),
salary int,
department varchar(255)
);

drop table balance;

create table balance(
id int not null unique,
name varchar(255),
balance int check(balance >= 0)
);

insert into balance values (1, 'Bob', 200), (2, 'Alice', 0);

begin try
begin transaction
update balance set balance = balance - 200 where name = 'Alice';
update balance set balance = balance + 200 where name = 'Bob';
commit;
end try
begin catch
rollback;
print 'Error: ' + ERROR_MESSAGE()
end catch

select * from balance;




------------------------------------- WHILE LOOP ------------------------------------

--WHILE LOOP (treat begin end as {} like in other languages)

declare @counter int = 1;
while @counter < 5
begin
print 'Counter: ' + cast(@counter as varchar)
set @counter = @counter + 1
end






--------------------------------------- IF/ELSE -----------------------------------------

if 1 = 2-1
begin
print 'True'
end
else
begin
print 'False'
end





------------------------------------ VIEWS ----------------------------------------------------
-- stored sql query

CREATE VIEW view_name AS
SELECT *
FROM balance
WHERE name = 'Bob';

select * from view_name;





------------------------------------ FUNCTIONS ------------------------------------------------

drop function sum;
create function sumValues(@value1 int, @value2 int)
returns int as
begin
return @value1+@value2
end




---------------------------------------------------------------------------------------------
--print dbo.sumValues(1,2);

---- permissions ----
--CREATE LOGIN TestLogin WITH PASSWORD = 'Test@1234';

--USE kartikey;  -- Switch to your target database
--GO
--CREATE USER TestUser FOR LOGIN TestLogin;

---- Read-only access
--ALTER ROLE db_datareader ADD MEMBER TestUser;

---- Write access
--ALTER ROLE db_datawriter ADD MEMBER TestUser;




-------------------------------------- Triggers ---------------------------------------------

drop table if exists employee;
create table employee(
id int,
name varchar(255),
salary int
);

drop table if exists employeeAudit;
create table employeeAudit(
id int,
name varchar(255),
salary int,
action varchar(255)
);

create trigger employee_auto_audit
on employee
after insert
as
begin
insert into employeeAudit
select id, name, salary, 'INSERT' as action
from inserted;
end;

insert into employee values(1, 'Bob', 10000);

select * from employee;
select * from employeeAudit;




-------------------------------------- Recursive CTE ----------------------------------------------

WITH cte (num) AS (
    -- Anchor member
    SELECT 1
    UNION ALL
    -- Recursive member
    SELECT num + 1 FROM cte WHERE num < 5
)
SELECT * FROM cte;

with cte as (
select 1 as searches, 2 as num_users
union 
select 2 as searches, 3 as num_users
),

gen (searches, num_users, cnt) as (
select searches, num_users, 1 as cnt from cte
union all
select searches, num_users, (cnt+1) as cnt from gen where cnt < num_users
)
select * from gen;




------------------------------------  TIMESTAMP/ROWVERSION  -----------------------------------------------

-- Definition:
-- ROWVERSION (or TIMESTAMP) is a special data type in SQL Server that auto-generates a unique binary value 
-- each time a row is inserted or updated. It's used to detect changes to rows, not to store date/time.

-- Use Case:
-- Helps detect if a row was modified between read and write — useful in optimistic concurrency scenarios.

-- Step 1: Create a table with a ROWVERSION column
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    stock_quantity INT,
    last_updated ROWVERSION  -- Automatically updated on insert/update -- can also use TIMESTAMP
);

-- Step 2: Insert a product
INSERT INTO products (product_id, product_name, stock_quantity)
VALUES (1, 'Laptop', 50);

-- Step 3: Suppose you read the row and got last_updated = 0x00000000000007D1

-- Step 4: Try to update only if the row hasn't been changed by someone else
UPDATE products
SET stock_quantity = 45
WHERE product_id = 1
AND last_updated = 0x0000000000000FA3;

SELECT * FROM products;

-- If another user modified the row after you read it, the last_updated value will have changed,
-- and this update won't affect any rows — helping you detect conflicts.




-------------------------------------------- DATETIME ---------------------------------------------------------

DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
    employee_id INT,
    employee_name VARCHAR(255),
    status VARCHAR(255),
    ts DATETIME
);

INSERT INTO employee VALUES 
(1, 'Raj', 'In', CAST('2025-07-01 00:00:00' AS DATETIME)),
(1, 'Raj', 'Out', CAST('2025-07-01 01:00:00' AS DATETIME)),
(1, 'Raj', 'In', CAST('2025-07-01 02:00:00' AS DATETIME)),
(2, 'Raman', 'In', CAST('2025-07-01 01:00:00' AS DATETIME)),
(2, 'Raman', 'Out', CAST('2025-07-01 04:00:00' AS DATETIME));

select employee_id
from employee
group by employee_id
having count(*)%2 <> 0;



------------------------------- REPLICATE KEYWORD -----------------------------------------
-- PRINT BELOW
--* * * 
--* *
--*

DECLARE @COUNTER INT = 20;

WHILE @COUNTER > 0
BEGIN
    PRINT REPLICATE('* ', @COUNTER);
    SET @COUNTER = @COUNTER - 1;
END;




------------------------------- Date Functions -----------------------------------------------
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











