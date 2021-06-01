USE [PBD_lab]
GO
/****** Object:  StoredProcedure [dbo].[GenerateVatFromDateRange]    Script Date: 02.06.2021 00:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GenerateVatFromDateRange]
	@client_id BIGINT,
	@start_date DATETIME,
	@end_date DATETIME
AS
BEGIN
	SELECT products.Name, companies.Name, companies.Adress, companies.TaxID, customers.Name, customers.Surname, orderEntrySummaries.TotalGross, 
		orderEntrySummaries.TotalNet, orderSummaries.RealizationDateTime, orderEntrySummaries.Quantity, orderSummaries.TotalNet, orderSummaries.TotalGross, 
		orderSummaries.DiscountPercentage, orderSummaries.AbsoluteNet, orderSummaries.AbsoluteGross, orderSummaries.TotalQuantity
		FROM dbo.Products products INNER JOIN
		dbo.OrderEntrySummaries orderEntrySummaries ON products.ProductID = orderEntrySummaries.ProductID INNER JOIN
		dbo.Customers customers INNER JOIN
		dbo.Companies companies ON customers.CompanyID = companies.CompanyID INNER JOIN
		dbo.OrderSummaries orderSummaries ON customers.CustomerID = orderSummaries.CustomerID ON orderEntrySummaries.OrderID = orderSummaries.OrderId
			WHERE orderSummaries.WasInvoiced = 0 AND orderSummaries.RealizationDateTime BETWEEN @start_date AND @end_date
END
