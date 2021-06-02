USE PBD_lab
GO
CREATE PROCEDURE PlaceReservation
	@TableId AS bigint,
	@CustomerId AS bigint,
	@StartDateTime AS datetime,
	@EndDateTime AS datetime,
	@IsBussinessMeeting AS BIT
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM dbo.get_available_tables_ids(@StartDateTime, @EndDateTime) WHERE TableID = @TableId)
		THROW 2, 'This table is already taken.', 1

	INSERT INTO Reservations VALUES
	(@CustomerId, @TableId, GETDATE(), @StartDateTime, @EndDateTime, @IsBussinessMeeting, 0)
END