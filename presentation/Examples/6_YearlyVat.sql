USE PBD_lab
GO

DECLARE @Now datetime = GETDATE()
DECLARE @YearBefore datetime = DATEADD(YEAR, -1, @Now)
DECLARE @ClientId bigint = 31

EXEC GenerateVatFromDateRange @ClientId, @YearBefore, @Now