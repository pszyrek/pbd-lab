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
	DECLARE @CompanyId bigint

	SELECT TOP 1 @CompanyId = customers.CompanyId FROM Customers customers
	INNER JOIN Companies companies ON customers.CompanyID = companies.CompanyID
	WHERE customers.CustomerID = @client_id

	SELECT
	companies.TaxID, 
	companies.Name AS CompanyName,
	companies.Adress, 
	customers.Name, 
	customers.Surname, 
	products.Name AS ProductName,
	orderEntrySummaries.Quantity AS ProductQuantity,
	products.GrossPrice AS UnitPrice,
	orderEntrySummaries.TotalNet,
	orderEntrySummaries.TotalGross,
	orderSummaries.OrderId,
	orderSummaries.AbsoluteNet AS OrderAbsoluteNet, 
	orderSummaries.AbsoluteGross AS OrderAbsoluteGross,
	orderSummaries.DiscountPercentage, 
	orderSummaries.TotalNet AS FinalOrderNet, 
	orderSummaries.TotalGross AS FinalOrderGross, 
	orderSummaries.RealizationDateTime
		FROM dbo.TaxedProducts products INNER JOIN
		dbo.OrderEntrySummaries orderEntrySummaries ON products.ProductID = orderEntrySummaries.ProductID INNER JOIN
		dbo.Customers customers INNER JOIN
		dbo.Companies companies ON customers.CompanyID = companies.CompanyID INNER JOIN
		dbo.OrderSummaries orderSummaries ON customers.CustomerID = orderSummaries.CustomerID ON orderEntrySummaries.OrderID = orderSummaries.OrderId
			WHERE orderSummaries.WasInvoiced = 0 
			AND orderSummaries.RealizationDateTime BETWEEN @start_date AND @end_date
			AND customers.CompanyID = @CompanyId
END
