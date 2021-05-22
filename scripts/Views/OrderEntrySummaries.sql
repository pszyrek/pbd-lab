USE PBD_lab
GO
CREATE VIEW OrderEntrySummaries AS
SELECT 
_entry.OrderID, 
_entry.ProductID, 
SUM(Quantity) AS Quantity, 
SUM(GrossPrice) AS TotalGross, 
SUM(NetPrice) AS TotalNet
FROM OrderEntries _entry JOIN TaxedProducts products
	ON _entry.ProductID = products.ProductID
GROUP BY _entry.OrderID, _entry.ProductID