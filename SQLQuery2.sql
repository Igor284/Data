USE Northwind;

SELECT TOP 1 ProductName, UnitPrice
FROM Products
WHERE UnitPrice=(SELECT MAX(UnitPrice) FROM Products WHERE CategoryID=1)
ORDER BY UnitPrice DESC


SELECT 
ShipCity, OrderDate, ShippedDate
FROM Orders
WHERE DATEDIFF(day, OrderDate, ShippedDate) > 10
ORDER BY ShipCountry DESC


SELECT 
ContactName
FROM Customers as c
LEFT JOIN Orders as o
ON c.CustomerID = o.CustomerID
WHERE ShippedDate is NULL



WITH TotalData as(
  SELECT
  EmployeeID, 
  Count(*) TotalCount, 
  EmployeeCust.CustomerID 
  FROM dbo.Orders as TotalOrders
  CROSS APPLY
  (
    SELECT 
    CustomerID 
    FROM dbo.Orders as EmployeeOrders
    WHERE EmployeeOrders.EmployeeID = TotalOrders.EmployeeID
    GROUP BY CustomerID
  ) as EmployeeCust
  GROUP BY EmployeeID,
       EmployeeCust.CustomerID 
)
SELECT
Count(CustomerID) as CustomerIDCount
FROM TotalData
INNER JOIN (
  SELECT 
    MAX(TotalCount) as MaxCount 
    FROM TotalData
) as MaxCountData
  ON  TotalData.TotalCount = MaxCountData.MaxCount

  

-- 5
SELECT COUNT(ShipCity) as CountCity
FROM Orders 
WHERE EmployeeID = 1
AND year(OrderDate) = 1997
AND ShipCountry IN ('France')


-- 6
SELECT DISTINCT
ShipCountry
FROM Orders
GROUP BY ShipCountry,ShipCity
HAVING COUNT(OrderID) > 2


-- 7
SELECT
ProductID
FROM Products
WHERE ProductID IN(
  SELECT 
  ProductID
  FROM [Order Details]
  GROUP BY ProductID
  HAVING sum(Quantity) < 1000)


--8
SELECT 
ContactName
FROM Customers as c
INNER JOIN Orders as o
ON c.CustomerID = o.CustomerID
WHERE c.City NOT LIKE o.ShipCity

--9.1
-- Ќе уверен в правильности этого варианта
SELECT 
MaxData.CategoryName
FROM(
	SELECT TOP 1
	TotalData.CategoryName, TotalData.CompanyName, COUNT(*) as CompNameCount
	FROM(
	select distinct 
		s.CompanyName,c.CategoryName,p.ProductName
		from Products p
		inner join Categories c on c.CategoryID=p.CategoryID
		inner join Suppliers s on s.SupplierID=p.SupplierID
		inner join [Order Details] od on od.ProductID=p.ProductID
		inner join Orders o on o.OrderID=od.OrderID
		where YEAR(o.OrderDate) = 1997 
		and s.Fax  is not null
		--order by c.CategoryName
	) as TotalData
	GROUP BY TotalData.CategoryName, TotalData.CompanyName
	ORDER BY CompNameCount 
	DESC 
)as MaxData

--9.2
select DataCount.category_name from (
select  top 1
c.CategoryName as category_name, count(o.OrderId) as count_
from Products p
inner join Categories c on c.CategoryID=p.CategoryID
inner join Suppliers s on s.SupplierID=p.SupplierID
inner join [Order Details] od on od.ProductID=p.ProductID
inner join Orders o on o.OrderID=od.OrderID
where YEAR(o.OrderDate) = 1997 
and s.Fax  is not null
group by c.CategoryName
order by count_ desc
) as DataCount


--10 

select 
FirstName, LastName, SUM(od.Quantity)as count_
from Employees as e
join Orders as o on e.EmployeeID = o.EmployeeID
join [Order Details] as od on o.OrderID = od.OrderID
where year(o.OrderDate) = 1997
group by FirstName, LastName, od.Quantity
order by count_ desc




