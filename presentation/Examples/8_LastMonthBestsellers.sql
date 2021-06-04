USE PBD_lab
GO

DECLARE @Now datetime = GETDATE()
DECLARE @MonthBefore datetime = DATEADD(MONTH, -1, @Now)

SELECT * FROM generate_raport_of_products(@MonthBefore, @Now)
ORDER BY TotalQuantity DESC, TotalGrossValue DESC