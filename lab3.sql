
-- Lab 3 - Question 1

SELECT CompanyName, ContactName
FROM Customers JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;

-- Lab 3 - Question 2

SELECT *
FROM Customers JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;

-- Lab 3 - Question 3

SELECT OrderDate, ProductID AS [Product Description], Quantity
FROM Orders JOIN [Order Details]
ON Orders.OrderID = [Order Details].OrderID
ORDER BY OrderDate;

-- Lab 3 - Question 4

SELECT *
FROM Customers LEFT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;


-- Lab 3 - Question 5

SELECT CompanyName, ContactName
FROM Orders CROSS JOIN Customers
ORDER BY CompanyName;

-- Lab 3 - Question 9

SELECT Shipcountry, Quantity
FROM Orders,[Order Details]
WHERE Orders.OrderID = [Order Details].OrderID;

-- Lab 3 - Question 10

SELECT Shipcountry, Quantity
FROM Orders JOIN [Order Details] AS ODetails
ON Orders.OrderID = ODetails.OrderID;