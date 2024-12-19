SELECT OrderID, UnitPrice, Quantity,
UnitPrice * Quantity AS OrderTotal
From [Order Details]
ORDER BY OrderTotal;