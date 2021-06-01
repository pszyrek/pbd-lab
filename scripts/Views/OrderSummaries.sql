USE PBD_lab
GO
CREATE VIEW OrderSummaries AS
SELECT
orders.OrderId,
orders.CustomerID,
PlacementDateTime,
RealizationDateTime,
SUM(Quantity) AS TotalQuantity,
SUM(TotalGross) AS AbsoluteGross,
SUM(TotalNet) AS AbsoluteNet,
discounts.DiscountPercentage AS DiscountPercentage,
dbo.apply_discount(SUM(TotalGross), DiscountPercentage) AS TotalGross,
dbo.apply_discount(SUM(TotalNet), DiscountPercentage) AS TotalNet,
orders.WasInvoiced
FROM Orders orders
LEFT JOIN OrderEntrySummaries entries ON orders.OrderID = entries.OrderID
LEFT JOIN Discounts discounts ON orders.DiscountID = discounts.DiscountID
GROUP BY orders.OrderID, orders.CustomerID, orders.PlacementDateTime, orders.RealizationDateTime, discounts.DiscountPercentage, orders.WasInvoiced