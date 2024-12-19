UPDATE Orders
SET PaymentDueDate = GETDATE() + 30
WHERE OrderID = 4;