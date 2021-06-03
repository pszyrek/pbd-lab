DECLARE @OrderedItems OrderItems

INSERT INTO @OrderedItems VALUES
(485, 2), /* Turkey */
(1074, 3) /* Coconut */

DECLARE @JanId bigint
SELECT TOP 1 CustomerId FROM Customers
WHERE Name = 'Jan' AND Surname = 'Kowalski'

EXEC PlaceOrder @JanId, '2021.06.08 12:00:00', @OrderedItems

DECLARE @JanOrderId bigint
SELECT TOP 1 CustomerId FROM Orders
WHERE CustomerID = @JanId

EXEC GenerateVat @JanOrderId