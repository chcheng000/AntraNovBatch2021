use NorthWind2
go

/* For Questions 1-3*/

/*begin try
	begin transaction
		declare @regID int
		declare @id int
		declare @terrID nvarchar(20)
		declare @lName nvarchar(20)
		declare @fName nvarchar(20)

		set @lName = 'Aragon'
		set @fName = 'King'
		set @regID = 5
		set @terrID = '00000'
		
		insert into Region (RegionID, RegionDescription) values (@regID, 'Middle Earth')
		insert into Territories values (@terrID, 'Gondor', @regID)
		insert into Employees (LastName, FirstName) values (@lName, @fName)

		set @id = (select EmployeeID from Employees where LastName = @lName AND FirstName = @fName)

		insert into EmployeeTerritories (EmployeeID, TerritoryID) values (@id, @terrID)

		update Territories
		set TerritoryDescription = 'Arnor'
		where TerritoryDescription = 'Gondor'

		delete from EmployeeTerritories where TerritoryID = @terrID
		delete from Employees where EmployeeID = @id
		delete from Territories where TerritoryID = @terrID
		delete from Region where RegionID = 5
		
	commit tran
end try
Begin catch 
	
	IF @@TRANCOUNT > 0
		rollback tran

	declare @ErrorMessage nvarchar(4000)
	declare @ErrorSeverity int;
	declare @ErrorState int;

	select
		@ErrorMessage = ERROR_MESSAGE(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE();
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
end catch


*/

/* for Question 4 & 5*/

--if exists (select * from sys.views where name ='view_product_order_Cheng')
--drop view view_product_order_Cheng
--go

--create view view_product_order_Cheng
--as 
--select p.productID, p.ProductName, sum(od.quantity) "Total Products Ordered"
--from Products p, [Order Details] od
--where p.ProductID = od.ProductID
--group by p.ProductID, p.ProductName
--go
--select * from view_product_order_Cheng
--go
--if exists (select * from sys.procedures where name = 'sp_product_order_quantity_Cheng')
--begin
--	drop procedure dbo.sp_product_order_quantity_Cheng
--end 
--go

--create proc sp_product_order_quantity_Cheng
--@prodID int
--as
--begin
--	return (select vw.[Total Products Ordered]
--		from view_product_order_Cheng vw
--		where @prodID = vw.ProductID
--	)
--	/* -- If proc needs to be independent of previous view
--	return (select sum(od.quantity) "Total Products Ordered"
--		from Products p, [Order Details] od
--		where p.ProductID = od.ProductID
--		AND p.productID = @prodID
--		group by p.ProductID, p.ProductName
--	)
--	*/
--end
--go

--declare @productSoldByProdID smallint
--exec @productSoldByProdID = sp_product_order_quantity_Cheng 23
--print @productSoldByProdID

--drop procedure dbo.sp_product_order_quantity_Cheng
--drop view view_product_order_Cheng
--go 

-- Question 6
--drop procedure if exists dbo.sp_product_order_city_Cheng
--go

--create proc sp_product_order_city_Cheng
--@cityName nvarchar(15)
--as
--begin
--	select top (5) p.ProductName, sum(od.quantity) "Total Products Ordered"
--	from Products p inner join [Order Details] od
--	on p.ProductID = od.ProductID inner join Orders o
--	on od.OrderID = o.OrderID
--	where o.ShipCity = @cityName
--	group by p.ProductName
--end
--go

--exec sp_product_order_city_Cheng 'Lyon'
--go

--drop procedure sp_product_order_city_Cheng
--go

-- Questions 7
--drop proc if exists sp_move_employees_Cheng
--go
--create proc sp_move_employees_Cheng
--as
--begin
--	begin tran
--		-- if an employee found in territory of Troy
--		if exists (
--			select e.EmployeeID
--			from Employees e inner join EmployeeTerritories et
--			on e.EmployeeID = et.EmployeeID inner join
--			Territories t on t.TerritoryID = et.TerritoryID
--			where t.TerritoryDescription = 'Troy'
--		)
--		begin
--			declare @TerrID nvarchar(20),
--			@RegID int,
--			@oldTerrID nvarchar(20)
--			select @TerrID = max(TerritoryID) + 1 from Territories
--			select @RegID = RegionID from Region 
--				where RegionDescription = 'Northern'
--			select @oldTerrID = TerritoryID from Territories
--				where TerritoryDescription = 'Troy'

--			if not exists (
--				select * from Territories t
--				where t.TerritoryDescription = 'Stevens Point'
--			)
--			Begin -- inserting Stevens Point into Terrorities
--				insert into Territories values (@TerrID, 'Stevens Point', @RegID)
--			End
		
--			-- start of while loop declarations
--			declare @MaxIterator int,
--			@Iterator int
		

--			create table #TallyTable (Iterator int identity(1,1), EmpID int)

--			insert into #TallyTable (EmpID)
--			select distinct e.EmployeeID
--			from Employees e inner join EmployeeTerritories et
--			on e.EmployeeID = et.EmployeeID inner join
--			Territories t on t.TerritoryID = et.TerritoryID
--			where t.TerritoryDescription = 'Troy'

--			set @Iterator = 1
--			select @MaxIterator = max(Iterator) from #TallyTable
		
--			while @Iterator <= @MaxIterator
--			begin
--				declare @MovingEmpID int

--				select @MovingEmpID =  EmpID from #TallyTable 
--				where Iterator = @Iterator

--				update EmployeeTerritories
--				set TerritoryID = replace(TerritoryID, @oldTerrID, @TerrID)
--				where EmployeeID = @MovingEmpID
			
--				set @Iterator = @Iterator + 1;
--			end
--			select * from Territories t inner join EmployeeTerritories et
--			on t.TerritoryID = et.TerritoryID order by EmployeeID

--		end
--		-- Nothing happens if no employee found in territory Troy
--	commit tran
--end

--drop proc sp_move_employees_Cheng

-- Question 8
--drop trigger if exists after_update_if_100_stevens_point_emp_move_to_troy
--go

--create trigger after_update_if_100_stevens_point_emp_move_to_troy 
--on EmployeeTerritories
--For update
--as 
--declare @EmpCountOnSP int,
--@FromTerrDescpt nchar(50),
--@ToTerrDescpt nchar(50)

---- variables declared for testing purposes
--set @FromTerrDescpt = 'Stevens Point'
--set @ToTerrDescpt = 'Troy'
---- change back to Stevens Point -> Troy after test

--select @EmpCountOnSP = count(et.EmployeeID)
--from EmployeeTerritories et inner join Territories t
--on et.TerritoryID = t.TerritoryID
--where t.TerritoryDescription = @FromTerrDescpt

--If @EmpCountOnSP >= 100
--begin
--	print 'entered trigger'
--	declare @StevensPointTerrID nvarchar(20),
--	@TroyTerrID nvarchar(20)
--	select @StevensPointTerrID = TerritoryID from Territories
--		where TerritoryDescription = @FromTerrDescpt
--	select @TroyTerrID = TerritoryID from Territories
--		where TerritoryDescription = @ToTerrDescpt

--	-- start of while loop declarations
--	declare @MaxIterator int,
--	@Iterator int
		
--	create table #TallyTable (Iterator int identity(1,1), EmpID int)

--	insert into #TallyTable (EmpID)
--	select distinct e.EmployeeID
--	from Employees e inner join EmployeeTerritories et
--	on e.EmployeeID = et.EmployeeID inner join
--	Territories t on t.TerritoryID = et.TerritoryID
--	where t.TerritoryDescription = @FromTerrDescpt

--	set @Iterator = 1
--	select @MaxIterator = max(Iterator) from #TallyTable
		
--	while @Iterator <= @MaxIterator
--	begin
--		declare @MovingEmpID int

--		select @MovingEmpID =  EmpID from #TallyTable 
--		where Iterator = @Iterator

--		update EmployeeTerritories
--		set TerritoryID = replace(TerritoryID, @StevensPointTerrID, @TroyTerrID)
--		where EmployeeID = @MovingEmpID
			
--		set @Iterator = @Iterator + 1;
--	end
--end

--drop trigger after_update_if_100_stevens_point_emp_move_to_troy

--Question 9
--drop table if exists people_Cheng
--drop table if exists city_Cheng
--create table city_Cheng(ID int primary key identity(1,1), 
--	City varchar(20))
--insert into city_Cheng values
--	('Seattle'),
--	('Green Bay')

--create table people_Cheng (ID int primary key identity(1,1), 
--	Name varchar(20), 
--	City int foreign key references city_Cheng(ID))
--insert into people_Cheng values
--	('Aaron Rodgers', 2),
--	('Russell Wilson', 1),
--	('Jody Nelson', 2)

--select p.Name, c.City from people_Cheng p inner join city_Cheng c
--	on p.City = c.ID

--begin try
--	begin transaction
--		if exists (select * 
--			from people_Cheng p inner join city_Cheng c
--			on p.City = c.ID
--			where c.City = 'Seattle')
--			update city_Cheng
--			set City = 'Madison'
--			where City = 'Seattle'
--	commit tran
--end try
--begin catch
--	IF @@TRANCOUNT > 0
--		rollback tran

--	declare @ErrorMessage nvarchar(4000),
--	@ErrorSeverity int,
--	@ErrorState int

--	select
--		@ErrorMessage = ERROR_MESSAGE(),
--		@ErrorSeverity = ERROR_SEVERITY(),
--		@ErrorState = ERROR_STATE()

--	Raiserror(@ErrorMessage, @ErrorSeverity, @ErrorState)
--end  catch

--select p.Name, c.City from people_Cheng p inner join city_Cheng c
--on p.City = c.ID
--go

--drop view if exists Packers_Cheng
--go

--create view Packers_Cheng 
--as
--select p.Name
--from people_Cheng p inner join city_Cheng c
--on p.City = c.id
--where c.City = 'Green Bay'
--go

--select * from Packers_Cheng

--drop view Packers_Cheng
--drop table people_Cheng
--drop table city_Cheng

--Question 10

--select * from Employees
--go

--drop proc if exists sp_birthday_employees_Cheng
--go

--create proc sp_birthday_employees_Cheng
--as
--begin
--	if not exists (select * from sys.tables where name = 'birthday_employees_Cheng')
--	begin
--		create table birthday_employees_Cheng (fullName varchar(50))
--		insert into birthday_employees_Cheng (fullName)
--		select Concat(e.FirstName, ' ',e.LastName)
--		from Employees e
--		where Month(e.BirthDate) = 2
--	end 
--end
--go

--exec sp_birthday_employees_Cheng

--select * from birthday_employees_Cheng

--select * from Employees

--drop table birthday_employees_Cheng
--drop proc sp_birthday_employees_Cheng

-- Question 11

--drop proc if exists sp_Cheng_1
--go

--create proc sp_Cheng_1
--as
--begin
--	select c.city
--	from Products p inner join [Order Details] od
--	on od.ProductID	= p.ProductID inner join Orders o
--	on o.OrderID = od.OrderID right join Customers c
--	on c.CustomerID = o.CustomerID
--	group by c.CustomerID, c.City
--	having count(p.ProductName) <= 1	
--end
--go

--drop proc if exists sp_Cheng_2
--go

--create proc sp_Cheng_2
--as
--begin
--	select c.city
--	from Customers c left join (
--		select p.ProductID, o.CustomerID
--		from Products p inner join [Order Details] od
--		on od.ProductID = p.ProductID inner join Orders o
--		on o.OrderID = od.OrderID
--	) dt
--	on c.CustomerID = dt.CustomerID
--	group by c.CustomerID, c.City
--	having count(dt.ProductID) <= 1
--end

--exec sp_Cheng_1
--exec sp_Cheng_2

--drop proc sp_Cheng_1
--drop proc sp_Cheng_2

