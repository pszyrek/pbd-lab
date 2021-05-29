USE PBD_lab
GO
CREATE PROCEDURE PlaceOrder
	@CustomerId AS bigint,
	@RealizationDate AS DateTime,
	@Order AS OrderItems READONLY
AS
BEGIN
	IF(dbo.containts_preordered_products(@Order) = 1 AND dbo.can_preorder() = 0)
		THROW 101, 'The order cannot be placed. It includes products that need to be preordered earlier.', 1

	DECLARE @LatestDiscountId bigint
	SET @LatestDiscountId = dbo.get_active_discount_id_for_customer(@CustomerId)

	BEGIN TRANSACTION [PlaceOrderTrans]
		BEGIN TRY

			INSERT INTO Orders VALUES
			(@CustomerId, GETDATE(), @RealizationDate, 0, @LatestDiscountId)

			INSERT INTO OrderEntries
			SELECT SCOPE_IDENTITY(), ProductID, Quantity
			FROM @Order
		
			COMMIT TRANSACTION [PlaceOrderTrans]

		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION [PlaceOrderTrans]
		END CATCH

	IF(dbo.qualifies_for_discount(@CustomerId) = 1)
		BEGIN
			EXEC dbo.IssueDiscount @CustomerId = @CustomerId
		END
END