USE [PBD_lab]
GO
/****** Object:  StoredProcedure [dbo].[GenerateVat]    Script Date: 02.06.2021 00:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GenerateVat]
	@order_id BIGINT
AS
BEGIN
	UPDATE dbo.Orders SET dbo.Orders.WasInvoiced = 1 WHERE dbo.Orders.OrderID = @order_id

	SELECT products.Name, companies.Name, companies.Adress, companies.TaxID, customers.Name, customers.Surname, orderEntrySummaries.TotalGross, 
		orderEntrySummaries.TotalNet, orderSummaries.RealizationDateTime, orderEntrySummaries.Quantity, orderSummaries.TotalNet, orderSummaries.TotalGross, 
		orderSummaries.DiscountPercentage, orderSummaries.AbsoluteNet, orderSummaries.AbsoluteGross, orderSummaries.TotalQuantity
		FROM dbo.Products products INNER JOIN
		dbo.OrderEntrySummaries orderEntrySummaries ON products.ProductID = orderEntrySummaries.ProductID INNER JOIN
		dbo.Customers customers INNER JOIN
		dbo.Companies companies ON customers.CompanyID = companies.CompanyID INNER JOIN
		dbo.OrderSummaries orderSummaries ON customers.CustomerID = orderSummaries.CustomerID ON orderEntrySummaries.OrderID = orderSummaries.OrderId
			WHERE orderEntrySummaries.OrderID = @order_id
END
