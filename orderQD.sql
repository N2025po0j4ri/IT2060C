SELECT Orders.OrderID, Orders.CustomerID, Customers.CustomerID AS Expr1, [Order Details].OrderID AS Expr2, [Order Details].ProductID
FROM   Customers INNER JOIN
             Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
             [Order Details] ON Orders.OrderID = [Order Details].OrderID