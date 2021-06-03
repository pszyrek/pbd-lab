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
USE PBD_lab
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION generate_raport_of_products 
(@startDate DATETIME, @endDate DATETIME)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
	dbo.Products.Name,
	SUM(dbo.OrderEntrySummaries.TotalNet) AS TotalNetValue,
	SUM(dbo.OrderEntrySummaries.TotalGross) AS TotalGrossValue,
	SUM(dbo.OrderEntrySummaries.Quantity) AS TotalQuantity,
	dbo.Products.TotalPrice AS UnitPrice
		FROM dbo.OrderEntrySummaries 
		INNER JOIN dbo.Products ON dbo.OrderEntrySummaries.ProductID = dbo.Products.ProductID 
		INNER JOIN dbo.Orders ON dbo.OrderEntrySummaries.OrderID = dbo.Orders.OrderID
			WHERE dbo.Orders.RealizationDateTime BETWEEN @startDate AND @endDate
			GROUP BY 
			dbo.Products.ProductID, 
			dbo.Products.Name,
			dbo.Products.TotalPrice)
GO
