-- =====================================================
-- BarInventory Sample Data
-- Run this after Schema.sql to populate test data
-- =====================================================

SET NOCOUNT ON;

-- Clear existing data (in reverse FK order)
DELETE FROM [dbo].[AreaCounts];
DELETE FROM [dbo].[LossRecords];
DELETE FROM [dbo].[InventoryItems];
DELETE FROM [dbo].[InventorySessions];
DELETE FROM [dbo].[InventoryAreas];
DELETE FROM [dbo].[Products];
DELETE FROM [dbo].[ProductCategories];
DELETE FROM [dbo].[ContainerTypes];
DELETE FROM [dbo].[LossTypes];
DELETE FROM [dbo].[InventoryFrequencies];

-- Reset identity seeds
DBCC CHECKIDENT ('Products', RESEED, 0);
DBCC CHECKIDENT ('InventoryAreas', RESEED, 0);
DBCC CHECKIDENT ('InventorySessions', RESEED, 0);
DBCC CHECKIDENT ('InventoryItems', RESEED, 0);
DBCC CHECKIDENT ('AreaCounts', RESEED, 0);
DBCC CHECKIDENT ('LossRecords', RESEED, 0);
DBCC CHECKIDENT ('ProductCategories', RESEED, 0);
DBCC CHECKIDENT ('ContainerTypes', RESEED, 0);
DBCC CHECKIDENT ('LossTypes', RESEED, 0);
DBCC CHECKIDENT ('InventoryFrequencies', RESEED, 0);

PRINT 'Cleared existing data and reset identity seeds';

-- =====================================================
-- LOOKUP TABLES
-- =====================================================

-- PRODUCT CATEGORIES
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

-- CONTAINER TYPES
SET IDENTITY_INSERT [dbo].[ContainerTypes] ON;
INSERT INTO [dbo].[ContainerTypes] (Id, [Name], SortOrder, IsActive, CreatedAt, ModifiedAt)
VALUES
(1, N'Bottle', 1, 1, GETUTCDATE(), GETUTCDATE()),
(2, N'Can', 2, 1, GETUTCDATE(), GETUTCDATE()),
(3, N'Keg', 3, 1, GETUTCDATE(), GETUTCDATE()),
(4, N'Box', 4, 1, GETUTCDATE(), GETUTCDATE());
SET IDENTITY_INSERT [dbo].[ContainerTypes] OFF;
PRINT 'Inserted 4 container types';

-- LOSS TYPES
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

-- INVENTORY FREQUENCIES
SET IDENTITY_INSERT [dbo].[InventoryFrequencies] ON;
INSERT INTO [dbo].[InventoryFrequencies] (Id, [Name], SortOrder, IsActive, CreatedAt, ModifiedAt)
VALUES
(1, N'Daily', 1, 1, GETUTCDATE(), GETUTCDATE()),
(2, N'Weekly', 2, 1, GETUTCDATE(), GETUTCDATE()),
(3, N'Bi-Weekly', 3, 1, GETUTCDATE(), GETUTCDATE()),
(4, N'Monthly', 4, 1, GETUTCDATE(), GETUTCDATE());
SET IDENTITY_INSERT [dbo].[InventoryFrequencies] OFF;
PRINT 'Inserted 4 inventory frequencies';

-- =====================================================
-- PRODUCTS
-- Category: 1=Spirits, 2=Wine, 3=Beer, 4=Mixers, 5=Other
-- ContainerType: 1=Bottle, 2=Can, 3=Keg, 4=Box
-- =====================================================

SET IDENTITY_INSERT [dbo].[Products] ON;

-- SPIRITS (Category 1)
INSERT INTO [dbo].[Products] (Id, [Name], Brand, Category, ContainerType, SizeDescription, UnitCost, UnitPrice, ServingsPerUnit, Barcode, Sku, IsActive, SortOrder, CreatedAt, ModifiedAt)
VALUES
-- Vodka
(1, N'Grey Goose Vodka', N'Grey Goose', 1, 1, N'1L', 32.99, 8.00, 22.00, N'080480280017', N'GG-VOD-1L', 1, 1, GETUTCDATE(), GETUTCDATE()),
(2, N'Tito''s Handmade Vodka', N'Tito''s', 1, 1, N'1.75L', 28.99, 7.00, 39.00, N'619947000013', N'TIT-VOD-175', 1, 2, GETUTCDATE(), GETUTCDATE()),
(3, N'Absolut Vodka', N'Absolut', 1, 1, N'1L', 22.99, 6.50, 22.00, N'835229000018', N'ABS-VOD-1L', 1, 3, GETUTCDATE(), GETUTCDATE()),
(4, N'Ketel One Vodka', N'Ketel One', 1, 1, N'1L', 29.99, 7.50, 22.00, N'085156510016', N'KET-VOD-1L', 1, 4, GETUTCDATE(), GETUTCDATE()),

-- Whiskey
(5, N'Jack Daniel''s Old No. 7', N'Jack Daniel''s', 1, 1, N'1L', 26.99, 7.00, 22.00, N'082184090343', N'JD-WHI-1L', 1, 10, GETUTCDATE(), GETUTCDATE()),
(6, N'Jameson Irish Whiskey', N'Jameson', 1, 1, N'1L', 28.99, 7.50, 22.00, N'080432400432', N'JAM-WHI-1L', 1, 11, GETUTCDATE(), GETUTCDATE()),
(7, N'Crown Royal', N'Crown Royal', 1, 1, N'1L', 31.99, 8.00, 22.00, N'087000007277', N'CR-WHI-1L', 1, 12, GETUTCDATE(), GETUTCDATE()),
(8, N'Bulleit Bourbon', N'Bulleit', 1, 1, N'1L', 32.99, 8.00, 22.00, N'087000005273', N'BUL-BOU-1L', 1, 13, GETUTCDATE(), GETUTCDATE()),
(9, N'Maker''s Mark', N'Maker''s Mark', 1, 1, N'1L', 34.99, 8.50, 22.00, N'085246139431', N'MM-BOU-1L', 1, 14, GETUTCDATE(), GETUTCDATE()),

-- Rum
(10, N'Bacardi Superior', N'Bacardi', 1, 1, N'1L', 15.99, 6.00, 22.00, N'080480015206', N'BAC-RUM-1L', 1, 20, GETUTCDATE(), GETUTCDATE()),
(11, N'Captain Morgan Spiced', N'Captain Morgan', 1, 1, N'1L', 18.99, 6.50, 22.00, N'087000007529', N'CM-RUM-1L', 1, 21, GETUTCDATE(), GETUTCDATE()),
(12, N'Malibu Coconut Rum', N'Malibu', 1, 1, N'1L', 17.99, 6.50, 22.00, N'089540420639', N'MAL-RUM-1L', 1, 22, GETUTCDATE(), GETUTCDATE()),

-- Tequila
(13, N'Patron Silver', N'Patron', 1, 1, N'750ml', 42.99, 10.00, 17.00, N'721733000012', N'PAT-TEQ-750', 1, 30, GETUTCDATE(), GETUTCDATE()),
(14, N'Jose Cuervo Gold', N'Jose Cuervo', 1, 1, N'1L', 21.99, 6.50, 22.00, N'082000001034', N'JC-TEQ-1L', 1, 31, GETUTCDATE(), GETUTCDATE()),
(15, N'Casamigos Blanco', N'Casamigos', 1, 1, N'750ml', 44.99, 11.00, 17.00, N'854545004001', N'CAS-TEQ-750', 1, 32, GETUTCDATE(), GETUTCDATE()),

-- Gin
(16, N'Tanqueray London Dry', N'Tanqueray', 1, 1, N'1L', 24.99, 7.00, 22.00, N'088110110017', N'TAN-GIN-1L', 1, 40, GETUTCDATE(), GETUTCDATE()),
(17, N'Bombay Sapphire', N'Bombay', 1, 1, N'1L', 27.99, 7.50, 22.00, N'080480301002', N'BOM-GIN-1L', 1, 41, GETUTCDATE(), GETUTCDATE()),
(18, N'Hendrick''s Gin', N'Hendrick''s', 1, 1, N'750ml', 34.99, 9.00, 17.00, N'083664868452', N'HEN-GIN-750', 1, 42, GETUTCDATE(), GETUTCDATE()),

-- Scotch
(19, N'Johnnie Walker Black', N'Johnnie Walker', 1, 1, N'1L', 36.99, 9.00, 22.00, N'088076174559', N'JW-BLK-1L', 1, 50, GETUTCDATE(), GETUTCDATE()),
(20, N'Glenlivet 12 Year', N'Glenlivet', 1, 1, N'750ml', 44.99, 11.00, 17.00, N'080432400579', N'GL-12-750', 1, 51, GETUTCDATE(), GETUTCDATE()),

-- Liqueurs
(21, N'Kahlua Coffee Liqueur', N'Kahlua', 1, 1, N'1L', 22.99, 7.00, 22.00, N'089540428192', N'KAH-LIQ-1L', 1, 60, GETUTCDATE(), GETUTCDATE()),
(22, N'Bailey''s Irish Cream', N'Bailey''s', 1, 1, N'1L', 26.99, 7.50, 22.00, N'086767210012', N'BAI-LIQ-1L', 1, 61, GETUTCDATE(), GETUTCDATE()),
(23, N'Grand Marnier', N'Grand Marnier', 1, 1, N'750ml', 36.99, 9.00, 17.00, N'080660355108', N'GM-LIQ-750', 1, 62, GETUTCDATE(), GETUTCDATE()),
(24, N'Cointreau', N'Cointreau', 1, 1, N'750ml', 34.99, 8.50, 17.00, N'089540000015', N'COI-LIQ-750', 1, 63, GETUTCDATE(), GETUTCDATE()),
(25, N'Amaretto Disaronno', N'Disaronno', 1, 1, N'750ml', 28.99, 7.50, 17.00, N'000049612003', N'DIS-AMA-750', 1, 64, GETUTCDATE(), GETUTCDATE()),

-- WINE (Category 2)
(26, N'Kendall Jackson Chardonnay', N'Kendall Jackson', 2, 1, N'750ml', 12.99, 9.00, 5.00, N'081240000012', N'KJ-CHAR-750', 1, 100, GETUTCDATE(), GETUTCDATE()),
(27, N'Kim Crawford Sauvignon Blanc', N'Kim Crawford', 2, 1, N'750ml', 14.99, 10.00, 5.00, N'854913001057', N'KC-SAUV-750', 1, 101, GETUTCDATE(), GETUTCDATE()),
(28, N'La Crema Pinot Noir', N'La Crema', 2, 1, N'750ml', 18.99, 12.00, 5.00, N'099988008627', N'LC-PINO-750', 1, 102, GETUTCDATE(), GETUTCDATE()),
(29, N'Josh Cellars Cabernet', N'Josh Cellars', 2, 1, N'750ml', 13.99, 10.00, 5.00, N'082420000009', N'JC-CAB-750', 1, 103, GETUTCDATE(), GETUTCDATE()),
(30, N'Meiomi Pinot Noir', N'Meiomi', 2, 1, N'750ml', 19.99, 13.00, 5.00, N'085000017470', N'MEI-PINO-750', 1, 104, GETUTCDATE(), GETUTCDATE()),
(31, N'Whispering Angel Rose', N'Chateau d''Esclans', 2, 1, N'750ml', 21.99, 14.00, 5.00, N'853173000019', N'WA-ROSE-750', 1, 105, GETUTCDATE(), GETUTCDATE()),
(32, N'Prosecco La Marca', N'La Marca', 2, 1, N'750ml', 14.99, 10.00, 5.00, N'086785112015', N'LM-PROS-750', 1, 106, GETUTCDATE(), GETUTCDATE()),
(33, N'House Red Blend', N'House', 2, 4, N'5L Box', 24.99, 8.00, 25.00, NULL, N'HOU-RED-5L', 1, 110, GETUTCDATE(), GETUTCDATE()),
(34, N'House White Blend', N'House', 2, 4, N'5L Box', 24.99, 8.00, 25.00, NULL, N'HOU-WHT-5L', 1, 111, GETUTCDATE(), GETUTCDATE()),

-- BEER (Category 3)
(35, N'Bud Light', N'Budweiser', 3, 3, N'1/2 Keg', 99.99, 5.00, 124.00, NULL, N'BUD-LT-KEG', 1, 200, GETUTCDATE(), GETUTCDATE()),
(36, N'Miller Lite', N'Miller', 3, 3, N'1/2 Keg', 95.99, 5.00, 124.00, NULL, N'MIL-LT-KEG', 1, 201, GETUTCDATE(), GETUTCDATE()),
(37, N'Coors Light', N'Coors', 3, 3, N'1/2 Keg', 95.99, 5.00, 124.00, NULL, N'COO-LT-KEG', 1, 202, GETUTCDATE(), GETUTCDATE()),
(38, N'Blue Moon Belgian White', N'Blue Moon', 3, 3, N'1/2 Keg', 159.99, 6.50, 124.00, NULL, N'BM-WHT-KEG', 1, 203, GETUTCDATE(), GETUTCDATE()),
(39, N'Yuengling Lager', N'Yuengling', 3, 3, N'1/2 Keg', 119.99, 5.50, 124.00, NULL, N'YUE-LAG-KEG', 1, 204, GETUTCDATE(), GETUTCDATE()),
(40, N'Sierra Nevada Pale Ale', N'Sierra Nevada', 3, 2, N'12oz 6-pack', 10.99, 5.50, 6.00, N'089000066129', N'SN-PA-6PK', 1, 210, GETUTCDATE(), GETUTCDATE()),
(41, N'Corona Extra', N'Corona', 3, 1, N'12oz 6-pack', 9.99, 5.00, 6.00, N'028200001245', N'COR-EX-6PK', 1, 211, GETUTCDATE(), GETUTCDATE()),
(42, N'Heineken', N'Heineken', 3, 1, N'12oz 6-pack', 10.99, 5.50, 6.00, N'731719110019', N'HEI-6PK', 1, 212, GETUTCDATE(), GETUTCDATE()),
(43, N'Guinness Draught', N'Guinness', 3, 2, N'14.9oz 4-pack', 11.99, 7.00, 4.00, N'088076174672', N'GUI-DRF-4PK', 1, 213, GETUTCDATE(), GETUTCDATE()),
(44, N'White Claw Variety Pack', N'White Claw', 3, 2, N'12oz 12-pack', 18.99, 6.00, 12.00, N'856134008000', N'WC-VAR-12', 1, 220, GETUTCDATE(), GETUTCDATE()),

-- MIXERS (Category 4)
(45, N'Coca-Cola', N'Coca-Cola', 4, 2, N'12oz 24-pack', 12.99, 3.00, 24.00, N'049000057898', N'COK-24PK', 1, 300, GETUTCDATE(), GETUTCDATE()),
(46, N'Sprite', N'Sprite', 4, 2, N'12oz 24-pack', 12.99, 3.00, 24.00, N'049000057881', N'SPR-24PK', 1, 301, GETUTCDATE(), GETUTCDATE()),
(47, N'Ginger Ale', N'Canada Dry', 4, 2, N'12oz 24-pack', 11.99, 3.00, 24.00, N'078000001525', N'CD-GA-24PK', 1, 302, GETUTCDATE(), GETUTCDATE()),
(48, N'Tonic Water', N'Schweppes', 4, 1, N'1L 6-pack', 8.99, 2.50, 6.00, N'078000007251', N'SCH-TON-6PK', 1, 303, GETUTCDATE(), GETUTCDATE()),
(49, N'Club Soda', N'Schweppes', 4, 1, N'1L 6-pack', 7.99, 2.00, 6.00, N'078000007268', N'SCH-CLB-6PK', 1, 304, GETUTCDATE(), GETUTCDATE()),
(50, N'Cranberry Juice', N'Ocean Spray', 4, 1, N'64oz', 4.99, 2.50, 8.00, N'031200200228', N'OS-CRAN-64', 1, 305, GETUTCDATE(), GETUTCDATE()),
(51, N'Orange Juice', N'Tropicana', 4, 1, N'64oz', 5.99, 2.50, 8.00, N'048500003565', N'TRO-OJ-64', 1, 306, GETUTCDATE(), GETUTCDATE()),
(52, N'Pineapple Juice', N'Dole', 4, 2, N'46oz', 3.99, 2.50, 6.00, N'038900008155', N'DOL-PIN-46', 1, 307, GETUTCDATE(), GETUTCDATE()),
(53, N'Grapefruit Juice', N'Ruby Red', 4, 1, N'64oz', 5.49, 2.50, 8.00, N'031200200235', N'RR-GFJ-64', 1, 308, GETUTCDATE(), GETUTCDATE()),
(54, N'Sweet & Sour Mix', N'Master of Mixes', 4, 1, N'1L', 4.99, 2.00, 22.00, N'070491022002', N'MOM-SS-1L', 1, 310, GETUTCDATE(), GETUTCDATE()),
(55, N'Margarita Mix', N'Master of Mixes', 4, 1, N'1L', 5.99, 2.00, 22.00, N'070491003001', N'MOM-MAR-1L', 1, 311, GETUTCDATE(), GETUTCDATE()),
(56, N'Bloody Mary Mix', N'Zing Zang', 4, 1, N'32oz', 6.99, 2.50, 8.00, N'072830000010', N'ZZ-BM-32', 1, 312, GETUTCDATE(), GETUTCDATE()),
(57, N'Grenadine', N'Rose''s', 4, 1, N'12oz', 4.99, 1.50, 24.00, N'041255200079', N'ROS-GREN-12', 1, 313, GETUTCDATE(), GETUTCDATE()),
(58, N'Simple Syrup', N'House Made', 4, 1, N'750ml', 2.50, 1.00, 25.00, NULL, N'HM-SS-750', 1, 314, GETUTCDATE(), GETUTCDATE()),

-- OTHER (Category 5)
(59, N'Angostura Bitters', N'Angostura', 5, 1, N'4oz', 8.99, 0.50, 100.00, N'075496331129', N'ANG-BIT-4', 1, 400, GETUTCDATE(), GETUTCDATE()),
(60, N'Orange Bitters', N'Fee Brothers', 5, 1, N'5oz', 7.99, 0.50, 100.00, N'791863140582', N'FB-OBIT-5', 1, 401, GETUTCDATE(), GETUTCDATE()),
(61, N'Maraschino Cherries', N'Luxardo', 5, 1, N'14oz jar', 22.99, 1.00, 50.00, N'846813000042', N'LUX-CHR-14', 1, 402, GETUTCDATE(), GETUTCDATE()),
(62, N'Cocktail Olives', N'Filthy', 5, 1, N'8oz jar', 12.99, 0.75, 40.00, N'185060000012', N'FIL-OLV-8', 1, 403, GETUTCDATE(), GETUTCDATE()),
(63, N'Cocktail Onions', N'Collins', 5, 1, N'8oz jar', 6.99, 0.50, 40.00, N'047200200048', N'COL-ONI-8', 1, 404, GETUTCDATE(), GETUTCDATE()),
(64, N'Limes', N'Fresh', 5, 1, N'Case of 50', 19.99, 0.50, 50.00, NULL, N'FRS-LIM-50', 1, 405, GETUTCDATE(), GETUTCDATE()),
(65, N'Lemons', N'Fresh', 5, 1, N'Case of 50', 24.99, 0.50, 50.00, NULL, N'FRS-LEM-50', 1, 406, GETUTCDATE(), GETUTCDATE()),
(66, N'Oranges', N'Fresh', 5, 1, N'Case of 25', 22.99, 0.75, 25.00, NULL, N'FRS-ORA-25', 1, 407, GETUTCDATE(), GETUTCDATE());

SET IDENTITY_INSERT [dbo].[Products] OFF;

PRINT 'Inserted 66 products';

-- =====================================================
-- INVENTORY AREAS
-- =====================================================

SET IDENTITY_INSERT [dbo].[InventoryAreas] ON;

INSERT INTO [dbo].[InventoryAreas] (Id, [Name], ShortCode, SortOrder, IsActive, CreatedAt, ModifiedAt)
VALUES
(1, N'Main Bar Well', N'WELL', 1, 1, GETUTCDATE(), GETUTCDATE()),
(2, N'Main Bar Back', N'BACK', 2, 1, GETUTCDATE(), GETUTCDATE()),
(3, N'Main Bar Display', N'DISP', 3, 1, GETUTCDATE(), GETUTCDATE()),
(4, N'Service Bar', N'SVC', 4, 1, GETUTCDATE(), GETUTCDATE()),
(5, N'Walk-in Cooler', N'COOL', 5, 1, GETUTCDATE(), GETUTCDATE()),
(6, N'Dry Storage', N'DRY', 6, 1, GETUTCDATE(), GETUTCDATE()),
(7, N'Patio Bar', N'PATIO', 7, 1, GETUTCDATE(), GETUTCDATE()),
(8, N'Keg Room', N'KEGS', 8, 1, GETUTCDATE(), GETUTCDATE());

SET IDENTITY_INSERT [dbo].[InventoryAreas] OFF;

PRINT 'Inserted 8 inventory areas';

-- =====================================================
-- INVENTORY SESSIONS
-- Frequency: 1=Daily, 2=Weekly, 3=BiWeekly, 4=Monthly
-- =====================================================

SET IDENTITY_INSERT [dbo].[InventorySessions] ON;

INSERT INTO [dbo].[InventorySessions] (Id, SessionName, SessionDate, CompletedAt, Frequency, Notes, IsComplete, CountedBy, CreatedAt, ModifiedAt)
VALUES
-- Completed sessions (historical)
(1, N'Week 50 - December 2025', '2025-12-16 09:00:00', '2025-12-16 11:45:00', 2, N'Regular weekly count. Minor variance on vodka.', 1, N'Mike Johnson', GETUTCDATE(), GETUTCDATE()),
(2, N'Week 51 - December 2025', '2025-12-23 09:00:00', '2025-12-23 12:30:00', 2, N'Pre-holiday count. Stocked up for busy weekend.', 1, N'Sarah Williams', GETUTCDATE(), GETUTCDATE()),
-- Current active session
(3, N'Week 52 - December 2025', '2025-12-26 08:00:00', NULL, 2, N'Post-Christmas inventory count in progress.', 0, N'Auto-created', GETUTCDATE(), GETUTCDATE());

SET IDENTITY_INSERT [dbo].[InventorySessions] OFF;

PRINT 'Inserted 3 inventory sessions';

-- =====================================================
-- INVENTORY ITEMS
-- Linking products to sessions with counts
-- =====================================================

SET IDENTITY_INSERT [dbo].[InventoryItems] ON;

-- Session 1 (Week 50) - Some example items
INSERT INTO [dbo].[InventoryItems] (Id, SessionId, ProductId, UnitCost, StartingQuantity, ReceivedQuantity, ReceivedCost, ComputerSold, CreditedProduct, LastCountedAt, CreatedAt, ModifiedAt)
VALUES
(1, 1, 1, 32.99, 8.0, 6.0, 197.94, 5.5, 0.0, '2025-12-16 10:15:00', GETUTCDATE(), GETUTCDATE()),  -- Grey Goose
(2, 1, 2, 28.99, 12.0, 6.0, 173.94, 8.0, 0.0, '2025-12-16 10:18:00', GETUTCDATE(), GETUTCDATE()),  -- Tito's
(3, 1, 5, 26.99, 6.0, 6.0, 161.94, 4.5, 0.5, '2025-12-16 10:22:00', GETUTCDATE(), GETUTCDATE()),  -- Jack Daniel's
(4, 1, 6, 28.99, 5.0, 6.0, 173.94, 4.0, 0.0, '2025-12-16 10:25:00', GETUTCDATE(), GETUTCDATE()),  -- Jameson
(5, 1, 10, 15.99, 8.0, 6.0, 95.94, 5.0, 0.0, '2025-12-16 10:30:00', GETUTCDATE(), GETUTCDATE());  -- Bacardi

-- Session 2 (Week 51) - More items
INSERT INTO [dbo].[InventoryItems] (Id, SessionId, ProductId, UnitCost, StartingQuantity, ReceivedQuantity, ReceivedCost, ComputerSold, CreditedProduct, LastCountedAt, CreatedAt, ModifiedAt)
VALUES
(6, 2, 1, 32.99, 8.5, 12.0, 395.88, 7.0, 0.0, '2025-12-23 10:00:00', GETUTCDATE(), GETUTCDATE()),  -- Grey Goose
(7, 2, 2, 28.99, 10.0, 12.0, 347.88, 10.5, 0.0, '2025-12-23 10:05:00', GETUTCDATE(), GETUTCDATE()),  -- Tito's
(8, 2, 5, 26.99, 7.0, 12.0, 323.88, 8.0, 0.0, '2025-12-23 10:10:00', GETUTCDATE(), GETUTCDATE()),  -- Jack Daniel's
(9, 2, 6, 28.99, 7.0, 6.0, 173.94, 5.5, 0.0, '2025-12-23 10:15:00', GETUTCDATE(), GETUTCDATE()),  -- Jameson
(10, 2, 10, 15.99, 9.0, 12.0, 191.88, 8.0, 0.0, '2025-12-23 10:20:00', GETUTCDATE(), GETUTCDATE()),  -- Bacardi
(11, 2, 11, 18.99, 6.0, 6.0, 113.94, 5.0, 0.0, '2025-12-23 10:25:00', GETUTCDATE(), GETUTCDATE()),  -- Captain Morgan
(12, 2, 13, 42.99, 4.0, 6.0, 257.94, 3.5, 0.0, '2025-12-23 10:30:00', GETUTCDATE(), GETUTCDATE()),  -- Patron
(13, 2, 16, 24.99, 5.0, 6.0, 149.94, 4.0, 0.0, '2025-12-23 10:35:00', GETUTCDATE(), GETUTCDATE()),  -- Tanqueray
(14, 2, 21, 22.99, 3.0, 4.0, 91.96, 2.5, 0.0, '2025-12-23 10:40:00', GETUTCDATE(), GETUTCDATE()),  -- Kahlua
(15, 2, 35, 99.99, 2.0, 2.0, 199.98, 1.0, 0.0, '2025-12-23 11:00:00', GETUTCDATE(), GETUTCDATE());  -- Bud Light Keg

-- Session 3 (Week 52) - Current session in progress
INSERT INTO [dbo].[InventoryItems] (Id, SessionId, ProductId, UnitCost, StartingQuantity, ReceivedQuantity, ReceivedCost, ComputerSold, CreditedProduct, LastCountedAt, CreatedAt, ModifiedAt)
VALUES
(16, 3, 1, 32.99, 13.5, 0.0, 0.0, 6.0, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Grey Goose (not counted yet)
(17, 3, 2, 28.99, 11.5, 0.0, 0.0, 8.0, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Tito's
(18, 3, 3, 22.99, 6.0, 6.0, 137.94, 3.5, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Absolut
(19, 3, 4, 29.99, 4.0, 3.0, 89.97, 2.5, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Ketel One
(20, 3, 5, 26.99, 11.0, 0.0, 0.0, 5.5, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Jack Daniel's
(21, 3, 6, 28.99, 7.5, 0.0, 0.0, 4.0, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Jameson
(22, 3, 7, 31.99, 5.0, 6.0, 191.94, 3.5, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Crown Royal
(23, 3, 8, 32.99, 3.0, 3.0, 98.97, 2.0, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Bulleit
(24, 3, 10, 15.99, 13.0, 0.0, 0.0, 6.5, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Bacardi
(25, 3, 11, 18.99, 7.0, 0.0, 0.0, 4.0, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Captain Morgan
(26, 3, 13, 42.99, 6.5, 0.0, 0.0, 3.0, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Patron
(27, 3, 14, 21.99, 8.0, 6.0, 131.94, 5.5, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Jose Cuervo
(28, 3, 16, 24.99, 7.0, 0.0, 0.0, 3.5, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Tanqueray
(29, 3, 17, 27.99, 4.0, 3.0, 83.97, 2.5, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Bombay Sapphire
(30, 3, 21, 22.99, 4.5, 0.0, 0.0, 2.0, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Kahlua
(31, 3, 22, 26.99, 3.0, 3.0, 80.97, 2.0, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Bailey's
(32, 3, 26, 12.99, 8.0, 12.0, 155.88, 6.0, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Kendall Jackson
(33, 3, 29, 13.99, 10.0, 12.0, 167.88, 7.0, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Josh Cabernet
(34, 3, 35, 99.99, 3.0, 1.0, 99.99, 1.5, 0.0, NULL, GETUTCDATE(), GETUTCDATE()),  -- Bud Light Keg
(35, 3, 38, 159.99, 2.0, 1.0, 159.99, 1.0, 0.0, NULL, GETUTCDATE(), GETUTCDATE());  -- Blue Moon Keg

SET IDENTITY_INSERT [dbo].[InventoryItems] OFF;

PRINT 'Inserted 35 inventory items';

-- =====================================================
-- AREA COUNTS
-- Counts for current session items across areas
-- =====================================================

SET IDENTITY_INSERT [dbo].[AreaCounts] ON;

-- Grey Goose (Item 16) - spread across areas
INSERT INTO [dbo].[AreaCounts] (Id, InventoryItemId, AreaId, FullUnits, PartialAmount, HasPartial, CreatedAt, ModifiedAt)
VALUES
(1, 16, 1, 2, 0.0, 0, GETUTCDATE(), GETUTCDATE()),   -- Well: 2 full
(2, 16, 2, 3, 0.0, 0, GETUTCDATE(), GETUTCDATE()),   -- Back Bar: 3 full
(3, 16, 5, 6, 0.0, 0, GETUTCDATE(), GETUTCDATE());   -- Walk-in: 6 full (backup stock)

-- Tito's (Item 17)
INSERT INTO [dbo].[AreaCounts] (Id, InventoryItemId, AreaId, FullUnits, PartialAmount, HasPartial, CreatedAt, ModifiedAt)
VALUES
(4, 17, 1, 2, 5.0, 1, GETUTCDATE(), GETUTCDATE()),   -- Well: 2 full + half bottle
(5, 17, 2, 2, 0.0, 0, GETUTCDATE(), GETUTCDATE()),   -- Back Bar: 2 full
(6, 17, 5, 8, 0.0, 0, GETUTCDATE(), GETUTCDATE());   -- Walk-in: 8 full

-- Jack Daniel's (Item 20)
INSERT INTO [dbo].[AreaCounts] (Id, InventoryItemId, AreaId, FullUnits, PartialAmount, HasPartial, CreatedAt, ModifiedAt)
VALUES
(7, 20, 1, 1, 7.0, 1, GETUTCDATE(), GETUTCDATE()),   -- Well: 1 full + 70%
(8, 20, 2, 2, 0.0, 0, GETUTCDATE(), GETUTCDATE()),   -- Back Bar: 2 full
(9, 20, 5, 4, 0.0, 0, GETUTCDATE(), GETUTCDATE());   -- Walk-in: 4 full

-- Jameson (Item 21)
INSERT INTO [dbo].[AreaCounts] (Id, InventoryItemId, AreaId, FullUnits, PartialAmount, HasPartial, CreatedAt, ModifiedAt)
VALUES
(10, 21, 1, 1, 3.0, 1, GETUTCDATE(), GETUTCDATE()),  -- Well: 1 full + 30%
(11, 21, 2, 2, 0.0, 0, GETUTCDATE(), GETUTCDATE()),  -- Back Bar: 2 full
(12, 21, 5, 3, 0.0, 0, GETUTCDATE(), GETUTCDATE());  -- Walk-in: 3 full

-- Patron (Item 26)
INSERT INTO [dbo].[AreaCounts] (Id, InventoryItemId, AreaId, FullUnits, PartialAmount, HasPartial, CreatedAt, ModifiedAt)
VALUES
(13, 26, 2, 2, 0.0, 0, GETUTCDATE(), GETUTCDATE()),  -- Back Bar: 2 full
(14, 26, 3, 1, 5.0, 1, GETUTCDATE(), GETUTCDATE()),  -- Display: 1 + half
(15, 26, 5, 3, 0.0, 0, GETUTCDATE(), GETUTCDATE());  -- Walk-in: 3 full

-- Bud Light Keg (Item 34)
INSERT INTO [dbo].[AreaCounts] (Id, InventoryItemId, AreaId, FullUnits, PartialAmount, HasPartial, CreatedAt, ModifiedAt)
VALUES
(16, 34, 8, 2, 5.0, 1, GETUTCDATE(), GETUTCDATE());  -- Keg Room: 2 full + one half

-- Blue Moon Keg (Item 35)
INSERT INTO [dbo].[AreaCounts] (Id, InventoryItemId, AreaId, FullUnits, PartialAmount, HasPartial, CreatedAt, ModifiedAt)
VALUES
(17, 35, 8, 2, 0.0, 0, GETUTCDATE(), GETUTCDATE());  -- Keg Room: 2 full

SET IDENTITY_INSERT [dbo].[AreaCounts] OFF;

PRINT 'Inserted 17 area counts';

-- =====================================================
-- LOSS RECORDS
-- LossType: 1=Spillage, 2=Breakage, 3=Theft, 4=Comp, 5=Waste, 6=Error
-- =====================================================

SET IDENTITY_INSERT [dbo].[LossRecords] ON;

INSERT INTO [dbo].[LossRecords] (Id, SessionId, ProductId, LossType, Quantity, EstimatedValue, Reason, RecordedBy, OccurredAt, CreatedAt, ModifiedAt)
VALUES
-- Session 1 losses
(1, 1, 1, 1, 0.25, 8.25, N'Spilled during busy rush', N'Mike Johnson', '2025-12-14 22:30:00', GETUTCDATE(), GETUTCDATE()),  -- Grey Goose spillage
(2, 1, 5, 4, 0.50, 13.50, N'Comped drink for regular customer birthday', N'Mike Johnson', '2025-12-15 21:00:00', GETUTCDATE(), GETUTCDATE()),  -- Jack comped

-- Session 2 losses
(3, 2, 13, 2, 1.00, 42.99, N'Bottle dropped and broke during stocking', N'Sarah Williams', '2025-12-20 14:00:00', GETUTCDATE(), GETUTCDATE()),  -- Patron breakage
(4, 2, 2, 1, 0.15, 4.35, N'Overpour corrected', N'Sarah Williams', '2025-12-21 23:15:00', GETUTCDATE(), GETUTCDATE()),  -- Tito's spillage
(5, 2, 26, 5, 2.00, 25.98, N'Wine past prime, customer rejected', N'Tom Baker', '2025-12-22 19:30:00', GETUTCDATE(), GETUTCDATE()),  -- Wine waste
(6, 2, 6, 4, 1.00, 28.99, N'Comped round for office holiday party', N'Sarah Williams', '2025-12-22 21:00:00', GETUTCDATE(), GETUTCDATE()),  -- Jameson comped

-- Session 3 losses (current)
(7, 3, 1, 1, 0.10, 3.30, N'Bar mat spill cleanup', N'Auto-created', '2025-12-25 20:45:00', GETUTCDATE(), GETUTCDATE()),  -- Grey Goose
(8, 3, 17, 2, 1.00, 27.99, N'Bottle cracked during delivery', N'Delivery', '2025-12-26 10:00:00', GETUTCDATE(), GETUTCDATE()),  -- Bombay breakage
(9, 3, 29, 5, 1.00, 13.99, N'Cork failure - wine oxidized', N'Mike Johnson', '2025-12-26 18:00:00', GETUTCDATE(), GETUTCDATE()),  -- Josh Cab waste
(10, 3, 8, 4, 0.50, 16.50, N'Owner comp for VIP guest', N'Manager', '2025-12-26 20:00:00', GETUTCDATE(), GETUTCDATE());  -- Bulleit comp

SET IDENTITY_INSERT [dbo].[LossRecords] OFF;

PRINT 'Inserted 10 loss records';

-- =====================================================
-- Summary
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT 'Sample Data Import Complete';
PRINT '========================================';
PRINT 'ProductCategories:  5';
PRINT 'ContainerTypes:     4';
PRINT 'LossTypes:          6';
PRINT 'InventoryFreq:      4';
PRINT 'Products:           66';
PRINT 'Inventory Areas:    8';
PRINT 'Sessions:           3 (2 complete, 1 active)';
PRINT 'Inventory Items:    35';
PRINT 'Area Counts:        17';
PRINT 'Loss Records:       10';
PRINT '========================================';

SELECT 'ProductCategories' AS TableName, COUNT(*) AS RecordCount FROM ProductCategories
UNION ALL SELECT 'ContainerTypes', COUNT(*) FROM ContainerTypes
UNION ALL SELECT 'LossTypes', COUNT(*) FROM LossTypes
UNION ALL SELECT 'InventoryFrequencies', COUNT(*) FROM InventoryFrequencies
UNION ALL SELECT 'Products', COUNT(*) FROM Products
UNION ALL SELECT 'InventoryAreas', COUNT(*) FROM InventoryAreas
UNION ALL SELECT 'InventorySessions', COUNT(*) FROM InventorySessions
UNION ALL SELECT 'InventoryItems', COUNT(*) FROM InventoryItems
UNION ALL SELECT 'AreaCounts', COUNT(*) FROM AreaCounts
UNION ALL SELECT 'LossRecords', COUNT(*) FROM LossRecords;
