-- =====================================================
-- SeedReferenceData.sql
-- Inserts required reference/lookup table data only
-- Run AFTER BarDB-Tables.sql and BarDB-Procs.sql
-- Run BEFORE adding your own products and areas
-- =====================================================

SET NOCOUNT ON;

PRINT 'Seeding reference data...';

-- =====================================================
-- PRODUCT CATEGORIES
-- =====================================================
IF NOT EXISTS (SELECT 1 FROM [dbo].[ProductCategories])
BEGIN
    SET IDENTITY_INSERT [dbo].[ProductCategories] ON;
    INSERT INTO [dbo].[ProductCategories] (Id, [Name], SortOrder, IsActive, CreatedAt, ModifiedAt)
    VALUES
    (1, N'Spirits', 1, 1, GETUTCDATE(), GETUTCDATE()),
    (2, N'Wine', 2, 1, GETUTCDATE(), GETUTCDATE()),
    (3, N'Beer', 3, 1, GETUTCDATE(), GETUTCDATE()),
    (4, N'Mixers', 4, 1, GETUTCDATE(), GETUTCDATE()),
    (5, N'Other', 5, 1, GETUTCDATE(), GETUTCDATE());
    SET IDENTITY_INSERT [dbo].[ProductCategories] OFF;
    PRINT 'Inserted 5 product categories';
END
ELSE
    PRINT 'ProductCategories already has data - skipping';

-- =====================================================
-- CONTAINER TYPES
-- =====================================================
IF NOT EXISTS (SELECT 1 FROM [dbo].[ContainerTypes])
BEGIN
    SET IDENTITY_INSERT [dbo].[ContainerTypes] ON;
    INSERT INTO [dbo].[ContainerTypes] (Id, [Name], SortOrder, IsActive, CreatedAt, ModifiedAt)
    VALUES
    (1, N'Bottle', 1, 1, GETUTCDATE(), GETUTCDATE()),
    (2, N'Can', 2, 1, GETUTCDATE(), GETUTCDATE()),
    (3, N'Keg', 3, 1, GETUTCDATE(), GETUTCDATE()),
    (4, N'Box', 4, 1, GETUTCDATE(), GETUTCDATE());
    SET IDENTITY_INSERT [dbo].[ContainerTypes] OFF;
    PRINT 'Inserted 4 container types';
END
ELSE
    PRINT 'ContainerTypes already has data - skipping';

-- =====================================================
-- LOSS TYPES
-- =====================================================
IF NOT EXISTS (SELECT 1 FROM [dbo].[LossTypes])
BEGIN
    SET IDENTITY_INSERT [dbo].[LossTypes] ON;
    INSERT INTO [dbo].[LossTypes] (Id, [Name], SortOrder, IsActive, CreatedAt, ModifiedAt)
    VALUES
    (1, N'Spillage', 1, 1, GETUTCDATE(), GETUTCDATE()),
    (2, N'Breakage', 2, 1, GETUTCDATE(), GETUTCDATE()),
    (3, N'Theft', 3, 1, GETUTCDATE(), GETUTCDATE()),
    (4, N'Comp', 4, 1, GETUTCDATE(), GETUTCDATE()),
    (5, N'Waste', 5, 1, GETUTCDATE(), GETUTCDATE()),
    (6, N'Error', 6, 1, GETUTCDATE(), GETUTCDATE());
    SET IDENTITY_INSERT [dbo].[LossTypes] OFF;
    PRINT 'Inserted 6 loss types';
END
ELSE
    PRINT 'LossTypes already has data - skipping';

-- =====================================================
-- INVENTORY FREQUENCIES
-- =====================================================
IF NOT EXISTS (SELECT 1 FROM [dbo].[InventoryFrequencies])
BEGIN
    SET IDENTITY_INSERT [dbo].[InventoryFrequencies] ON;
    INSERT INTO [dbo].[InventoryFrequencies] (Id, [Name], SortOrder, IsActive, CreatedAt, ModifiedAt)
    VALUES
    (1, N'Daily', 1, 1, GETUTCDATE(), GETUTCDATE()),
    (2, N'Weekly', 2, 1, GETUTCDATE(), GETUTCDATE()),
    (3, N'Bi-Weekly', 3, 1, GETUTCDATE(), GETUTCDATE()),
    (4, N'Monthly', 4, 1, GETUTCDATE(), GETUTCDATE());
    SET IDENTITY_INSERT [dbo].[InventoryFrequencies] OFF;
    PRINT 'Inserted 4 inventory frequencies';
END
ELSE
    PRINT 'InventoryFrequencies already has data - skipping';

-- =====================================================
PRINT '';
PRINT '=====================================================';
PRINT 'Reference data seeding complete!';
PRINT '';
PRINT 'Next steps:';
PRINT '1. Add your Inventory Areas via Settings page';
PRINT '2. Add your Products via Products page';
PRINT '3. Create your first Session to start counting';
PRINT '=====================================================';
