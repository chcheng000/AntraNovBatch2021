use AdventureWorks2019
go
select count(1) "Total Number of Products"
from Production.Product
go
select count(1) "Total Number of Products with sub Category"
from Production.Product
where not ProductSubcategoryID is null
go
select ProductSubcategoryID, count(ProductSubcategoryID) "CountedProducts"
from Production.Product
where not ProductSubcategoryID is null
group by ProductSubcategoryID
go
select count(1) "Total Number of Products without sub Category"
from Production.Product
where ProductSubcategoryID is null
go
select sum(p.Quantity) "Sum of Quantity"
from Production.ProductInventory p
go
select p.ProductID, sum(p.Quantity) "TheSum"
from Production.ProductInventory p
where LocationID = 40
group by p.ProductID
Having SUM(p.Quantity) < 100
go
select p.Shelf, p.ProductID, sum(p.Quantity) "TheSum"
from Production.ProductInventory p
where LocationID = 40
group by p.Shelf, p.ProductID
having SUM(p.Quantity) < 100
go
select ProductID, AVG(Quantity) "TheAvg"
from Production.ProductInventory 
where LocationID = 10
group by ProductID
go
select ProductID, Shelf, AVG(Quantity) "TheAvg"
from Production.ProductInventory
group by ProductID, Shelf
go
select Color, Class, count(ProductID) "TheCount", AVG(ListPrice) "TheAvg"
from Production.Product
where not (Color is null or Class is null)
group by Color, Class
go
select c.Name "Country", s.Name "Province"
from Person.CountryRegion c join Person.StateProvince s
on c.CountryRegionCode = s.CountryRegionCode
go
select c.Name "Country", s.Name "Province"
from Person.CountryRegion c join Person.StateProvince s
on c.CountryRegionCode = s.CountryRegionCode
where c.Name = 'Germany' or c.Name = 'Canada'
