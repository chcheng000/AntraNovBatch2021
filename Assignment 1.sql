use AdventureWorks2019
GO
select p.ProductID, p.Name, p.Color, p.ListPrice
from Production.Product p
GO
select p.ProductID, p.Name, p.Color, p.ListPrice
from Production.Product p
where p.ListPrice = 0
GO
select p.ProductID, p.Name, p.Color, p.ListPrice
from Production.Product p
where p.Color is null
GO
select p.ProductID, p.Name, p.Color, p.ListPrice
from Production.Product p
where not p.Color is null
GO
select p.ProductID, p.Name, p.Color, p.ListPrice
from Production.Product p
where not p.Color is null AND p.ListPrice > 0
Go
select CONCAT(p.name,' ',p.color) "Name_Color"
from Production.Product p
where not p.Color is null
GO
select CONCAT('NAME: ', p.name, ' -- COLOR: ', p.color) "Name And Color"
from Production.Product p
where not p.Color is null
Go
select p.ProductID, p.Name
from Production.Product p
where p.ProductID between 400 and 500
go
select p.ProductID, p.Name, p.Color
from Production.Product p
where p.Color = 'Black' or p.Color = 'blue'
Go
select p.Name "Products"
from Production.Product p
where p.Name like 'S%'
Go
select Name, ListPrice
from Production.Product
where name like 'Seat%' or name like 'Short%' AND not Size = 'S' AND not size = 'XL'
order by Name
Go
select Name, ListPrice
from Production.Product
where name like 'A%' or name like 'S%'
order by Name
Go
select p.ProductID, p.Name, p.ProductNumber, p.MakeFlag, p.FinishedGoodsFlag, p.Color,
p.SafetyStockLevel, p.ReorderPoint, p.StandardCost, p.ListPrice,
p.SizeUnitMeasureCode, p.WeightUnitMeasureCode, p.Weight, p.DaysToManufacture
,p.ProductLine, p.Class, p.Style, p.ProductSubcategoryID, p.ProductModelID, p.SellStartDate,
p.SellEndDate, p.DiscontinuedDate, p.rowguid, p.ModifiedDate
from Production.Product p
where name like 'SPO%' and not name like 'SPO%K%'
Go
select distinct color
from Production.Product
where not color is null
order by color desc
go
select distinct ProductSubcategoryID, Color
from Production.Product
where not ProductSubcategoryID is null AND not Color is null
order by ProductSubcategoryID
go 
select ProductSubCategoryID, LEFT(Name, 35) AS Name, Color, ListPrice
from Production.Product
where not Color IN ('Red', 'Black')
OR ListPrice between 1000 and 2000
AND ProductSubcategoryID = 1
Order by ProductID
go 
select ProductID, StandardCost, ProductSubcategoryID, Name, Color, ListPrice
from Production.Product
where ProductSubcategoryID < 15
AND not ProductSubcategoryID is null
AND ListPrice between 539.99 and 1700.99
AND (ListPrice like '%.99' OR ListPrice like '%.50')
order by ProductSubcategoryID desc
