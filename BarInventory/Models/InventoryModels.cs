namespace BarInventory.Models;

/// <summary>
/// Product category types for bar inventory
/// </summary>
public enum ProductCategory
{
    Liquor,         // Poured spirits (vodka, whiskey, rum, etc.)
    Wine,           // Wine bottles
    BeerBottle,     // Bottled beer
    BeerCan,        // Canned beer
    DraftBeer,      // Kegs
    Seltzer,        // Hard seltzers
    Mixers,         // Non-alcoholic mixers
    Other           // Miscellaneous items
}

/// <summary>
/// Container/size type for products
/// </summary>
public enum ContainerType
{
    Bottle750ml,
    Bottle1L,
    Bottle1_75L,
    Bottle375ml,
    Can12oz,
    Can16oz,
    Can19_2oz,
    Bottle12oz,
    Bottle22oz,
    KegHalfBarrel,
    KegQuarterBarrel,
    KegSixtel,
    WineBottle750ml,
    WineBottle1_5L,
    BoxWine3L,
    Other
}

/// <summary>
/// Inventory area/location in the bar
/// </summary>
public class InventoryArea
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string ShortCode { get; set; } = string.Empty;
    public int SortOrder { get; set; }
    public bool IsActive { get; set; } = true;
}

/// <summary>
/// Base product definition - master product catalog
/// </summary>
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Brand { get; set; } = string.Empty;
    public ProductCategory Category { get; set; }
    public ContainerType ContainerType { get; set; }
    public string SizeDescription { get; set; } = string.Empty; // e.g., "750ml", "12oz can"
    public decimal UnitCost { get; set; }
    public decimal UnitPrice { get; set; } // Retail/menu price
    public decimal? ServingsPerUnit { get; set; } // For poured liquor - how many drinks per bottle
    public string? Barcode { get; set; }
    public string? Sku { get; set; }
    public bool IsActive { get; set; } = true;
    public int SortOrder { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    // Computed display name
    public string DisplayName => $"{Brand} {Name}".Trim();
    public string FullDescription => $"{DisplayName} ({SizeDescription})";
}

/// <summary>
/// Inventory count for a specific product in a specific area
/// Uses system of 10s for partial bottles (10=full, 5=half, etc.)
/// </summary>
public class AreaCount
{
    public int AreaId { get; set; }
    public string AreaName { get; set; } = string.Empty;
    public int FullUnits { get; set; }        // Number of full/sealed units
    public decimal PartialAmount { get; set; } // 0-10 scale for open bottles (10=full, 5=half, 0=empty)
    public bool HasPartial { get; set; }      // Whether there's an open bottle being counted
    
    // Computed total (full units + partial as decimal)
    public decimal TotalUnits => FullUnits + (HasPartial ? PartialAmount / 10m : 0);
}

/// <summary>
/// Inventory session/period for tracking
/// </summary>
public class InventorySession
{
    public int Id { get; set; }
    public DateTime SessionDate { get; set; }
    public DateTime? CompletedAt { get; set; }
    public string SessionName { get; set; } = string.Empty; // e.g., "Week 52 - 2024"
    public InventoryFrequency Frequency { get; set; }
    public string? Notes { get; set; }
    public bool IsComplete { get; set; }
    public string CountedBy { get; set; } = string.Empty;
    
    // Navigation
    public List<InventoryItem> Items { get; set; } = new();
    public List<LossRecord> Losses { get; set; } = new();
}

public enum InventoryFrequency
{
    Daily,
    Weekly,
    BiWeekly,
    Monthly
}

/// <summary>
/// Complete inventory line item matching the spreadsheet columns
/// </summary>
public class InventoryItem
{
    public int Id { get; set; }
    public int SessionId { get; set; }
    public int ProductId { get; set; }
    
    // Product reference (for display)
    public Product? Product { get; set; }
    
    // Column A-B: Product info (from Product)
    
    // Column C: Price of product
    public decimal UnitCost { get; set; }
    
    // Column D: Starting Number (from previous report closing)
    public decimal StartingQuantity { get; set; }
    
    // Column E: Received Product
    public decimal ReceivedQuantity { get; set; }
    
    // Column F: Cost of Received Product
    public decimal ReceivedCost { get; set; }
    
    // Column G: Total Product = Starting + Received
    public decimal TotalProduct => StartingQuantity + ReceivedQuantity;
    
    // Columns H-M: Area counts (flexible - stored in AreaCounts)
    public List<AreaCount> AreaCounts { get; set; } = new();
    
    // Column N: Total Current Product on Hand (sum of all areas)
    public decimal CurrentOnHand => AreaCounts.Sum(a => a.TotalUnits);
    
    // Column O: Total Product Sold = G - N
    public decimal CalculatedSold => TotalProduct - CurrentOnHand;
    
    // Column P: Total Price Sold (calculated: sold * unit price)
    public decimal TotalPriceSold => CalculatedSold * (Product?.UnitPrice ?? 0);
    
    // Column Q: Computer/POS Sold (entered from POS system)
    public decimal ComputerSold { get; set; }
    
    // Column R: Variance = O - Q (positive = shrinkage/loss)
    public decimal Variance => CalculatedSold - ComputerSold;
    
    // E.2: Credited Product (returns, comps tracked separately)
    public decimal CreditedProduct { get; set; }
    
    // Adjusted variance accounting for credits
    public decimal AdjustedVariance => Variance - CreditedProduct;
    
    // Timestamps
    public DateTime? LastCountedAt { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

/// <summary>
/// Loss tracking for breakage, spoilage, comps, returns
/// </summary>
public class LossRecord
{
    public int Id { get; set; }
    public int SessionId { get; set; }
    public int ProductId { get; set; }
    public Product? Product { get; set; }
    
    public LossType LossType { get; set; }
    public decimal Quantity { get; set; }
    public decimal EstimatedValue { get; set; }
    public string? Reason { get; set; }
    public string? RecordedBy { get; set; }
    public DateTime OccurredAt { get; set; }
    public DateTime RecordedAt { get; set; } = DateTime.UtcNow;
}

public enum LossType
{
    Breakage,           // Broken/dropped bottles
    Spoilage,           // Expired or spoiled product
    Spillage,           // Accidental spills
    Comp,               // Complimentary drinks (house comps)
    ManagerComp,        // Manager-approved comps
    CustomerReturn,     // Customer didn't like drink
    MixingError,        // Wrong drink made
    Overpouring,        // Known overpouring adjustment
    Theft,              // Suspected or confirmed theft
    Training,           // Used for training
    Sampling,           // Product samples/tastings
    Other
}

/// <summary>
/// Variance alert thresholds and tracking
/// </summary>
public class VarianceAlert
{
    public int ProductId { get; set; }
    public Product? Product { get; set; }
    public int SessionId { get; set; }
    public decimal VarianceAmount { get; set; }
    public decimal VariancePercent { get; set; }
    public VarianceSeverity Severity { get; set; }
    public string Message { get; set; } = string.Empty;
    public bool IsReviewed { get; set; }
    public string? ReviewNotes { get; set; }
}

public enum VarianceSeverity
{
    Low,        // < 5% variance
    Medium,     // 5-10% variance
    High,       // 10-20% variance
    Critical    // > 20% variance
}

/// <summary>
/// Summary statistics for dashboard
/// </summary>
public class InventorySummary
{
    public int SessionId { get; set; }
    public DateTime SessionDate { get; set; }
    
    // Counts
    public int TotalProducts { get; set; }
    public int ProductsCounted { get; set; }
    public int ProductsWithVariance { get; set; }
    
    // Values
    public decimal TotalInventoryValue { get; set; }
    public decimal TotalSalesValue { get; set; }
    public decimal TotalVarianceValue { get; set; }
    public decimal TotalLossValue { get; set; }
    
    // Percentages
    public decimal OverallVariancePercent { get; set; }
    public decimal CompletionPercent => TotalProducts > 0 ? (ProductsCounted / (decimal)TotalProducts) * 100 : 0;
    
    // Category breakdowns
    public Dictionary<ProductCategory, decimal> ValueByCategory { get; set; } = new();
    public Dictionary<ProductCategory, decimal> VarianceByCategory { get; set; } = new();
    
    // Alerts
    public List<VarianceAlert> Alerts { get; set; } = new();
}

/// <summary>
/// Historical comparison data
/// </summary>
public class SessionComparison
{
    public InventorySession CurrentSession { get; set; } = null!;
    public InventorySession? PreviousSession { get; set; }
    
    public decimal InventoryChange { get; set; }
    public decimal VarianceChange { get; set; }
    public List<ProductVarianceComparison> TopVarianceChanges { get; set; } = new();
}

public class ProductVarianceComparison
{
    public Product Product { get; set; } = null!;
    public decimal CurrentVariance { get; set; }
    public decimal PreviousVariance { get; set; }
    public decimal Change => CurrentVariance - PreviousVariance;
    public string Trend => Change > 0 ? "↑" : Change < 0 ? "↓" : "→";
}
