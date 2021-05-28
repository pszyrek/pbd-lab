USE PBD_lab
GO
CREATE FUNCTION containts_preordered_products
(@Order OrderItems READONLY)
RETURNS BIT AS
BEGIN
	IF EXISTS(
		SELECT * FROM @Order 
		JOIN Products products
		ON [@Order].ProductID = products.ProductID
		WHERE IsPreordered = 1) 
		RETURN 1

	RETURN 0
END