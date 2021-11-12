use NorthWind
go
/*top 3 products from everycity which were sold maximum */

select *
from (
	select DENSE_RANK() over(partition by o.shipCity 
	order by dt.quantity desc) "Ranking", 
	o.ShipCity, dt.ProductName, dt.quantity
	from Orders o inner join (
		select p.ProductName, od.OrderID, od.Quantity
		from [Order Details] od inner join Products p
		on od.ProductID = p.ProductID) dt
	on dt.OrderID = o.OrderID) dt2
where dt2.Ranking <= 3

/* Given the following table:
	City		Distance
	A			80
	B			150
	C			180	
	D			220

	Result set should be:
	City		Distance
	B-A			70
	C-B			30
	D-C			40
*/
declare @DistanceCity table (id int identity(1,1), City varchar(20), Distance int)

insert into @DistanceCity
values
('A', 80) ,
('B', 150) ,
('C', 180) ,
('D', 220) 


select Concat(d.City, '-', dt.City) "City" , d.Distance - ISNULL(dt.distance, null) "Distance"
from @DistanceCity d
	outer apply (
		select top (1) d2.distance, d2.City
		from @DistanceCity d2
		where d2.id < d.id
		order by id desc
	) dt
where not (d.Distance - dt.Distance) is null


/* Employee [give any values to the rows]
	(query should be made with assumption of hundreds of records)

	ID		NAME		Gender
	1		abc			0
	2		xyz			1
	...

	Update the table such that all 0 -> and all 1 -> 0
*/

declare @Employee table (id int identity(1,1), name varchar(20), Gender int)

insert into @Employee
values 
('A1', 1) ,
('B2', 0) ,
('C3', 0) ,
('D4', 1) ,
('E5', 0) ,
('F6', 1) ,
('Z9', 1) ,
('X8', 0) ,
('K5', 0) ,
('L0', 0) ,
('U2', 1)

select * from @Employee

update @Employee
set Gender = case when Gender = 1 then 0 else 1 end

select * from @Employee


/* Employee [give any values to the rows]
	(query should be made with assumption of hundreds of records)

	NAME	Gender
	abc		1
	abc		1
	xyz		0
	xyz		0
	xyz		0
	
	...

	Delete all duplicate records
*/

declare @Employee2 table (name varchar(20), Gender int)

insert  @Employee2
select e.name, e.Gender
from @Employee e
Union all
select e1.name, e1.Gender
from @Employee e1
Union all
select e12.name, e12.Gender
from @Employee e12

insert @Employee2
select *
from @Employee2
Union all
select *
from @Employee2

select * 
from @Employee2;

with cteEmployee2 as (
	select name, gender, 
	ROW_NUMBER() over(partition by name, gender 
	order by name, gender) "row1"
	from @Employee2
)
delete from cteEmployee2 where row1 > 1

select * from @Employee2