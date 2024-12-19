-- Question 1

SELECT OrderID, OrderDate, Freight
FROM Orders
WHERE Freight <
   (SELECT MAX(Freight)
   FROM Orders)
ORDER BY Freight;

-- Question 2
/* 
Which one of these join statements will display the same results as the following Subquery?
 */

SELECT OrderID, OrderDate
FROM Orders
WHERE CustomerID IN
    (SELECT CustomerID
    FROM Customers
    WHERE OrderID = 10248)
ORDER BY OrderDate; 

/* Fail
SELECT OrderID, OrderDate
FROM Orders, Customers
    ON Orders.CustomerID = Customers.CustomerID
WHERE OrderID = 10248
ORDER BY OrderDate; */


SELECT OrderID, OrderDate
FROM Orders JOIN Customers
     ON Orders.CustomerID = Customers.CustomerID
WHERE OrderID = 10248
ORDER BY OrderDate;

-- Question 3
/*
Which one of the following statements is coded properly as a Subquery?
*/

-- Fail
SELECT OrderDate, Freight
FROM Orders
     (SELECT CustomerID
     FROM Customers
     WHERE ContactName = 'Robin')
ORDER BY OrderDate;

-- Pass
SELECT OrderDate, Freight
FROM Orders
WHERE CustomerID IN
     (SELECT CustomerID
     FROM Customers
     WHERE ContactName = 'Robin')
ORDER BY OrderDate;

-- Fail
SELECT OrderDate, Freight
FROM Orders
WHERE CustomerID IN
     (SELECT CustomerID
     FROM Customers)
     WHERE ContactName = 'Robin'
ORDER BY OrderDate;

-- Fail
SELECT OrderDate, Freight
FROM Orders
WHERE CustomerID IN
     SELECT CustomerID
     FROM Customers
     WHERE ContactName = 'Robin'
ORDER BY OrderDate;

-- Question 4

/*

Using the following statement, fill in the blank to display all the employees without an order in the orders table.

SELECT EmployeeID, LastName, FirstName
FROM Employees
WHERE EmployeeID _______
     (SELECT DISTINCT EmployeeID
     FROM Orders);

*/

SELECT EmployeeID, LastName, FirstName
FROM Employees
WHERE EmployeeID NOT IN
     (SELECT DISTINCT EmployeeID
     FROM Orders);

-- Question 5

/*
Using the following statement, fill in the blank to display all the employees without an order in the orders table.

SELECT EmployeeID, LastName, FirstName
FROM Employees
WHERE _________
(SELECT *
FROM Orders
WHERE Orders.EmployeeID = Employees.EmployeeID);
*/

SELECT EmployeeID, LastName, FirstName
FROM Employees
WHERE NOT EXISTS
(SELECT *
FROM Orders
WHERE Orders.EmployeeID = Employees.EmployeeID);

-- Question 6

/*
Which one of these join statements will display the same results as the following Subquery?

SELECT Quantity
FROM Orders JOIN [Order Details]
     ON Orders.OrderID = [Order Details].OrderID
WHERE Quantity > ALL
    (SELECT Quantity
    FROM [Order Details]
    WHERE OrderID = 10248)
*/

SELECT Quantity
FROM Orders JOIN [Order Details]
     ON Orders.OrderID = [Order Details].OrderID
WHERE Quantity > ALL
    (SELECT Quantity
    FROM [Order Details]
    WHERE OrderID = 10248)

-- Fail
SELECT Quantity
FROM Orders JOIN [Order Details]
    ON Orders.OrderID = [Order Details].OrderID
WHERE Quantity >
    (SELECT ALL(Quantity)
    FROM [Order Details]
    WHERE OrderID = 10248)

-- Fail
SELECT Quantity
FROM Orders JOIN [Order Details]
    ON Orders.OrderID = [Order Details].OrderID
WHERE Quantity >
    (SELECT MIN(Quantity)
    FROM [Order Details]
    WHERE OrderID = 10248)
-- Pass
SELECT Quantity
FROM Orders JOIN [Order Details]
     ON Orders.OrderID = [Order Details].OrderID
WHERE Quantity >
    (SELECT MAX(Quantity)
    FROM [Order Details]
   WHERE OrderID = 10248)
-- Fail
SELECT Quantity
FROM Orders JOIN [Order Details]
     ON Orders.OrderID = [Order Details].OrderID
WHERE Quantity > MAX
    (SELECT (Quantity)
    FROM [Order Details]
    WHERE OrderID = 10248)