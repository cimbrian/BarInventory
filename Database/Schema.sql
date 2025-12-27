-- ============================================================================
-- BAR INVENTORY DATABASE SCHEMA
-- Microsoft SQL Server
-- ============================================================================

-- Run this script against your BarInventory database
-- USE BarInventory
-- GO

-- ============================================================================
-- TABLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Products - Master product catalog
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
BEGIN
    CREATE TABLE Products (
        Id                  INT IDENTITY(1,1) PRIMARY KEY,
        Name                NVARCHAR(200) NOT NULL,
        Brand               NVARCHAR(200) NOT NULL DEFAULT '',
        Category            TINYINT NOT NULL,           -- 0=Liquor, 1=Wine, 2=BeerBottle, 3=BeerCan, 4=DraftBeer, 5=Seltzer, 6=Mixers, 7=Other
        ContainerType       TINYINT NOT NULL,           -- See ContainerType enum
        SizeDescription     NVARCHAR(50) NOT NULL DEFAULT '',
        UnitCost            DECIMAL(10,2) NOT NULL DEFAULT 0,
        UnitPrice           DECIMAL(10,2) NOT NULL DEFAULT 0,
        ServingsPerUnit     DECIMAL(10,2) NULL,
        Barcode             NVARCHAR(50) NULL,
        Sku                 NVARCHAR(50) NULL,
        IsActive            BIT NOT NULL DEFAULT 1,
        SortOrder           INT NOT NULL DEFAULT 0,
        CreatedAt           DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        ModifiedAt          DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
END
GO

-- ----------------------------------------------------------------------------
-- InventoryAreas - Locations within the bar
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'InventoryAreas')
BEGIN
    CREATE TABLE InventoryAreas (
        Id                  INT IDENTITY(1,1) PRIMARY KEY,
        Name                NVARCHAR(100) NOT NULL,
        ShortCode           NVARCHAR(10) NOT NULL,
        SortOrder           INT NOT NULL DEFAULT 0,
        IsActive            BIT NOT NULL DEFAULT 1,
        CreatedAt           DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        ModifiedAt          DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
END
GO

-- ----------------------------------------------------------------------------
-- InventorySessions - Inventory counting periods
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'InventorySessions')
BEGIN
    CREATE TABLE InventorySessions (
        Id                  INT IDENTITY(1,1) PRIMARY KEY,
        SessionName         NVARCHAR(200) NOT NULL,
        SessionDate         DATETIME2 NOT NULL,
        CompletedAt         DATETIME2 NULL,
        Frequency           TINYINT NOT NULL DEFAULT 1, -- 0=Daily, 1=Weekly, 2=BiWeekly, 3=Monthly
        Notes               NVARCHAR(MAX) NULL,
        IsComplete          BIT NOT NULL DEFAULT 0,
        CountedBy           NVARCHAR(100) NOT NULL DEFAULT '',
        CreatedAt           DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        ModifiedAt          DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
END
GO

-- ----------------------------------------------------------------------------
-- InventoryItems - Line items for each session (one per product per session)
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'InventoryItems')
BEGIN
    CREATE TABLE InventoryItems (
        Id                  INT IDENTITY(1,1) PRIMARY KEY,
        SessionId           INT NOT NULL,
        ProductId           INT NOT NULL,
        UnitCost            DECIMAL(10,2) NOT NULL DEFAULT 0,
        StartingQuantity    DECIMAL(10,2) NOT NULL DEFAULT 0,
        ReceivedQuantity    DECIMAL(10,2) NOT NULL DEFAULT 0,
        ReceivedCost        DECIMAL(10,2) NOT NULL DEFAULT 0,
        ComputerSold        DECIMAL(10,2) NOT NULL DEFAULT 0,     -- POS sold quantity
        CreditedProduct     DECIMAL(10,2) NOT NULL DEFAULT 0,
        LastCountedAt       DATETIME2 NULL,
        CreatedAt           DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        ModifiedAt          DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        
        CONSTRAINT FK_InventoryItems_Session FOREIGN KEY (SessionId) 
            REFERENCES InventorySessions(Id) ON DELETE CASCADE,
        CONSTRAINT FK_InventoryItems_Product FOREIGN KEY (ProductId) 
            REFERENCES Products(Id) ON DELETE CASCADE,
        CONSTRAINT UQ_InventoryItems_SessionProduct UNIQUE (SessionId, ProductId)
    );
END
GO

-- ----------------------------------------------------------------------------
-- AreaCounts - Counts per area for each inventory item
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AreaCounts')
BEGIN
    CREATE TABLE AreaCounts (
        Id                  INT IDENTITY(1,1) PRIMARY KEY,
        InventoryItemId     INT NOT NULL,
        AreaId              INT NOT NULL,
        FullUnits           INT NOT NULL DEFAULT 0,
        PartialAmount       DECIMAL(4,1) NOT NULL DEFAULT 0,  -- 0-10 scale
        HasPartial          BIT NOT NULL DEFAULT 0,
        CreatedAt           DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        ModifiedAt          DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        
        CONSTRAINT FK_AreaCounts_InventoryItem FOREIGN KEY (InventoryItemId) 
            REFERENCES InventoryItems(Id) ON DELETE CASCADE,
        CONSTRAINT FK_AreaCounts_Area FOREIGN KEY (AreaId) 
            REFERENCES InventoryAreas(Id) ON DELETE CASCADE,
        CONSTRAINT UQ_AreaCounts_ItemArea UNIQUE (InventoryItemId, AreaId)
    );
END
GO

-- ----------------------------------------------------------------------------
-- LossRecords - Breakage, spillage, comps, returns tracking
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LossRecords')
BEGIN
    CREATE TABLE LossRecords (
        Id                  INT IDENTITY(1,1) PRIMARY KEY,
        SessionId           INT NOT NULL,
        ProductId           INT NOT NULL,
        LossType            TINYINT NOT NULL,           -- See LossType enum
        Quantity            DECIMAL(10,2) NOT NULL DEFAULT 0,
        EstimatedValue      DECIMAL(10,2) NOT NULL DEFAULT 0,
        Reason              NVARCHAR(500) NULL,
        RecordedBy          NVARCHAR(100) NULL,
        OccurredAt          DATETIME2 NOT NULL,
        CreatedAt           DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        ModifiedAt          DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        
        CONSTRAINT FK_LossRecords_Session FOREIGN KEY (SessionId) 
            REFERENCES InventorySessions(Id) ON DELETE CASCADE,
        CONSTRAINT FK_LossRecords_Product FOREIGN KEY (ProductId) 
            REFERENCES Products(Id) ON DELETE CASCADE
    );
END
GO


-- ============================================================================
-- INDEXES
-- ============================================================================

-- Products indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_Category')
    CREATE INDEX IX_Products_Category ON Products(Category) WHERE IsActive = 1;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_IsActive')
    CREATE INDEX IX_Products_IsActive ON Products(IsActive, SortOrder);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_Barcode')
    CREATE INDEX IX_Products_Barcode ON Products(Barcode) WHERE Barcode IS NOT NULL;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_Sku')
    CREATE INDEX IX_Products_Sku ON Products(Sku) WHERE Sku IS NOT NULL;

-- InventoryAreas indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_InventoryAreas_IsActive')
    CREATE INDEX IX_InventoryAreas_IsActive ON InventoryAreas(IsActive, SortOrder);

-- InventorySessions indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_InventorySessions_SessionDate')
    CREATE INDEX IX_InventorySessions_SessionDate ON InventorySessions(SessionDate DESC);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_InventorySessions_IsComplete')
    CREATE INDEX IX_InventorySessions_IsComplete ON InventorySessions(IsComplete, SessionDate DESC);

-- InventoryItems indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_InventoryItems_SessionId')
    CREATE INDEX IX_InventoryItems_SessionId ON InventoryItems(SessionId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_InventoryItems_ProductId')
    CREATE INDEX IX_InventoryItems_ProductId ON InventoryItems(ProductId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_InventoryItems_LastCounted')
    CREATE INDEX IX_InventoryItems_LastCounted ON InventoryItems(SessionId, LastCountedAt);

-- AreaCounts indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_AreaCounts_InventoryItemId')
    CREATE INDEX IX_AreaCounts_InventoryItemId ON AreaCounts(InventoryItemId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_AreaCounts_AreaId')
    CREATE INDEX IX_AreaCounts_AreaId ON AreaCounts(AreaId);

-- LossRecords indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_LossRecords_SessionId')
    CREATE INDEX IX_LossRecords_SessionId ON LossRecords(SessionId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_LossRecords_ProductId')
    CREATE INDEX IX_LossRecords_ProductId ON LossRecords(ProductId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_LossRecords_LossType')
    CREATE INDEX IX_LossRecords_LossType ON LossRecords(SessionId, LossType);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_LossRecords_OccurredAt')
    CREATE INDEX IX_LossRecords_OccurredAt ON LossRecords(OccurredAt DESC);

GO

-- ============================================================================
-- ENUM REFERENCE (for documentation)
-- ============================================================================
/*
ProductCategory:
    0 = Liquor
    1 = Wine
    2 = BeerBottle
    3 = BeerCan
    4 = DraftBeer
    5 = Seltzer
    6 = Mixers
    7 = Other

ContainerType:
    0 = Bottle750ml
    1 = Bottle1L
    2 = Bottle1_75L
    3 = Bottle375ml
    4 = Can12oz
    5 = Can16oz
    6 = Can19_2oz
    7 = Bottle12oz
    8 = Bottle22oz
    9 = KegHalfBarrel
    10 = KegQuarterBarrel
    11 = KegSixtel
    12 = WineBottle750ml
    13 = WineBottle1_5L
    14 = BoxWine3L
    15 = Other

InventoryFrequency:
    0 = Daily
    1 = Weekly
    2 = BiWeekly
    3 = Monthly

LossType:
    0 = Breakage
    1 = Spoilage
    2 = Spillage
    3 = Comp
    4 = ManagerComp
    5 = CustomerReturn
    6 = MixingError
    7 = Overpouring
    8 = Theft
    9 = Training
    10 = Sampling
    11 = Other
*/

-- ============================================================================
-- SAMPLE SEED DATA FOR AREAS (optional - run once)
-- ============================================================================
/*
INSERT INTO InventoryAreas (Name, ShortCode, SortOrder) VALUES 
    ('Main Bar', 'MB', 1),
    ('Back Bar', 'BB', 2),
    ('Service Well', 'SW', 3),
    ('Walk-in Cooler', 'WC', 4),
    ('Storage Room', 'SR', 5),
    ('Patio Bar', 'PB', 6);
*/

PRINT 'BarInventory schema created successfully.';
GO
