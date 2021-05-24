USE PBD_lab
GO
CREATE FUNCTION calculate_net_price(@gross_price DECIMAL(5,2))
RETURNS DECIMAL(5,2)
BEGIN
	DECLARE @vat_value DECIMAL(2,2) = 0.23
	RETURN @gross_price / (1 + @vat_value)
END;