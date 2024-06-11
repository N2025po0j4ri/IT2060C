
-- Question 1

SELECT * 
FROM [Order Details];

-- Question 2

SELECT OrderID, CustomerID, OrderDate, Freight
FROM Orders
ORDER BY Freight DESC;

-- Question 3

SELECT OrderID, CustomerID, OrderDate
FROM Orders
WHERE OrderDate BETWEEN '1997-12-31' AND '1998-05-04'
ORDER BY OrderDate;


-- Question 4

SELECT OrderID, UnitPrice, Quantity,
UnitPrice * Quantity AS OrderTotal
From [Order Details]
ORDER BY OrderTotal;

-- Question 5

SELECT OrderID AS ID, UnitPrice AS [PRICE PER], Quantity
From [Order Details];

-- Question 6

SELECT *
FROM Orders
WHERE ShippedDate is NULL;

-- Question 7 

SELECT DISTINCT Country
FROM Customers
ORDER BY Country;

-- Question 8

SELECT FirstName + ' ' + LastName
AS [Full Name]
FROM Employees;

-- Question 9
SELECT ShipCity, ShipCountry
FROM Orders
WHERE ShipCountry Like '%A';

-- Question 10
SELECT TOP 5 OrderID , OrderDate,
GETDATE() AS 'Today''s Date',
DATEDIFF (day, OrderDate, GETDATE()) AS [Order's Age]
FROM Orders;
