USE PBD_lab
GO
CREATE FUNCTION apply_discount(@original_price DECIMAL(5,2), @discount_percentage DECIMAL(2,2))
RETURNS DECIMAL(5,2)
BEGIN
	IF(@discount_percentage = NULL)
		RETURN @original_price

	RETURN @original_price * (100 - @discount_percentage) / 100
END