 -- Question 1

SELECT CompanyName, ContactName
FROM Customers JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;

 -- Question 2

SELECT *
FROM Customers JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;


 -- Question 3

SELECT OrderDate, ProductID AS [Product Description], Quantity
FROM Orders JOIN [Order Details]
ON Orders.OrderID = [Order Details].OrderID
ORDER BY OrderDate;

-- Question 4

SELECT *
FROM Customers LEFT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;

-- Question 5

SELECT CompanyName, ContactName
FROM Orders CROSS JOIN Customers
ORDER BY CompanyName;

-- Question 9 

SELECT Shipcountry, Quantity
FROM Orders,[Order Details]
WHERE Orders.OrderID = [Order Details].OrderID;

-- Question 10 
/*Which one the following statements displays the following result set while using a correlation name?*/


SELECT Shipcountry, Quantity
FROM Orders JOIN [Order Details] AS ODetails
ON Orders.OrderID = ODetails.OrderID; 

