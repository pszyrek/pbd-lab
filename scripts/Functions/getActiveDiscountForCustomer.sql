USE PBD_lab
GO
CREATE FUNCTION get_active_discount_id_for_customer(@CustomerId bigint)
RETURNS bigint
BEGIN
	DECLARE @LatestActiveDiscountId bigint = 
	(SELECT TOP 1 DiscountId FROM Discounts
	WHERE 
		CustomerID = @CustomerId AND
		GETDATE() BETWEEN IssuanceDateTime AND ExpirationDateTime
	ORDER BY IssuanceDateTime DESC)

	RETURN @LatestActiveDiscountId
END