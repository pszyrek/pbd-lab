USE PBD_lab
GO
CREATE FUNCTION can_preorder()
RETURNS BIT AS
BEGIN
	DECLARE @todays_day VARCHAR(10);
	SET @todays_day = DATENAME(DW, GETDATE());

	if(@todays_day LIKE '(Thursday)|(Friday)|(Saturday)') RETURN 1;
	else RETURN 0;
END