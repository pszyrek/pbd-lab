USE PBD_lab
GO
CREATE VIEW TaxedProducts AS
SELECT 
ProductID, Name, 
TotalPrice AS GrossPrice, 
dbo.calculate_net_price(TotalPrice) AS NetPrice 
FROM Products