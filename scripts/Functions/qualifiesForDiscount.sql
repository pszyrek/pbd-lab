USE PBD_lab
GO
CREATE FUNCTION qualifies_for_discount(@ClientId bigint)
RETURNS BIT
BEGIN
	DECLARE @ClientOrderCount AS bigint

	SELECT @ClientOrderCount =
	COUNT(*)
	FROM OrderSummaries
	WHERE CustomerID = @ClientId AND AbsoluteGross > 30
	GROUP BY CustomerID

	DECLARE @AlreadyHasDiscount AS BIT = 0

	IF EXISTS(SELECT * FROM ActiveDiscounts discounts WHERE discounts.CustomerID = @ClientId)
		BEGIN
			SET @AlreadyHasDiscount = 1
		END

	IF(@ClientOrderCount > 10 AND @AlreadyHasDiscount = 0)
		RETURN 1;
		
	RETURN 0;
END