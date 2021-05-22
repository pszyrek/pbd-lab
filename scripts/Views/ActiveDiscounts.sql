USE PBD_lab
GO
CREATE VIEW ActiveDiscounts AS
SELECT
DiscountID,
CustomerID,
DiscountPercentage
FROM Discounts
WHERE GETDATE() between IssuanceDateTime and ExpirationDateTime