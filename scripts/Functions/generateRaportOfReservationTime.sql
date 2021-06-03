-- ================================================
-- Template generated from Template Explorer using:
-- Create Inline Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION dbo.generate_raport_of_reservation_time(@startDate DATETIME, @endDate DATETIME)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
	dbo.Customers.Name,
	dbo.Customers.Surname,
	dbo.Customers.PhoneNumber,
	SUM(DATEDIFF(second, dbo.Reservations.ReservationStartDateTime, dbo.Reservations.ReservationEndDateTime) / 3600.0) AS ReservationTime
		FROM dbo.Customers 
		INNER JOIN dbo.Reservations ON dbo.Customers.CustomerID = dbo.Reservations.CustomerID
			WHERE dbo.Reservations.PlacementDateTime BETWEEN @startDate AND @endDate
			GROUP BY 
			dbo.Customers.Name, 
			dbo.Customers.Surname, 
			dbo.Customers.PhoneNumber
)
GO
