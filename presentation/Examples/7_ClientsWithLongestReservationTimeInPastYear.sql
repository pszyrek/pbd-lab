USE PBD_lab
GO

DECLARE @Now datetime = GETDATE()
DECLARE @YearBefore datetime = DATEADD(YEAR, -1, @Now)

SELECT * FROM dbo.generate_raport_of_reservation_time(@YearBefore, @Now)
ORDER BY ReservationTime DESC