-- =====================================================
-- ClearSampleData.sql
-- Removes sample products, sessions, and counts
-- KEEPS reference/type tables intact:
--   - ProductCategories
--   - ContainerTypes
--   - LossTypes
--   - InventoryFrequencies
-- =====================================================

SET NOCOUNT ON;

PRINT 'Starting sample data cleanup...';
PRINT '(Keeping reference types: Categories, Container Types, Loss Types, Frequencies)';
PRINT '';

-- Clear transactional data (in reverse FK order)
DELETE FROM [dbo].[AreaCounts];
PRINT 'Cleared AreaCounts';

DELETE FROM [dbo].[LossRecords];
PRINT 'Cleared LossRecords';

DELETE FROM [dbo].[InventoryItems];
PRINT 'Cleared InventoryItems';

DELETE FROM [dbo].[InventorySessions];
PRINT 'Cleared InventorySessions';

DELETE FROM [dbo].[InventoryAreas];
PRINT 'Cleared InventoryAreas';

DELETE FROM [dbo].[Products];
PRINT 'Cleared Products';

-- Reset identity seeds for cleared tables only
DBCC CHECKIDENT ('Products', RESEED, 0);
DBCC CHECKIDENT ('InventoryAreas', RESEED, 0);
DBCC CHECKIDENT ('InventorySessions', RESEED, 0);
DBCC CHECKIDENT ('InventoryItems', RESEED, 0);
DBCC CHECKIDENT ('AreaCounts', RESEED, 0);
DBCC CHECKIDENT ('LossRecords', RESEED, 0);

PRINT '';
PRINT '=====================================================';
PRINT 'Sample data cleared successfully!';
PRINT '';
PRINT 'Reference data PRESERVED:';
SELECT 'ProductCategories' AS [Table], COUNT(*) AS [Records] FROM ProductCategories
UNION ALL
SELECT 'ContainerTypes', COUNT(*) FROM ContainerTypes
UNION ALL
SELECT 'LossTypes', COUNT(*) FROM LossTypes
UNION ALL
SELECT 'InventoryFrequencies', COUNT(*) FROM InventoryFrequencies;
PRINT '=====================================================';
