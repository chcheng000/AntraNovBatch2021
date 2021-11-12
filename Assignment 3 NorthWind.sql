use NorthWind
go
-- List all cities that have both employees and customers
select distinct e.City
from Employees e inner join Customers c
on e.City = c.City

/* List all cities that have Customers but no Employee
	using sub-query
	without using sub-query
*/
-- using sub-query
select distinct c.city
from Customers c
where c.City not in (
	select distinct e.city
	from Employees e
)

-- without sub-query
select distinct c.City
from Customers c left join Employees e
on e.City = c.City 
where e.EmployeeID is null


/* List all products and their total order quantities throughout 
all orders. 
*/
select p.ProductName, (
	select sum(od.Quantity) 
	from [Order Details] od
	where od.ProductID = p.ProductID
) "Total Order Quantity"
from Products p

-- List all Customer Cities and total products ordered by that city
select c.City, (
	select count(od.quantity)
	from [Order Details] od, Orders o
	where od.OrderID = o.OrderID
	AND o.ShipCity = c.City
) "Total Products"
from Customers c


/* List all Customer Cities that have at least two customers
	using Union
	using sub-query without union
*/
-- using Union


-- using sub-query without union
select distinct c1.City
from Customers c1
where (
	select count(c2.contactName)
	from Customers c2
	where c1.City = c2.city
	AND c1.ContactName != c2.ContactName
) >= 2


/* List all customer Cities that have ordered at least two different 
kinds of products 
*/
select distinct c.City
from Orders o, Customers c
where (
	select count(od.productID)
	from [Order Details] od
	where od.OrderID = o.OrderID
) >= 2
AND o.ShipCity = c.City

/* List all Customers who have ordered products, but have the 
'ship city' on the order different from their own customer cities
*/
select distinct c.ContactName
from Orders o, Customers c
where o.ShipCity != c.City
AND o.CustomerID = c.CustomerID


/* List 5 most popular products, their average price, and the
customer city that ordered most quantity of it
*/
select dt2.rank1, p.ProductName, dt2.UnitPrice, dt2.City
from Products p inner join (
	select DENSE_RANK () Over(partition by c.city 
			order by dt.Total desc) "rank1", c.CustomerID, dt.ProductID, c.City, dt.UnitPrice
	from Customers c inner join (
		select sum(od.quantity) "Total", o.CustomerID, od.ProductID, od.UnitPrice
		from Orders o inner join [Order Details] od
		on od.OrderID = o.OrderID
		group by o.CustomerID, od.ProductID, od.UnitPrice
	) dt
	on dt.CustomerID = c.CustomerID
) dt2
on p.ProductID = dt2.ProductID
where dt2.rank1 <= 5


/* List all cities that have never ordered something but we have
employees there
	using sub-query
	not using sub-query
*/
-- using sub-query
select e.City
from Employees e
where e.City NOT IN (
	select o.ShipCity
	from Orders o
)

-- not using sub-query
select e.City
from Employees e left join Orders o
on e.City = o.ShipCity
where o.ShipCity is null


/* List one city, if exists, that is the city from where the 
employee sold most orders (not the product quantity) is, and also
the city of most total quantity of products ordered from
(tip: join sub-query)
*/


/* How do you remove duplicates record of a table? 
	Delete with JOIN
	Delete [T1]
	from [Table Name][T1] 
	inner join [same table name][T2]
	where T1.[primary key/unique id] < T2.[primary key/unique id]
	AND T1.[column] = T2.[column]
	-- for all columns
*/

/* Sample table to be used for solutions below -
	Employee (empid integer, mngrid integer, deptid integer,
		salary integer)
	Dept (deptid integer, deptname text)

	Find employees who do not manage anybody

	use cte recursion and using max() on highest number in hierarchy

	with cteEMPHierarchy
	as (
		select *, 1"lvl" 
		from Employee
		where mngrid is null
		Union all
		select *, cte.lvl+1
		from Employees e inner join cteEMPHierarchy cte
		on e.mngrid = cte.empid
	)
	select *
	from cteEMPHierarchy
	having max(cte.lvl) = cte.mgnrid
*/

/* Find departments that have maximum number of employees. 
(Solution should consider scenario having more than 1 departments 
that have maximum number of employees) Result should have -
	deptname, count of employees sorted by deptname

	select dt.deptname, dt.'emp Count' "count of employees sorted by deptname
	from (
		select dense_rank() over(partition by d.deptname group by dt.totalemp desc), d.deptname, 'emp Count'
		from deptname d inner join (
			select count(e.empid) "emp Count"
			from Employees e
			group by e.deptid)
			on e.deptid = d.deptid 
		) dt
		group by d.deptname, 'emp Count'
	)
	having max(dt.'emp Count') = dt.'emp Count'
*/

/* Find top 3 employees (salary based) in every department. 
Result should have deptname, empid, salary sorted by deptname and
then employee with high to low salary.

select dt2.deptname, dt2.empid, dt2.salary
from (
	select DENSE_RANK() over(partition by e.deptid
	order by e.salary desc) "Salary sorted by deptname", 
	e.empid, e.salary, d.deptname
	from Dept d inner join Employees e
	on d.deptid = e.deptid) dt2
where dt2.Ranking <= 3
*/

