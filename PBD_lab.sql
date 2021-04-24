USE [master]
GO
/****** Object:  Database [PBD_lab]    Script Date: 24.04.2021 11:10:59 ******/
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
/****** Object:  Table [dbo].[Companies]    Script Date: 24.04.2021 11:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Companies](
	[CompanyID] [bigint] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[Adress] [varchar](255) NOT NULL,
	[TaxID] [bigint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 24.04.2021 11:10:59 ******/
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
	[PhoneNumber] [varchar](15) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 24.04.2021 11:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[OrderID] [bigint] NOT NULL,
	[ProductID] [bigint] NOT NULL,
	[Quantity] [bigint] NOT NULL,
	[TotalGross] [decimal](10, 2) NOT NULL,
	[TotalNet] [decimal](10, 2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 24.04.2021 11:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[CustomerID] [bigint] NOT NULL,
	[OrderID] [bigint] NOT NULL,
	[Date] [datetime] NOT NULL,
	[TotalGross] [decimal](10, 2) NOT NULL,
	[TotalNet] [decimal](10, 2) NOT NULL,
	[ProductsAmount] [bigint] NOT NULL,
	[IsDiscountActive] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Permissions]    Script Date: 24.04.2021 11:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permissions](
	[FunctionalityID] [bigint] NOT NULL,
	[FunctionalityName] [varchar](50) NOT NULL,
	[RoleID] [bigint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 24.04.2021 11:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [bigint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[NetPrice] [decimal](5, 2) NOT NULL,
	[GrossPrice] [decimal](5, 2) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsExtra] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservations]    Script Date: 24.04.2021 11:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservations](
	[ReservationID] [bigint] NOT NULL,
	[CustomerID] [bigint] NOT NULL,
	[TableID] [bigint] NOT NULL,
	[Date] [datetime] NOT NULL,
	[IsBusinessMeeting] [bit] NOT NULL,
	[IsAccepted] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 24.04.2021 11:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Name] [varchar](50) NOT NULL,
	[RoleID] [bigint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tables]    Script Date: 24.04.2021 11:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tables](
	[TableID] [bigint] NOT NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 24.04.2021 11:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [bigint] NOT NULL,
	[Login] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[RoleID] [bigint] NOT NULL
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [PBD_lab] SET  READ_WRITE 
GO
