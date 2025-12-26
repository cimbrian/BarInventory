using BarInventory.Models;

namespace BarInventory.Services;

/// <summary>
/// Inventory service with SQL Server persistence
/// LoadData methods: Call stored procedures to load from database
/// SaveData methods: Call stored procedures to save to database
/// </summary>
public class InventoryService
{
    // In-memory cache (populated from database via LoadData methods)
    private List<Product> _products = new();
    private List<InventoryArea> _areas = new();
    private List<InventorySession> _sessions = new();
    private List<InventoryItem> _inventoryItems = new();
    private List<LossRecord> _losses = new();
    
    // For in-memory mode (remove when fully connected to SQL)
    private int _nextProductId = 1;
    private int _nextAreaId = 1;
    private int _nextSessionId = 1;
    private int _nextItemId = 1;
    private int _nextLossId = 1;

    public InventoryService()
    {
        // TODO: Replace with LoadAllData() when SQL is connected
        SeedSampleData();
    }

    // ========================================================================
    // DATA LOADING - STUB METHODS FOR SQL
    // These methods will call stored procedures to load data from SQL Server
    // ========================================================================
    
    #region LoadData Methods
    
    /// <summary>
    /// Load all data from database on startup
    /// </summary>
    public void LoadAllData()
    {
        LoadProducts();
        LoadAreas();
        LoadSessions();
        // InventoryItems and AreaCounts are loaded per-session
        // Losses are loaded per-session
    }
    
    /// <summary>
    /// Load all active products from database
    /// SP: usp_Products_GetAll or usp_Products_GetActive
    /// </summary>
    public void LoadProducts()
    {
        // TODO: Call stored procedure usp_Products_GetAll
        // Example pattern:
        // _products = _db.ExecuteStoredProcedure<Product>("usp_Products_GetAll");
    }
    
    /// <summary>
    /// Load a single product by ID
    /// SP: usp_Products_GetById @Id
    /// </summary>
    public Product? LoadProductById(int id)
    {
        // TODO: Call stored procedure usp_Products_GetById
        // var product = _db.ExecuteStoredProcedure<Product>("usp_Products_GetById", new { Id = id }).FirstOrDefault();
        // return product;
        return _products.FirstOrDefault(p => p.Id == id);
    }
    
    /// <summary>
    /// Load all active inventory areas from database
    /// SP: usp_InventoryAreas_GetAll
    /// </summary>
    public void LoadAreas()
    {
        // TODO: Call stored procedure usp_InventoryAreas_GetAll
        // _areas = _db.ExecuteStoredProcedure<InventoryArea>("usp_InventoryAreas_GetAll");
    }
    
    /// <summary>
    /// Load all inventory sessions from database
    /// SP: usp_InventorySessions_GetAll
    /// </summary>
    public void LoadSessions()
    {
        // TODO: Call stored procedure usp_InventorySessions_GetAll
        // _sessions = _db.ExecuteStoredProcedure<InventorySession>("usp_InventorySessions_GetAll");
    }
    
    /// <summary>
    /// Load a single session with all its items and area counts
    /// SP: usp_InventorySessions_GetById @Id (returns session)
    /// SP: usp_InventoryItems_GetBySessionId @SessionId (returns items)
    /// SP: usp_AreaCounts_GetBySessionId @SessionId (returns area counts)
    /// </summary>
    public InventorySession? LoadSessionWithItems(int sessionId)
    {
        // TODO: Call stored procedures to load session with all related data
        // var session = _db.ExecuteStoredProcedure<InventorySession>("usp_InventorySessions_GetById", new { Id = sessionId }).FirstOrDefault();
        // if (session != null)
        // {
        //     session.Items = _db.ExecuteStoredProcedure<InventoryItem>("usp_InventoryItems_GetBySessionId", new { SessionId = sessionId });
        //     var areaCounts = _db.ExecuteStoredProcedure<AreaCount>("usp_AreaCounts_GetBySessionId", new { SessionId = sessionId });
        //     // Map area counts to items...
        // }
        return _sessions.FirstOrDefault(s => s.Id == sessionId);
    }
    
    /// <summary>
    /// Load inventory items for a session
    /// SP: usp_InventoryItems_GetBySessionId @SessionId
    /// </summary>
    public List<InventoryItem> LoadInventoryItemsBySession(int sessionId)
    {
        // TODO: Call stored procedure usp_InventoryItems_GetBySessionId
        // return _db.ExecuteStoredProcedure<InventoryItem>("usp_InventoryItems_GetBySessionId", new { SessionId = sessionId });
        return _inventoryItems.Where(i => i.SessionId == sessionId).ToList();
    }
    
    /// <summary>
    /// Load area counts for an inventory item
    /// SP: usp_AreaCounts_GetByInventoryItemId @InventoryItemId
    /// </summary>
    public List<AreaCount> LoadAreaCountsByItem(int inventoryItemId)
    {
        // TODO: Call stored procedure usp_AreaCounts_GetByInventoryItemId
        // return _db.ExecuteStoredProcedure<AreaCount>("usp_AreaCounts_GetByInventoryItemId", new { InventoryItemId = inventoryItemId });
        var item = _inventoryItems.FirstOrDefault(i => i.Id == inventoryItemId);
        return item?.AreaCounts ?? new List<AreaCount>();
    }
    
    /// <summary>
    /// Load loss records for a session
    /// SP: usp_LossRecords_GetBySessionId @SessionId
    /// </summary>
    public List<LossRecord> LoadLossesBySession(int sessionId)
    {
        // TODO: Call stored procedure usp_LossRecords_GetBySessionId
        // return _db.ExecuteStoredProcedure<LossRecord>("usp_LossRecords_GetBySessionId", new { SessionId = sessionId });
        return _losses.Where(l => l.SessionId == sessionId).ToList();
    }
    
    #endregion
    
    // ========================================================================
    // DATA SAVING - STUB METHODS FOR SQL
    // These methods will call stored procedures to save data to SQL Server
    // ========================================================================
    
    #region SaveData Methods
    
    /// <summary>
    /// Save (insert or update) a product
    /// SP: usp_Products_Upsert
    /// </summary>
    public void SaveProduct(Product product)
    {
        // TODO: Call stored procedure usp_Products_Upsert
        // var result = _db.ExecuteStoredProcedure<int>("usp_Products_Upsert", new {
        //     product.Id,           // Pass 0 or null for new records
        //     product.Name,
        //     product.Brand,
        //     Category = (int)product.Category,
        //     ContainerType = (int)product.ContainerType,
        //     product.SizeDescription,
        //     product.UnitCost,
        //     product.UnitPrice,
        //     product.ServingsPerUnit,
        //     product.Barcode,
        //     product.Sku,
        //     product.IsActive,
        //     product.SortOrder
        // });
        // product.Id = result; // SP returns the ID
        
        // In-memory fallback (remove when SQL connected)
        if (product.Id == 0)
        {
            product.Id = _nextProductId++;
            product.CreatedAt = DateTime.UtcNow;
            _products.Add(product);
        }
        else
        {
            var index = _products.FindIndex(p => p.Id == product.Id);
            if (index >= 0) _products[index] = product;
        }
    }
    
    /// <summary>
    /// Delete a product (soft delete - sets IsActive = false)
    /// SP: usp_Products_Delete @Id
    /// </summary>
    public void DeleteProduct(int productId)
    {
        // TODO: Call stored procedure usp_Products_Delete
        // _db.ExecuteStoredProcedure("usp_Products_Delete", new { Id = productId });
        
        var product = _products.FirstOrDefault(p => p.Id == productId);
        if (product != null) product.IsActive = false;
    }
    
    /// <summary>
    /// Save (insert or update) an inventory area
    /// SP: usp_InventoryAreas_Upsert
    /// </summary>
    public void SaveArea(InventoryArea area)
    {
        // TODO: Call stored procedure usp_InventoryAreas_Upsert
        // var result = _db.ExecuteStoredProcedure<int>("usp_InventoryAreas_Upsert", new {
        //     area.Id,
        //     area.Name,
        //     area.ShortCode,
        //     area.SortOrder,
        //     area.IsActive
        // });
        // area.Id = result;
        
        if (area.Id == 0)
        {
            area.Id = _nextAreaId++;
            _areas.Add(area);
        }
        else
        {
            var index = _areas.FindIndex(a => a.Id == area.Id);
            if (index >= 0) _areas[index] = area;
        }
    }
    
    /// <summary>
    /// Save (insert or update) an inventory session
    /// SP: usp_InventorySessions_Upsert
    /// </summary>
    public void SaveSession(InventorySession session)
    {
        // TODO: Call stored procedure usp_InventorySessions_Upsert
        // var result = _db.ExecuteStoredProcedure<int>("usp_InventorySessions_Upsert", new {
        //     session.Id,
        //     session.SessionName,
        //     session.SessionDate,
        //     session.CompletedAt,
        //     Frequency = (int)session.Frequency,
        //     session.Notes,
        //     session.IsComplete,
        //     session.CountedBy
        // });
        // session.Id = result;
        
        if (session.Id == 0)
        {
            session.Id = _nextSessionId++;
            _sessions.Add(session);
        }
        else
        {
            var index = _sessions.FindIndex(s => s.Id == session.Id);
            if (index >= 0) _sessions[index] = session;
        }
    }
    
    /// <summary>
    /// Delete a session and all related data
    /// SP: usp_InventorySessions_Delete @Id (cascades to items, area counts, losses)
    /// </summary>
    public void DeleteSession(int sessionId)
    {
        // TODO: Call stored procedure usp_InventorySessions_Delete
        // _db.ExecuteStoredProcedure("usp_InventorySessions_Delete", new { Id = sessionId });
        
        _inventoryItems.RemoveAll(i => i.SessionId == sessionId);
        _losses.RemoveAll(l => l.SessionId == sessionId);
        _sessions.RemoveAll(s => s.Id == sessionId);
    }
    
    /// <summary>
    /// Save (insert or update) an inventory item
    /// SP: usp_InventoryItems_Upsert
    /// </summary>
    public void SaveInventoryItem(InventoryItem item)
    {
        // TODO: Call stored procedure usp_InventoryItems_Upsert
        // var result = _db.ExecuteStoredProcedure<int>("usp_InventoryItems_Upsert", new {
        //     item.Id,
        //     item.SessionId,
        //     item.ProductId,
        //     item.UnitCost,
        //     item.StartingQuantity,
        //     item.ReceivedQuantity,
        //     item.ReceivedCost,
        //     item.ComputerSold,
        //     item.CreditedProduct,
        //     item.LastCountedAt
        // });
        // item.Id = result;
        
        item.UpdatedAt = DateTime.UtcNow;
        if (item.Id == 0)
        {
            item.Id = _nextItemId++;
            item.CreatedAt = DateTime.UtcNow;
            _inventoryItems.Add(item);
        }
        else
        {
            var index = _inventoryItems.FindIndex(i => i.Id == item.Id);
            if (index >= 0) _inventoryItems[index] = item;
        }
    }
    
    /// <summary>
    /// Save (insert or update) an area count
    /// SP: usp_AreaCounts_Upsert
    /// </summary>
    public void SaveAreaCount(int inventoryItemId, AreaCount areaCount)
    {
        // TODO: Call stored procedure usp_AreaCounts_Upsert
        // _db.ExecuteStoredProcedure("usp_AreaCounts_Upsert", new {
        //     InventoryItemId = inventoryItemId,
        //     areaCount.AreaId,
        //     areaCount.FullUnits,
        //     areaCount.PartialAmount,
        //     areaCount.HasPartial
        // });
        
        var item = _inventoryItems.FirstOrDefault(i => i.Id == inventoryItemId);
        if (item != null)
        {
            var existing = item.AreaCounts.FirstOrDefault(a => a.AreaId == areaCount.AreaId);
            if (existing != null)
            {
                existing.FullUnits = areaCount.FullUnits;
                existing.PartialAmount = areaCount.PartialAmount;
                existing.HasPartial = areaCount.HasPartial;
            }
            else
            {
                item.AreaCounts.Add(areaCount);
            }
        }
    }
    
    /// <summary>
    /// Save (insert or update) a loss record
    /// SP: usp_LossRecords_Upsert
    /// </summary>
    public void SaveLoss(LossRecord loss)
    {
        // TODO: Call stored procedure usp_LossRecords_Upsert
        // var result = _db.ExecuteStoredProcedure<int>("usp_LossRecords_Upsert", new {
        //     loss.Id,
        //     loss.SessionId,
        //     loss.ProductId,
        //     LossType = (int)loss.LossType,
        //     loss.Quantity,
        //     loss.EstimatedValue,
        //     loss.Reason,
        //     loss.RecordedBy,
        //     loss.OccurredAt
        // });
        // loss.Id = result;
        
        if (loss.Id == 0)
        {
            loss.Id = _nextLossId++;
            loss.RecordedAt = DateTime.UtcNow;
            _losses.Add(loss);
        }
        else
        {
            var index = _losses.FindIndex(l => l.Id == loss.Id);
            if (index >= 0) _losses[index] = loss;
        }
    }
    
    /// <summary>
    /// Delete a loss record
    /// SP: usp_LossRecords_Delete @Id
    /// </summary>
    public void DeleteLoss(int lossId)
    {
        // TODO: Call stored procedure usp_LossRecords_Delete
        // _db.ExecuteStoredProcedure("usp_LossRecords_Delete", new { Id = lossId });
        
        _losses.RemoveAll(l => l.Id == lossId);
    }
    
    #endregion

    // ========================================================================
    // PUBLIC API - Business logic methods (unchanged interface)
    // ========================================================================
    
    #region Products
    
    public List<Product> GetAllProducts() => _products
        .Where(p => p.IsActive)
        .OrderBy(p => p.Category)
        .ThenBy(p => p.SortOrder)
        .ThenBy(p => p.DisplayName)
        .ToList();
    
    public List<Product> GetProductsByCategory(ProductCategory category) => _products
        .Where(p => p.IsActive && p.Category == category)
        .OrderBy(p => p.SortOrder)
        .ThenBy(p => p.DisplayName)
        .ToList();
    
    public Product? GetProduct(int id) => _products.FirstOrDefault(p => p.Id == id);
    
    public Product AddProduct(Product product)
    {
        SaveProduct(product);
        return product;
    }
    
    public void UpdateProduct(Product product)
    {
        SaveProduct(product);
    }
    
    public List<Product> SearchProducts(string query)
    {
        if (string.IsNullOrWhiteSpace(query)) return GetAllProducts();
        query = query.ToLower();
        return _products.Where(p => p.IsActive && 
            (p.Name.ToLower().Contains(query) || 
             p.Brand.ToLower().Contains(query) ||
             p.DisplayName.ToLower().Contains(query)))
            .OrderBy(p => p.DisplayName)
            .ToList();
    }
    
    #endregion

    #region Areas
    
    public List<InventoryArea> GetAllAreas() => _areas
        .Where(a => a.IsActive)
        .OrderBy(a => a.SortOrder)
        .ToList();
    
    public InventoryArea? GetArea(int id) => _areas.FirstOrDefault(a => a.Id == id);
    
    public InventoryArea AddArea(InventoryArea area)
    {
        SaveArea(area);
        return area;
    }
    
    #endregion

    #region Sessions
    
    public List<InventorySession> GetAllSessions() => _sessions
        .OrderByDescending(s => s.SessionDate)
        .ToList();
    
    public InventorySession? GetSession(int id) => _sessions.FirstOrDefault(s => s.Id == id);
    
    public InventorySession? GetCurrentSession() => _sessions
        .Where(s => !s.IsComplete)
        .OrderByDescending(s => s.SessionDate)
        .FirstOrDefault();
    
    public InventorySession? GetPreviousSession(int currentSessionId)
    {
        var current = GetSession(currentSessionId);
        if (current == null) return null;
        return _sessions
            .Where(s => s.IsComplete && s.SessionDate < current.SessionDate)
            .OrderByDescending(s => s.SessionDate)
            .FirstOrDefault();
    }
    
    public InventorySession CreateSession(InventorySession session, bool copyPreviousData = true)
    {
        session.IsComplete = false;
        SaveSession(session);
        
        // Pre-populate with all active products
        foreach (var product in GetAllProducts())
        {
            var item = new InventoryItem
            {
                SessionId = session.Id,
                ProductId = product.Id,
                Product = product,
                UnitCost = product.UnitCost,
                StartingQuantity = copyPreviousData ? GetPreviousClosingQuantity(product.Id) : 0,
                AreaCounts = GetAllAreas().Select(a => new AreaCount
                {
                    AreaId = a.Id,
                    AreaName = a.Name,
                    FullUnits = 0,
                    PartialAmount = 0,
                    HasPartial = false
                }).ToList()
            };
            
            SaveInventoryItem(item);
            
            // Save area counts
            foreach (var areaCount in item.AreaCounts)
            {
                SaveAreaCount(item.Id, areaCount);
            }
            
            session.Items.Add(item);
        }
        
        return session;
    }
    
    public void CompleteSession(int sessionId)
    {
        var session = GetSession(sessionId);
        if (session != null)
        {
            session.IsComplete = true;
            session.CompletedAt = DateTime.UtcNow;
            SaveSession(session);
        }
    }
    
    public void UpdateSession(InventorySession session)
    {
        SaveSession(session);
    }
    
    private decimal GetPreviousClosingQuantity(int productId)
    {
        var lastSession = _sessions
            .Where(s => s.IsComplete)
            .OrderByDescending(s => s.SessionDate)
            .FirstOrDefault();
            
        if (lastSession == null) return 0;
        
        var item = _inventoryItems.FirstOrDefault(i => 
            i.SessionId == lastSession.Id && i.ProductId == productId);
            
        return item?.CurrentOnHand ?? 0;
    }
    
    #endregion

    #region Inventory Items
    
    public List<InventoryItem> GetSessionItems(int sessionId) => 
        _inventoryItems.Where(i => i.SessionId == sessionId).ToList();
    
    public List<InventoryItem> GetSessionItemsByCategory(int sessionId, ProductCategory category) =>
        _inventoryItems.Where(i => i.SessionId == sessionId && i.Product?.Category == category).ToList();
    
    public InventoryItem? GetInventoryItem(int sessionId, int productId) =>
        _inventoryItems.FirstOrDefault(i => i.SessionId == sessionId && i.ProductId == productId);
    
    public void UpdateInventoryItem(InventoryItem item)
    {
        item.LastCountedAt = DateTime.UtcNow;
        SaveInventoryItem(item);
    }
    
    public void UpdateAreaCount(int itemId, int areaId, int fullUnits, decimal partialAmount, bool hasPartial)
    {
        var item = _inventoryItems.FirstOrDefault(i => i.Id == itemId);
        if (item == null) return;
        
        var areaCount = item.AreaCounts.FirstOrDefault(a => a.AreaId == areaId);
        if (areaCount != null)
        {
            areaCount.FullUnits = fullUnits;
            areaCount.PartialAmount = partialAmount;
            areaCount.HasPartial = hasPartial;
            SaveAreaCount(itemId, areaCount);
        }
        
        item.LastCountedAt = DateTime.UtcNow;
        SaveInventoryItem(item);
    }
    
    #endregion

    #region Losses
    
    public List<LossRecord> GetSessionLosses(int sessionId) => 
        _losses.Where(l => l.SessionId == sessionId).OrderByDescending(l => l.RecordedAt).ToList();
    
    public LossRecord AddLoss(LossRecord loss)
    {
        loss.Product = GetProduct(loss.ProductId);
        loss.EstimatedValue = loss.Quantity * (loss.Product?.UnitCost ?? 0);
        SaveLoss(loss);
        return loss;
    }
    
    public void RemoveLoss(int lossId)
    {
        DeleteLoss(lossId);
    }
    
    public decimal GetLossValueByType(int sessionId, LossType lossType) =>
        _losses.Where(l => l.SessionId == sessionId && l.LossType == lossType).Sum(l => l.EstimatedValue);
    
    public Dictionary<LossType, decimal> GetLossByType(int sessionId)
    {
        var result = new Dictionary<LossType, decimal>();
        foreach (var lossType in Enum.GetValues<LossType>())
        {
            result[lossType] = GetLossValueByType(sessionId, lossType);
        }
        return result;
    }
    
    public decimal GetTotalLossValue(int sessionId) =>
        _losses.Where(l => l.SessionId == sessionId).Sum(l => l.EstimatedValue);
    
    #endregion

    #region Analytics & Summaries
    
    public InventorySummary GetSessionSummary(int sessionId)
    {
        var session = GetSession(sessionId);
        var items = GetSessionItems(sessionId);
        var losses = GetSessionLosses(sessionId);
        
        var summary = new InventorySummary
        {
            SessionId = sessionId,
            SessionDate = session?.SessionDate ?? DateTime.UtcNow,
            TotalProducts = items.Count,
            ProductsCounted = items.Count(i => i.LastCountedAt.HasValue),
            ProductsWithVariance = items.Count(i => Math.Abs(i.Variance) > 0.5m),
            TotalInventoryValue = items.Sum(i => i.CurrentOnHand * i.UnitCost),
            TotalSalesValue = items.Sum(i => i.CalculatedSold * (i.Product?.UnitPrice ?? 0)),
            TotalVarianceValue = items.Sum(i => i.Variance * i.UnitCost),
            TotalLossValue = losses.Sum(l => l.EstimatedValue)
        };
        
        // Category breakdowns
        foreach (var category in Enum.GetValues<ProductCategory>())
        {
            var categoryItems = items.Where(i => i.Product?.Category == category).ToList();
            summary.ValueByCategory[category] = categoryItems.Sum(i => i.CurrentOnHand * i.UnitCost);
            summary.VarianceByCategory[category] = categoryItems.Sum(i => i.Variance * i.UnitCost);
        }
        
        // Generate alerts
        summary.Alerts = items
            .Where(i => Math.Abs(i.Variance) > 0.5m)
            .Select(i => new VarianceAlert
            {
                ProductId = i.ProductId,
                Product = i.Product,
                SessionId = sessionId,
                VarianceAmount = i.Variance,
                VariancePercent = i.TotalProduct > 0 ? (i.Variance / i.TotalProduct) * 100 : 0,
                Severity = GetSeverity(i.TotalProduct > 0 ? Math.Abs(i.Variance / i.TotalProduct) * 100 : 0),
                Message = $"{i.Product?.DisplayName}: {(i.Variance > 0 ? "+" : "")}{i.Variance:0.0} units variance"
            })
            .OrderByDescending(a => Math.Abs(a.VarianceAmount))
            .ToList();
        
        return summary;
    }
    
    private VarianceSeverity GetSeverity(decimal percentVariance)
    {
        return percentVariance switch
        {
            < 5 => VarianceSeverity.Low,
            < 10 => VarianceSeverity.Medium,
            < 20 => VarianceSeverity.High,
            _ => VarianceSeverity.Critical
        };
    }
    
    public SessionComparison CompareSessionWithPrevious(int sessionId)
    {
        var current = GetSession(sessionId);
        var previous = GetPreviousSession(sessionId);
        
        var comparison = new SessionComparison
        {
            CurrentSession = current!,
            PreviousSession = previous
        };
        
        if (previous != null)
        {
            var currentSummary = GetSessionSummary(sessionId);
            var previousSummary = GetSessionSummary(previous.Id);
            
            comparison.InventoryChange = currentSummary.TotalInventoryValue - previousSummary.TotalInventoryValue;
            comparison.VarianceChange = currentSummary.TotalVarianceValue - previousSummary.TotalVarianceValue;
        }
        
        return comparison;
    }
    
    #endregion

    #region Sample Data (Remove when SQL connected)
    
    private void SeedSampleData()
    {
        // Seed Areas
        var areas = new[]
        {
            new InventoryArea { Name = "Main Bar", ShortCode = "MB", SortOrder = 1 },
            new InventoryArea { Name = "Back Bar", ShortCode = "BB", SortOrder = 2 },
            new InventoryArea { Name = "Service Well", ShortCode = "SW", SortOrder = 3 },
            new InventoryArea { Name = "Walk-in Cooler", ShortCode = "WC", SortOrder = 4 },
            new InventoryArea { Name = "Storage Room", ShortCode = "SR", SortOrder = 5 },
            new InventoryArea { Name = "Patio Bar", ShortCode = "PB", SortOrder = 6 }
        };
        foreach (var area in areas) AddArea(area);

        // Seed Products - Liquor
        var liquorProducts = new[]
        {
            ("Tito's", "Vodka", 24.99m, 8.99m),
            ("Grey Goose", "Vodka", 34.99m, 11.99m),
            ("Absolut", "Vodka", 22.99m, 7.99m),
            ("Ketel One", "Vodka", 27.99m, 9.99m),
            ("Jack Daniel's", "Tennessee Whiskey", 26.99m, 8.99m),
            ("Jameson", "Irish Whiskey", 28.99m, 9.99m),
            ("Crown Royal", "Canadian Whisky", 29.99m, 10.99m),
            ("Maker's Mark", "Bourbon", 32.99m, 11.99m),
            ("Bulleit", "Bourbon", 31.99m, 10.99m),
            ("Buffalo Trace", "Bourbon", 29.99m, 9.99m),
            ("Bacardi", "White Rum", 18.99m, 6.99m),
            ("Captain Morgan", "Spiced Rum", 21.99m, 7.99m),
            ("Malibu", "Coconut Rum", 19.99m, 6.99m),
            ("Tanqueray", "Gin", 27.99m, 9.99m),
            ("Bombay Sapphire", "Gin", 29.99m, 10.99m),
            ("Hendrick's", "Gin", 36.99m, 13.99m),
            ("Jose Cuervo", "Gold Tequila", 22.99m, 7.99m),
            ("Patron", "Silver Tequila", 44.99m, 15.99m),
            ("Don Julio", "Blanco Tequila", 49.99m, 17.99m),
            ("Casamigos", "Blanco Tequila", 47.99m, 16.99m),
            ("Hennessy", "VS Cognac", 39.99m, 13.99m),
            ("Kahlua", "Coffee Liqueur", 24.99m, 8.99m),
            ("Baileys", "Irish Cream", 26.99m, 9.99m),
            ("Grand Marnier", "Orange Liqueur", 38.99m, 13.99m),
            ("Fireball", "Cinnamon Whisky", 18.99m, 6.99m),
            ("Jagermeister", "Herbal Liqueur", 24.99m, 8.99m),
            ("Aperol", "Aperitif", 26.99m, 9.99m),
            ("Campari", "Aperitif", 27.99m, 9.99m),
            ("St-Germain", "Elderflower Liqueur", 34.99m, 12.99m),
            ("Cointreau", "Triple Sec", 32.99m, 11.99m)
        };
        
        int sortOrder = 1;
        foreach (var (brand, name, price, cost) in liquorProducts)
        {
            AddProduct(new Product
            {
                Brand = brand,
                Name = name,
                Category = ProductCategory.Liquor,
                ContainerType = ContainerType.Bottle750ml,
                SizeDescription = "750ml",
                UnitPrice = price,
                UnitCost = cost,
                ServingsPerUnit = 17,
                SortOrder = sortOrder++
            });
        }

        // Seed Products - Wine
        var wineProducts = new[]
        {
            ("Kendall-Jackson", "Chardonnay", 14.99m, 8.99m),
            ("Josh Cellars", "Cabernet Sauvignon", 15.99m, 9.99m),
            ("Meiomi", "Pinot Noir", 19.99m, 12.99m),
            ("Kim Crawford", "Sauvignon Blanc", 16.99m, 10.99m),
            ("La Marca", "Prosecco", 15.99m, 9.99m),
            ("Moet & Chandon", "Imperial Brut", 49.99m, 35.99m),
            ("Cavit", "Pinot Grigio", 11.99m, 6.99m),
            ("Apothic", "Red Blend", 12.99m, 7.99m)
        };
        
        sortOrder = 1;
        foreach (var (brand, name, price, cost) in wineProducts)
        {
            AddProduct(new Product
            {
                Brand = brand,
                Name = name,
                Category = ProductCategory.Wine,
                ContainerType = ContainerType.WineBottle750ml,
                SizeDescription = "750ml",
                UnitPrice = price,
                UnitCost = cost,
                ServingsPerUnit = 5,
                SortOrder = sortOrder++
            });
        }

        // Seed Products - Beer Bottles
        var bottleBeers = new[]
        {
            ("Budweiser", "Lager", 6.00m, 1.50m),
            ("Bud Light", "Light Lager", 6.00m, 1.50m),
            ("Corona", "Extra", 7.00m, 2.00m),
            ("Heineken", "Lager", 7.00m, 2.00m),
            ("Stella Artois", "Lager", 7.00m, 2.25m),
            ("Modelo", "Especial", 7.00m, 2.00m),
            ("Guinness", "Draught", 8.00m, 2.50m)
        };
        
        sortOrder = 1;
        foreach (var (brand, name, price, cost) in bottleBeers)
        {
            AddProduct(new Product
            {
                Brand = brand,
                Name = name,
                Category = ProductCategory.BeerBottle,
                ContainerType = ContainerType.Bottle12oz,
                SizeDescription = "12oz bottle",
                UnitPrice = price,
                UnitCost = cost,
                SortOrder = sortOrder++
            });
        }

        // Seed Products - Beer Cans
        var canBeers = new[]
        {
            ("Miller Lite", "Light Lager", 5.00m, 1.25m),
            ("Coors Light", "Light Lager", 5.00m, 1.25m),
            ("Pabst Blue Ribbon", "Lager", 4.00m, 0.99m),
            ("Yuengling", "Traditional Lager", 5.50m, 1.50m),
            ("Blue Moon", "Belgian White", 7.00m, 2.00m),
            ("Sierra Nevada", "Pale Ale", 7.50m, 2.25m),
            ("Lagunitas", "IPA", 8.00m, 2.50m)
        };
        
        sortOrder = 1;
        foreach (var (brand, name, price, cost) in canBeers)
        {
            AddProduct(new Product
            {
                Brand = brand,
                Name = name,
                Category = ProductCategory.BeerCan,
                ContainerType = ContainerType.Can12oz,
                SizeDescription = "12oz can",
                UnitPrice = price,
                UnitCost = cost,
                SortOrder = sortOrder++
            });
        }

        // Seed Products - Seltzers
        var seltzers = new[]
        {
            ("White Claw", "Black Cherry", 6.00m, 1.75m),
            ("White Claw", "Mango", 6.00m, 1.75m),
            ("White Claw", "Lime", 6.00m, 1.75m),
            ("Truly", "Wild Berry", 6.00m, 1.75m),
            ("Truly", "Pineapple", 6.00m, 1.75m),
            ("High Noon", "Peach", 7.00m, 2.25m),
            ("High Noon", "Watermelon", 7.00m, 2.25m)
        };
        
        sortOrder = 1;
        foreach (var (brand, name, price, cost) in seltzers)
        {
            AddProduct(new Product
            {
                Brand = brand,
                Name = name,
                Category = ProductCategory.Seltzer,
                ContainerType = ContainerType.Can12oz,
                SizeDescription = "12oz can",
                UnitPrice = price,
                UnitCost = cost,
                SortOrder = sortOrder++
            });
        }

        // Seed Products - Draft Beer (Kegs)
        var draftBeers = new[]
        {
            ("Yuengling", "Lager (Keg)", 180.00m, 125.00m),
            ("Blue Moon", "Belgian White (Keg)", 220.00m, 165.00m),
            ("Sam Adams", "Boston Lager (Keg)", 200.00m, 145.00m),
            ("Local IPA", "House IPA (Keg)", 240.00m, 175.00m)
        };
        
        sortOrder = 1;
        foreach (var (brand, name, price, cost) in draftBeers)
        {
            AddProduct(new Product
            {
                Brand = brand,
                Name = name,
                Category = ProductCategory.DraftBeer,
                ContainerType = ContainerType.KegHalfBarrel,
                SizeDescription = "1/2 Barrel",
                UnitPrice = price,
                UnitCost = cost,
                ServingsPerUnit = 124, // ~124 pints per half barrel
                SortOrder = sortOrder++
            });
        }

        // Create a sample active session
        var session = new InventorySession
        {
            SessionName = $"Week {DateTime.Now.DayOfYear / 7 + 1} - {DateTime.Now:MMMM yyyy}",
            SessionDate = DateTime.Now.AddDays(-1),
            Frequency = InventoryFrequency.Weekly,
            CountedBy = "Sample User"
        };
        CreateSession(session, false);
    }
    
    #endregion
}
