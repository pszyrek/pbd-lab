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
CASE 
	WHEN DiscountPercentage IS NULL THEN SUM(TotalGross)
	ELSE dbo.apply_discount(SUM(TotalGross), DiscountPercentage)
END AS TotalGross,
CASE 
	WHEN DiscountPercentage IS NULL THEN SUM(TotalNet)
	ELSE dbo.apply_discount(SUM(TotalNet), DiscountPercentage)
END AS TotalNet,
WasInvoiced
FROM Orders orders
INNER JOIN OrderEntrySummaries entries ON orders.OrderID = entries.OrderID
LEFT JOIN Discounts discounts ON orders.DiscountID = discounts.DiscountID
GROUP BY 
orders.OrderID, 
orders.CustomerID, 
orders.PlacementDateTime, 
orders.RealizationDateTime,
orders.WasInvoiced,
discounts.DiscountPercentage