USE [master]
GO
/****** Object:  Database [BarInventory]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE DATABASE [BarInventory]
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BarInventory].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BarInventory] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BarInventory] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BarInventory] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BarInventory] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BarInventory] SET ARITHABORT OFF 
GO
ALTER DATABASE [BarInventory] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BarInventory] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BarInventory] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BarInventory] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BarInventory] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BarInventory] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BarInventory] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BarInventory] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BarInventory] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BarInventory] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BarInventory] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [BarInventory] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BarInventory] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [BarInventory] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BarInventory] SET  MULTI_USER 
GO
ALTER DATABASE [BarInventory] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BarInventory] SET QUERY_STORE = ON
GO
ALTER DATABASE [BarInventory] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BarInventory]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
USE [BarInventory]
GO
/****** Object:  Table [dbo].[AreaCounts]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AreaCounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InventoryItemId] [int] NOT NULL,
	[AreaId] [int] NOT NULL,
	[FullUnits] [int] NOT NULL,
	[PartialAmount] [decimal](4, 1) NOT NULL,
	[HasPartial] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[ModifiedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_AreaCounts_ItemArea] UNIQUE NONCLUSTERED 
(
	[InventoryItemId] ASC,
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerTypes]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[ModifiedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK__Containe__3214EC0794E30D7E] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InventoryAreas]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryAreas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[ShortCode] [nvarchar](10) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[ModifiedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InventoryFrequencies]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryFrequencies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[ModifiedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK__Inventor__3214EC07710CE56F] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InventoryItems]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SessionId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[UnitCost] [decimal](10, 2) NOT NULL,
	[StartingQuantity] [decimal](10, 2) NOT NULL,
	[ReceivedQuantity] [decimal](10, 2) NOT NULL,
	[ReceivedCost] [decimal](10, 2) NOT NULL,
	[ComputerSold] [decimal](10, 2) NOT NULL,
	[CreditedProduct] [decimal](10, 2) NOT NULL,
	[LastCountedAt] [datetime2](7) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[ModifiedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_InventoryItems_SessionProduct] UNIQUE NONCLUSTERED 
(
	[SessionId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InventorySessions]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventorySessions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SessionName] [nvarchar](200) NOT NULL,
	[SessionDate] [datetime2](7) NOT NULL,
	[CompletedAt] [datetime2](7) NULL,
	[Frequency] [int] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[IsComplete] [bit] NOT NULL,
	[CountedBy] [nvarchar](100) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[ModifiedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK__Inventor__3214EC07F36C3873] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LossRecords]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LossRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SessionId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[LossType] [int] NOT NULL,
	[Quantity] [decimal](10, 2) NOT NULL,
	[EstimatedValue] [decimal](10, 2) NOT NULL,
	[Reason] [nvarchar](500) NULL,
	[RecordedBy] [nvarchar](100) NULL,
	[OccurredAt] [datetime2](7) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[ModifiedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK__LossReco__3214EC07DD78814F] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LossTypes]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LossTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[ModifiedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK__LossType__3214EC0757AA98EE] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductCategories]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductCategories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[ModifiedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK__ProductC__3214EC074C0DA4D8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Brand] [nvarchar](200) NOT NULL,
	[Category] [int] NOT NULL,
	[ContainerType] [int] NOT NULL,
	[SizeDescription] [nvarchar](50) NOT NULL,
	[UnitCost] [decimal](10, 2) NOT NULL,
	[UnitPrice] [decimal](10, 2) NOT NULL,
	[ServingsPerUnit] [decimal](10, 2) NULL,
	[Barcode] [nvarchar](50) NULL,
	[Sku] [nvarchar](50) NULL,
	[IsActive] [bit] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[ModifiedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK__Products__3214EC0795B1D58C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_AreaCounts_AreaId]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_AreaCounts_AreaId] ON [dbo].[AreaCounts]
(
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_AreaCounts_InventoryItemId]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_AreaCounts_InventoryItemId] ON [dbo].[AreaCounts]
(
	[InventoryItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InventoryAreas_IsActive]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_InventoryAreas_IsActive] ON [dbo].[InventoryAreas]
(
	[IsActive] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InventoryItems_LastCounted]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_InventoryItems_LastCounted] ON [dbo].[InventoryItems]
(
	[SessionId] ASC,
	[LastCountedAt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InventoryItems_ProductId]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_InventoryItems_ProductId] ON [dbo].[InventoryItems]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InventoryItems_SessionId]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_InventoryItems_SessionId] ON [dbo].[InventoryItems]
(
	[SessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InventorySessions_IsComplete]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_InventorySessions_IsComplete] ON [dbo].[InventorySessions]
(
	[IsComplete] ASC,
	[SessionDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InventorySessions_SessionDate]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_InventorySessions_SessionDate] ON [dbo].[InventorySessions]
(
	[SessionDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LossRecords_LossType]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_LossRecords_LossType] ON [dbo].[LossRecords]
(
	[SessionId] ASC,
	[LossType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LossRecords_OccurredAt]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_LossRecords_OccurredAt] ON [dbo].[LossRecords]
(
	[OccurredAt] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LossRecords_ProductId]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_LossRecords_ProductId] ON [dbo].[LossRecords]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LossRecords_SessionId]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_LossRecords_SessionId] ON [dbo].[LossRecords]
(
	[SessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Products_Barcode]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_Products_Barcode] ON [dbo].[Products]
(
	[Barcode] ASC
)
WHERE ([Barcode] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Products_Category]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_Products_Category] ON [dbo].[Products]
(
	[Category] ASC
)
WHERE ([IsActive]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Products_IsActive]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_Products_IsActive] ON [dbo].[Products]
(
	[IsActive] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Products_Sku]    Script Date: 12/27/2025 2:48:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_Products_Sku] ON [dbo].[Products]
(
	[Sku] ASC
)
WHERE ([Sku] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AreaCounts] ADD  DEFAULT ((0)) FOR [FullUnits]
GO
ALTER TABLE [dbo].[AreaCounts] ADD  DEFAULT ((0)) FOR [PartialAmount]
GO
ALTER TABLE [dbo].[AreaCounts] ADD  DEFAULT ((0)) FOR [HasPartial]
GO
ALTER TABLE [dbo].[AreaCounts] ADD  DEFAULT (getutcdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AreaCounts] ADD  DEFAULT (getutcdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[ContainerTypes] ADD  CONSTRAINT [DF__Container__SortO__46B27FE2]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[ContainerTypes] ADD  CONSTRAINT [DF__Container__IsAct__47A6A41B]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ContainerTypes] ADD  CONSTRAINT [DF__Container__Creat__489AC854]  DEFAULT (getutcdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ContainerTypes] ADD  CONSTRAINT [DF__Container__Modif__498EEC8D]  DEFAULT (getutcdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[InventoryAreas] ADD  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[InventoryAreas] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[InventoryAreas] ADD  DEFAULT (getutcdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[InventoryAreas] ADD  DEFAULT (getutcdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[InventoryFrequencies] ADD  CONSTRAINT [DF__Inventory__SortO__59C55456]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[InventoryFrequencies] ADD  CONSTRAINT [DF__Inventory__IsAct__5AB9788F]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[InventoryFrequencies] ADD  CONSTRAINT [DF__Inventory__Creat__5BAD9CC8]  DEFAULT (getutcdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[InventoryFrequencies] ADD  CONSTRAINT [DF__Inventory__Modif__5CA1C101]  DEFAULT (getutcdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[InventoryItems] ADD  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[InventoryItems] ADD  DEFAULT ((0)) FOR [StartingQuantity]
GO
ALTER TABLE [dbo].[InventoryItems] ADD  DEFAULT ((0)) FOR [ReceivedQuantity]
GO
ALTER TABLE [dbo].[InventoryItems] ADD  DEFAULT ((0)) FOR [ReceivedCost]
GO
ALTER TABLE [dbo].[InventoryItems] ADD  DEFAULT ((0)) FOR [ComputerSold]
GO
ALTER TABLE [dbo].[InventoryItems] ADD  DEFAULT ((0)) FOR [CreditedProduct]
GO
ALTER TABLE [dbo].[InventoryItems] ADD  DEFAULT (getutcdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[InventoryItems] ADD  DEFAULT (getutcdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[InventorySessions] ADD  CONSTRAINT [DF__Inventory__Frequ__7F2BE32F]  DEFAULT ((1)) FOR [Frequency]
GO
ALTER TABLE [dbo].[InventorySessions] ADD  CONSTRAINT [DF__Inventory__IsCom__00200768]  DEFAULT ((0)) FOR [IsComplete]
GO
ALTER TABLE [dbo].[InventorySessions] ADD  CONSTRAINT [DF__Inventory__Count__01142BA1]  DEFAULT ('') FOR [CountedBy]
GO
ALTER TABLE [dbo].[InventorySessions] ADD  CONSTRAINT [DF__Inventory__Creat__02084FDA]  DEFAULT (getutcdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[InventorySessions] ADD  CONSTRAINT [DF__Inventory__Modif__02FC7413]  DEFAULT (getutcdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[LossRecords] ADD  CONSTRAINT [DF__LossRecor__Quant__1BC821DD]  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[LossRecords] ADD  CONSTRAINT [DF__LossRecor__Estim__1CBC4616]  DEFAULT ((0)) FOR [EstimatedValue]
GO
ALTER TABLE [dbo].[LossRecords] ADD  CONSTRAINT [DF__LossRecor__Creat__1DB06A4F]  DEFAULT (getutcdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[LossRecords] ADD  CONSTRAINT [DF__LossRecor__Modif__1EA48E88]  DEFAULT (getutcdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[LossTypes] ADD  CONSTRAINT [DF__LossTypes__SortO__540C7B00]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[LossTypes] ADD  CONSTRAINT [DF__LossTypes__IsAct__55009F39]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[LossTypes] ADD  CONSTRAINT [DF__LossTypes__Creat__55F4C372]  DEFAULT (getutcdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[LossTypes] ADD  CONSTRAINT [DF__LossTypes__Modif__56E8E7AB]  DEFAULT (getutcdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF__ProductCa__SortO__40F9A68C]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF__ProductCa__IsAct__41EDCAC5]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF__ProductCa__Creat__42E1EEFE]  DEFAULT (getutcdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF__ProductCa__Modif__43D61337]  DEFAULT (getutcdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__Brand__6FE99F9F]  DEFAULT ('') FOR [Brand]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__SizeDe__70DDC3D8]  DEFAULT ('') FOR [SizeDescription]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__UnitCo__71D1E811]  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__UnitPr__72C60C4A]  DEFAULT ((0)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__IsActi__73BA3083]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__SortOr__74AE54BC]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__Create__75A278F5]  DEFAULT (getutcdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF__Products__Modifi__76969D2E]  DEFAULT (getutcdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[AreaCounts]  WITH CHECK ADD  CONSTRAINT [FK_AreaCounts_Area] FOREIGN KEY([AreaId])
REFERENCES [dbo].[InventoryAreas] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AreaCounts] CHECK CONSTRAINT [FK_AreaCounts_Area]
GO
ALTER TABLE [dbo].[AreaCounts]  WITH CHECK ADD  CONSTRAINT [FK_AreaCounts_InventoryItem] FOREIGN KEY([InventoryItemId])
REFERENCES [dbo].[InventoryItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AreaCounts] CHECK CONSTRAINT [FK_AreaCounts_InventoryItem]
GO
ALTER TABLE [dbo].[InventoryItems]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItems_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[InventoryItems] CHECK CONSTRAINT [FK_InventoryItems_Product]
GO
ALTER TABLE [dbo].[InventoryItems]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItems_Session] FOREIGN KEY([SessionId])
REFERENCES [dbo].[InventorySessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[InventoryItems] CHECK CONSTRAINT [FK_InventoryItems_Session]
GO
ALTER TABLE [dbo].[LossRecords]  WITH CHECK ADD  CONSTRAINT [FK_LossRecords_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LossRecords] CHECK CONSTRAINT [FK_LossRecords_Product]
GO
ALTER TABLE [dbo].[LossRecords]  WITH CHECK ADD  CONSTRAINT [FK_LossRecords_Session] FOREIGN KEY([SessionId])
REFERENCES [dbo].[InventorySessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LossRecords] CHECK CONSTRAINT [FK_LossRecords_Session]
GO
