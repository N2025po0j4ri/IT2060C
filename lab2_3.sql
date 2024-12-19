
SELECT OrderID, CustomerID, OrderDate
FROM Orders
WHERE OrderDate BETWEEN '1997-12-31' AND '1998-05-04'
ORDER BY OrderDate;
