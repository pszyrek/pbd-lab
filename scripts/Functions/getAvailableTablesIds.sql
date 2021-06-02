USE PBD_lab
GO
CREATE FUNCTION get_available_tables_ids(@StartDateTime datetime, @EndDateTime datetime) 
RETURNS TABLE AS RETURN 
	SELECT reservations.TableID
	FROM Tables tables 
	LEFT JOIN Reservations reservations 
	ON tables.TableID = reservations.TableID
	WHERE tables.IsActive = 1 AND reservations.IsAccepted = 1
	AND ((@StartDateTime BETWEEN reservations.ReservationStartDateTime AND reservations.ReservationEndDateTime)
		OR (@EndDateTime BETWEEN reservations.ReservationStartDateTime AND reservations.ReservationEndDateTime)
		OR @StartDateTime <= reservations.ReservationStartDateTime AND @EndDateTime >= reservations.ReservationEndDateTime)
	GROUP BY reservations.TableID
	HAVING COUNT(*) = 0