USE PBD_lab
GO
CREATE FUNCTION get_available_tables_ids(@StartDateTime datetime, @EndDateTime datetime) 
RETURNS TABLE AS RETURN
	WITH TakenTables (TableID) AS
	(
		SELECT tables.TableID
		FROM Tables tables 
		LEFT JOIN Reservations reservations 
		ON tables.TableID = reservations.TableID
		WHERE reservations.IsAccepted = 1
		AND ((@StartDateTime BETWEEN reservations.ReservationStartDateTime AND reservations.ReservationEndDateTime)
			OR (@EndDateTime BETWEEN reservations.ReservationStartDateTime AND reservations.ReservationEndDateTime)
			OR (@StartDateTime <= reservations.ReservationStartDateTime AND @EndDateTime >= reservations.ReservationEndDateTime))
		GROUP BY tables.TableID
	)
	SELECT * FROM Tables 
	WHERE TableID NOT IN (SELECT * FROM TakenTables) AND IsActive = 1