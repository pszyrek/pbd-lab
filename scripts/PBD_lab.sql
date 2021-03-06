USE [master]
GO
/****** Object:  Database [PBD_lab]    Script Date: 03.06.2021 20:07:02 ******/
CREATE DATABASE [PBD_lab]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PBD_lab', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\PBD_lab.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PBD_lab_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\PBD_lab_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [PBD_lab] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PBD_lab].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PBD_lab] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PBD_lab] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PBD_lab] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PBD_lab] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PBD_lab] SET ARITHABORT OFF 
GO
ALTER DATABASE [PBD_lab] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PBD_lab] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PBD_lab] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PBD_lab] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PBD_lab] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PBD_lab] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PBD_lab] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PBD_lab] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PBD_lab] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PBD_lab] SET  DISABLE_BROKER 
GO
ALTER DATABASE [PBD_lab] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PBD_lab] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PBD_lab] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PBD_lab] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PBD_lab] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PBD_lab] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PBD_lab] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PBD_lab] SET RECOVERY FULL 
GO
ALTER DATABASE [PBD_lab] SET  MULTI_USER 
GO
ALTER DATABASE [PBD_lab] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PBD_lab] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PBD_lab] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PBD_lab] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PBD_lab] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PBD_lab] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'PBD_lab', N'ON'
GO
ALTER DATABASE [PBD_lab] SET QUERY_STORE = OFF
GO
USE [PBD_lab]
GO
/****** Object:  User [test_user]    Script Date: 03.06.2021 20:07:02 ******/
CREATE USER [test_user] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedTableType [dbo].[OrderItems]    Script Date: 03.06.2021 20:07:02 ******/
CREATE TYPE [dbo].[OrderItems] AS TABLE(
	[ProductID] [bigint] NULL,
	[Quantity] [int] NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[apply_discount]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[apply_discount](@original_price DECIMAL(6,2), @discount_percentage DECIMAL(2,2))
RETURNS DECIMAL(6,2)
BEGIN
	IF(@discount_percentage = NULL)
		RETURN @original_price

	RETURN @original_price * (100 - @discount_percentage) / 100
END
GO
/****** Object:  UserDefinedFunction [dbo].[calculate_net_price]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[calculate_net_price](@gross_price DECIMAL(5,2))
RETURNS DECIMAL(5,2)
BEGIN
	DECLARE @vat_value DECIMAL(2,2) = 0.23
	RETURN @gross_price / (1 + @vat_value)
END;
GO
/****** Object:  UserDefinedFunction [dbo].[can_preorder]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[can_preorder]()
RETURNS BIT AS
BEGIN
	DECLARE @todays_day VARCHAR(10);
	SET @todays_day = DATENAME(DW, GETDATE());

	if(@todays_day LIKE '(Thursday)|(Friday)|(Saturday)') RETURN 1;
	RETURN 0;
END
GO
/****** Object:  UserDefinedFunction [dbo].[containts_preordered_products]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[containts_preordered_products]
(@Order OrderItems READONLY)
RETURNS BIT AS
BEGIN
	IF EXISTS(
		SELECT * FROM @Order 
		JOIN Products products
		ON [@Order].ProductID = products.ProductID
		WHERE IsPreordered = 1) 
		RETURN 1

	RETURN 0
END
GO
/****** Object:  UserDefinedFunction [dbo].[get_active_discount_id_for_customer]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[get_active_discount_id_for_customer](@CustomerId bigint)
RETURNS bigint
BEGIN
	DECLARE @LatestActiveDiscountId bigint = 
	(SELECT TOP 1 DiscountId FROM Discounts
	WHERE 
		CustomerID = @CustomerId AND
		GETDATE() BETWEEN IssuanceDateTime AND ExpirationDateTime
	ORDER BY IssuanceDateTime DESC)

	RETURN @LatestActiveDiscountId
END
GO
/****** Object:  UserDefinedFunction [dbo].[qualifies_for_discount]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[qualifies_for_discount](@ClientId bigint)
RETURNS BIT
BEGIN
	DECLARE @ClientOrderCount AS bigint

	SELECT @ClientOrderCount =
	COUNT(*)
	FROM OrderSummaries
	WHERE CustomerID = @ClientId AND AbsoluteGross > 30
	GROUP BY CustomerID

	DECLARE @AlreadyHasDiscount AS BIT = 0

	IF EXISTS(SELECT * FROM ActiveDiscounts discounts WHERE discounts.CustomerID = @ClientId)
		BEGIN
			SET @AlreadyHasDiscount = 1
		END

	IF(@ClientOrderCount > 10 AND @AlreadyHasDiscount = 0)
		RETURN 1;
		
	RETURN 0;
END
GO
/****** Object:  Table [dbo].[Products]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [bigint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[TotalPrice] [decimal](5, 2) NOT NULL,
	[IsInMenu] [bit] NOT NULL,
	[IsPreordered] [bit] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[TaxedProducts]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TaxedProducts] AS
SELECT 
ProductID, Name, 
TotalPrice AS GrossPrice, 
dbo.calculate_net_price(TotalPrice) AS NetPrice 
FROM Products
GO
/****** Object:  Table [dbo].[OrderEntries]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderEntries](
	[OrderID] [bigint] NOT NULL,
	[ProductID] [bigint] NOT NULL,
	[Quantity] [bigint] NOT NULL,
 CONSTRAINT [PK_OrderEntry] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[OrderEntrySummaries]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[OrderEntrySummaries] AS
SELECT 
_entry.OrderID, 
_entry.ProductID, 
SUM(Quantity) AS Quantity, 
SUM(GrossPrice) AS TotalGross, 
SUM(NetPrice) AS TotalNet
FROM OrderEntries _entry JOIN TaxedProducts products
	ON _entry.ProductID = products.ProductID
GROUP BY _entry.OrderID, _entry.ProductID
GO
/****** Object:  Table [dbo].[Discounts]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discounts](
	[DiscountID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerID] [bigint] NOT NULL,
	[DiscountPercentage] [decimal](2, 2) NOT NULL,
	[IssuanceDateTime] [datetime] NOT NULL,
	[ExpirationDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Discounts] PRIMARY KEY CLUSTERED 
(
	[DiscountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ActiveDiscounts]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ActiveDiscounts] AS
SELECT
DiscountID,
CustomerID,
DiscountPercentage
FROM Discounts
WHERE GETDATE() between IssuanceDateTime and ExpirationDateTime
GO
/****** Object:  View [dbo].[ActiveMenu]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ActiveMenu] AS
SELECT ProductID, Name, TotalPrice from Products
WHERE IsInMenu = 1 AND 
(IsPreordered = 0 OR (IsPreordered = 1 AND dbo.can_preorder() = 1))
GO
/****** Object:  Table [dbo].[Tables]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tables](
	[TableID] [bigint] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Tables] PRIMARY KEY CLUSTERED 
(
	[TableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservations]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservations](
	[ReservationID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerID] [bigint] NOT NULL,
	[TableID] [bigint] NOT NULL,
	[PlacementDateTime] [datetime] NOT NULL,
	[ReservationStartDateTime] [datetime] NOT NULL,
	[ReservationEndDateTime] [datetime] NOT NULL,
	[IsBusinessMeeting] [bit] NOT NULL,
	[IsAccepted] [bit] NOT NULL,
 CONSTRAINT [PK_Reservations] PRIMARY KEY CLUSTERED 
(
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get_available_tables_ids]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[get_available_tables_ids](@StartDateTime datetime, @EndDateTime datetime) 
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
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerID] [bigint] NOT NULL,
	[CompanyID] [bigint] NULL,
	[Name] [varchar](50) NOT NULL,
	[Surname] [varchar](50) NOT NULL,
	[EmailAdress] [varchar](255) NOT NULL,
	[PhoneNumber] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[generate_raport_of_reservation_time]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[generate_raport_of_reservation_time](@startDate DATETIME, @endDate DATETIME)
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
/****** Object:  Table [dbo].[Orders]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerID] [bigint] NOT NULL,
	[PlacementDateTime] [datetime] NOT NULL,
	[RealizationDateTime] [datetime] NOT NULL,
	[WasInvoiced] [bit] NOT NULL,
	[DiscountID] [bigint] NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[generate_raport_of_products]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[generate_raport_of_products] 
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
/****** Object:  View [dbo].[OrderSummaries]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[OrderSummaries] AS
SELECT
orders.OrderId,
orders.CustomerID,
PlacementDateTime,
RealizationDateTime,
SUM(Quantity) AS TotalQuantity,
SUM(TotalGross) AS AbsoluteGross,
SUM(TotalNet) AS AbsoluteNet,
discounts.DiscountPercentage AS DiscountPercentage,
CASE 
	WHEN DiscountPercentage IS NULL THEN SUM(TotalGross)
	ELSE dbo.apply_discount(SUM(TotalGross), DiscountPercentage)
END AS TotalGross,
CASE 
	WHEN DiscountPercentage IS NULL THEN SUM(TotalNet)
	ELSE dbo.apply_discount(SUM(TotalNet), DiscountPercentage)
END AS TotalNet,
WasInvoiced
FROM Orders orders
LEFT JOIN OrderEntrySummaries entries ON orders.OrderID = entries.OrderID
LEFT JOIN Discounts discounts ON orders.DiscountID = discounts.DiscountID
GROUP BY 
orders.OrderID, 
orders.CustomerID, 
orders.PlacementDateTime, 
orders.RealizationDateTime,
orders.WasInvoiced,
discounts.DiscountPercentage
GO
/****** Object:  Table [dbo].[Companies]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Companies](
	[CompanyID] [bigint] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[Adress] [varchar](255) NOT NULL,
	[TaxID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Permissions]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permissions](
	[FunctionalityID] [bigint] NOT NULL,
	[FunctionalityName] [varchar](50) NOT NULL,
	[RoleID] [bigint] NOT NULL,
 CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED 
(
	[FunctionalityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RoleID] [bigint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [bigint] NOT NULL,
	[Login] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[RoleID] [bigint] NOT NULL,
 CONSTRAINT [PK_Users_1] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_Companies] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[Companies] ([CompanyID])
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customers_Companies]
GO
ALTER TABLE [dbo].[Discounts]  WITH CHECK ADD  CONSTRAINT [FK_Discounts_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Discounts] CHECK CONSTRAINT [FK_Discounts_Customers]
GO
ALTER TABLE [dbo].[OrderEntries]  WITH CHECK ADD  CONSTRAINT [FK_OrderEntries_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[OrderEntries] CHECK CONSTRAINT [FK_OrderEntries_Orders]
GO
ALTER TABLE [dbo].[OrderEntries]  WITH CHECK ADD  CONSTRAINT [FK_OrderEntries_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[OrderEntries] CHECK CONSTRAINT [FK_OrderEntries_Products]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Discounts] FOREIGN KEY([DiscountID])
REFERENCES [dbo].[Discounts] ([DiscountID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Discounts]
GO
ALTER TABLE [dbo].[Permissions]  WITH CHECK ADD  CONSTRAINT [FK_Permissions_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[Permissions] CHECK CONSTRAINT [FK_Permissions_Roles]
GO
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Customers]
GO
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Tables] FOREIGN KEY([TableID])
REFERENCES [dbo].[Tables] ([TableID])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Tables]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Roles1] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Roles1]
GO
/****** Object:  StoredProcedure [dbo].[GenerateVat]    Script Date: 03.06.2021 20:07:02 ******/
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
		FROM dbo.TaxedProducts products
		INNER JOIN dbo.OrderEntrySummaries orderEntrySummaries ON products.ProductID = orderEntrySummaries.ProductID 
		INNER JOIN dbo.Customers customers 
		INNER JOIN dbo.Companies companies ON customers.CompanyID = companies.CompanyID 
		INNER JOIN dbo.OrderSummaries orderSummaries ON customers.CustomerID = orderSummaries.CustomerID ON orderEntrySummaries.OrderID = orderSummaries.OrderId
			WHERE orderEntrySummaries.OrderID = @order_id
END
GO
/****** Object:  StoredProcedure [dbo].[GenerateVatFromDateRange]    Script Date: 03.06.2021 20:07:02 ******/
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
			WHERE orderSummaries.WasInvoiced = 0 AND orderSummaries.RealizationDateTime BETWEEN @start_date AND @end_date
END
GO
/****** Object:  StoredProcedure [dbo].[IssueDiscount]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IssueDiscount]
	@CustomerId AS bigint
AS
BEGIN
	INSERT INTO Discounts VALUES
	(@CustomerId, 0.05, GETDATE(), DATEADD(WEEK, 1, GETDATE()))
END
GO
/****** Object:  StoredProcedure [dbo].[PlaceOrder]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PlaceOrder]
	@CustomerId AS bigint,
	@RealizationDate AS DateTime,
	@Order AS OrderItems READONLY
AS
BEGIN
	IF(dbo.containts_preordered_products(@Order) = 1 AND dbo.can_preorder() = 0)
		THROW 1, 'The order cannot be placed. It includes products that need to be preordered earlier.', 1

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
GO
/****** Object:  StoredProcedure [dbo].[PlaceReservation]    Script Date: 03.06.2021 20:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PlaceReservation]
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
GO
USE [master]
GO
ALTER DATABASE [PBD_lab] SET  READ_WRITE 
GO
