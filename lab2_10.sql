SELECT TOP 5 OrderID , OrderDate,
GETDATE() AS 'Today''s Date',
DATEDIFF (day, OrderDate, GETDATE()) AS [Order's Age]
FROM Orders;