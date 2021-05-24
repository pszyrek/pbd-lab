USE [master]
GO
/****** Object:  Database [PBD_lab]    Script Date: 22.05.2021 15:50:09 ******/
CREATE DATABASE [PBD_lab]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PBD_lab', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\PBD_lab.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PBD_lab_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\PBD_lab_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
/****** Object:  UserDefinedFunction [dbo].[apply_discount]    Script Date: 22.05.2021 15:50:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[apply_discount](@original_price DECIMAL(5,2), @discount_percentage DECIMAL(2,2))
RETURNS DECIMAL(5,2)
BEGIN
	IF(@discount_percentage = NULL)
		RETURN @original_price

	RETURN @original_price * (100 - @discount_percentage) / 100
END
GO
/****** Object:  UserDefinedFunction [dbo].[calculate_net_price]    Script Date: 22.05.2021 15:50:09 ******/
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
/****** Object:  UserDefinedFunction [dbo].[can_preorder]    Script Date: 22.05.2021 15:50:09 ******/
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
/****** Object:  Table [dbo].[Products]    Script Date: 22.05.2021 15:50:09 ******/
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
/****** Object:  View [dbo].[TaxedProducts]    Script Date: 22.05.2021 15:50:09 ******/
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
/****** Object:  Table [dbo].[OrderEntries]    Script Date: 22.05.2021 15:50:09 ******/
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
/****** Object:  View [dbo].[OrderEntrySummaries]    Script Date: 22.05.2021 15:50:09 ******/
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
/****** Object:  Table [dbo].[Discounts]    Script Date: 22.05.2021 15:50:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discounts](
	[DiscountID] [bigint] NOT NULL,
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
/****** Object:  View [dbo].[ActiveDiscounts]    Script Date: 22.05.2021 15:50:09 ******/
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
/****** Object:  View [dbo].[ActiveMenu]    Script Date: 22.05.2021 15:50:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ActiveMenu] AS
SELECT ProductID, Name, TotalPrice from Products
WHERE IsInMenu = 1 AND 
(IsPreordered = 0 OR (IsPreordered = 1 AND dbo.can_preorder() = 1))
GO
/****** Object:  Table [dbo].[Companies]    Script Date: 22.05.2021 15:50:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Companies](
	[CompanyID] [bigint] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[Adress] [varchar](255) NOT NULL,
	[TaxID] [bigint] NOT NULL,
 CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 22.05.2021 15:50:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerID] [bigint] NOT NULL,
	[CompanyID] [bigint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Surname] [varchar](50) NOT NULL,
	[EmailAdress] [varchar](255) NOT NULL,
	[PhoneNumber] [varchar](15) NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 22.05.2021 15:50:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [bigint] NOT NULL,
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
/****** Object:  Table [dbo].[Permissions]    Script Date: 22.05.2021 15:50:09 ******/
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
/****** Object:  Table [dbo].[Reservations]    Script Date: 22.05.2021 15:50:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservations](
	[ReservationID] [bigint] NOT NULL,
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
/****** Object:  Table [dbo].[Roles]    Script Date: 22.05.2021 15:50:09 ******/
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
/****** Object:  Table [dbo].[Tables]    Script Date: 22.05.2021 15:50:09 ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 22.05.2021 15:50:09 ******/
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
USE [master]
GO
ALTER DATABASE [PBD_lab] SET  READ_WRITE 
GO
