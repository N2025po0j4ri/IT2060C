/* Question 2 Which one of the following statements copies all the orders with a larger quantity 
than the average quantity from the Order Details table into to a new table? */

SELECT *
   INTO AboveAverageOrders
   FROM [Order Details]
WHERE Quantity >
     (SELECT AVG(Quantity)
       FROM [Order Details]);

SELECT *
FROM AboveAverageOrders;

-- Question 3

SELECT *
INTO OrdersCopy
FROM Orders;

UPDATE OrdersCopy
SET ShipVia = 5
Where OrderID IN
    (SELECT OrderID
     FROM OrdersCopy
     WHERE OrderID = 10248);

SELECT *
FROM OrdersCopy
WHERE CustomerID = 'HANAR';

-- Question 4
Delete OrdersCopy
WHERE CustomerID = 'HANAR';

-- Question 5

SELECT *
INTO EmployeesCopy
FROM Employees;

/* fail
SELECT *
WHERE EmployeeID NOT IN
    (SELECT DISTINCT EmployeeID
    FROM OrdersCopy);
*/

/* Fail
DELETE EmployeeID
FROM EmployeesCopy NOT IN
    (SELECT DISTINCT EmployeeID
    FROM OrdersCopy); */

SELECT * 
FROM EmployeesCopy;

SELECT DISTINCT EmployeeID
FROM OrdersCopy;

DELETE EmployeesCopy
WHERE EmployeeID NOT IN
    (SELECT DISTINCT EmployeeID
    FROM OrdersCopy);