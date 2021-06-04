USE PBD_lab
GO

DECLARE @JanKowalskiId bigint 
SELECT TOP 1 @JanKowalskiId = CustomerId 
FROM Customers
WHERE Name = 'Jan' AND Surname = 'Kowalski'

EXEC PlaceReservation 1, @JanKowalskiId, '2021.06.08 12:00:00', '2021.06.08 14:00:00', 0

UPDATE Reservations
SET IsAccepted = 1
WHERE CustomerID = @JanKowalskiId