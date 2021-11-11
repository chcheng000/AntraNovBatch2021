use NorthWind
go
select p.ProductName
from Products p inner join [Order Details] od
on p.ProductID = od.ProductID
inner join Orders o
on o.OrderID= od.OrderID
where o.ShippedDate > '11-10-1996'
go
select top(5) o.ShipPostalCode, count(o.ShippedDate) "Products Sold to"
from Orders o
where not o.ShipPostalCode is null
group by o.ShipPostalCode
order by count(o.ShippedDate) desc
go
select top(5) o.ShipPostalCode, count(o.ShippedDate) "Products Sold to"
from Orders o
where not o.ShipPostalCode is null
AND o.ShippedDate > '11-10-1996'
group by o.ShipPostalCode
order by count(o.ShippedDate) desc
go 
select o.ShipCity, o.ShipPostalCode, count(o.ShippedDate) "Products Sold"
from Orders o
where not o.ShipPostalCode is null
AND o.ShippedDate > '11-10-1996'
group by o.ShipCity, o.ShipPostalCode
order by count(o.ShippedDate) desc
go
select c.ContactName
from orders o inner join Customers c
on o.CustomerID = c.CustomerID
where o.OrderDate > '1-1-98'
order by o.OrderDate
go
select distinct c.ContactName, o.OrderDate
from orders o inner join Customers c
on o.CustomerID = c.CustomerID
where o.OrderDate = (
	select Max(innero.OrderDate)
	from orders innero
	where innero.CustomerID = o.CustomerID
)
go
select c.ContactName, sum(od.Quantity) "Number of Products Bought"
from orders o inner join customers c
on o.CustomerID = c.CustomerID
inner join [Order Details] od
on od.OrderID = o.OrderID
group by c.ContactName
go
select c.ContactName, sum(od.Quantity) "Number of Products Bought"
from orders o inner join customers c
on o.CustomerID = c.CustomerID
inner join [Order Details] od
on od.OrderID = o.OrderID
group by c.ContactName
having sum(od.Quantity) > 100
go
select distinct s.CompanyName "Supplier Company Name", sh.CompanyName "Shipping Company Name"
from Suppliers s inner join Products p
on s.SupplierID = p.SupplierID
inner join [Order Details] od
on od.ProductID = p.ProductID
inner join Orders o
on o.OrderID = od.OrderID
inner join Shippers sh
on sh.ShipperID = o.ShipVia
order by s.CompanyName
go
select distinct o.OrderDate, p.ProductName
from Products p inner join [Order Details] od
on p.ProductID = od.ProductID
inner join Orders o 
on o.OrderID = od.OrderID
go
select distinct e1.LastName, e1.FirstName, e2.LastName, e2.FirstName, e1.Title
from Employees e1, Employees e2
where e1.Title = e2.Title
and e1.LastName < e2.LastName
go
select e1.LastName, e1.FirstName, count(e1.lastName) "Number of Supervisee"
--Concat(e2.LastName, ' ', e2.FirstName) "Supervisee"
from Employees e1 cross join Employees e2
where e1.EmployeeID = e2.ReportsTo
group by e1.LastName, e1.FirstName
having count(e1.lastName) > 2
go
select distinct s.City, s.CompanyName, s.ContactName, 'Suppliers' "Type"
from Suppliers s 
union
select distinct c.City, c.CompanyName, c.ContactName, 'Customer' "Type"
from Customers c
go 
