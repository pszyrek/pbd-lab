USE PBD_lab
GO
CREATE FUNCTION can_preorder()
RETURNS BIT AS
BEGIN
	DECLARE @todays_day VARCHAR(10);
	SET @todays_day = DATENAME(DW, GETDATE());

	if(@todays_day = 'Thursday') RETURN 1;
	if(@todays_day = 'Friday') RETURN 1;
	if(@todays_day = 'Saturday') RETURN 1;

	RETURN 0;
END