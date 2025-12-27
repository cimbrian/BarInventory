# 🍸 CzarWare Inventory

A professional bar inventory management system built with .NET 8 Blazor Server. Mobile-optimized Progressive Web App (PWA) designed for weekly or periodic inventory counts using the "System of 10s" for partial bottle measurement.

## 🔐 Application Login

| Field | Value |
|-------|-------|
| **Username** | `MartiniCzar` |
| **Password** | `count$` |

Sessions expire after 30 days and require re-login.

---

## 📋 Table of Contents

1. [Features](#features)
2. [Technology Stack](#technology-stack)
3. [Installation](#installation)
4. [Database Setup](#database-setup)
5. [Azure Deployment](#azure-deployment)
6. [Development Tools](#development-tools)
7. [Training Guide](#training-guide)
8. [Common Workflows](#common-workflows)
9. [Tips & Best Practices](#tips--best-practices)

---

## ✨ Features

- **Mobile-First Design** — Dark theme optimized for bar environments
- **Progressive Web App** — Install on any device, works offline
- **System of 10s** — Measure partial bottles in tenths (0.1 - 1.0)
- **Multi-Area Counting** — Track inventory across multiple storage locations
- **Session Management** — Weekly/monthly inventory periods with carryforward
- **Loss Tracking** — Document breakage, spillage, comps, and waste
- **Real-Time Reports** — Print-ready session summaries
- **Product Management** — Full CRUD for products, categories, and areas

---

## 🛠 Technology Stack

| Component | Technology |
|-----------|------------|
| **Framework** | .NET 8 Blazor Server |
| **Database** | SQL Server / Azure SQL |
| **ORM** | SQL PLUS .NET (VSIX) |
| **Hosting** | Azure App Service (Free Tier compatible) |
| **UI** | Custom CSS, Mobile-optimized |
| **PWA** | Service Worker, Manifest |

---

## 📦 Installation

### Prerequisites

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Visual Studio 2022](https://visualstudio.microsoft.com/) or VS Code
- SQL Server (LocalDB, SQL Server, or Azure SQL)
- [SQL PLUS .NET VSIX](https://marketplace.visualstudio.com/items?itemName=nicholabs.sql-plus-net) (for ORM regeneration)

### Clone & Build

```bash
# Clone the repository
git clone https://github.com/your-repo/BarInventory.git
cd BarInventory

# Restore packages
dotnet restore

# Build
dotnet build

# Run locally
dotnet run --project BarInventory
```

### Configuration

Update `appsettings.json` with your connection string:

```json
{
  "ConnectionStrings": {
    "BarDBConnection": "Server=YOUR_SERVER;Database=BarDB;User Id=YOUR_USER;Password=YOUR_PASSWORD;TrustServerCertificate=True;"
  }
}
```

For local development with LocalDB:
```json
{
  "ConnectionStrings": {
    "BarDBConnection": "Server=(localdb)\\MSSQLLocalDB;Database=BarDB;Integrated Security=true;TrustServerCertificate=True;"
  }
}
```

---

## 🗄 Database Setup

The `Database/` folder contains all SQL scripts needed for setup:

| Script | Purpose |
|--------|---------|
| `BarDB-Tables.sql` | Creates all database tables |
| `BarDB-Procs.sql` | Creates stored procedures (ORM layer) |
| `SeedReferenceData.sql` | Inserts required lookup data (categories, types) |
| `SampleData.sql` | Optional: Full sample data for testing |
| `ClearSampleData.sql` | Removes sample data, keeps reference types |

### Fresh Installation (Production)

```sql
-- 1. Create the database
CREATE DATABASE BarDB;
GO
USE BarDB;
GO

-- 2. Run table creation script
-- Execute: Database/BarDB-Tables.sql

-- 3. Run stored procedures script
-- Execute: Database/BarDB-Procs.sql

-- 4. Seed required reference data
-- Execute: Database/SeedReferenceData.sql
```

### Development Installation (with Sample Data)

```sql
-- 1-3. Same as above, then:

-- 4. Load full sample data (includes reference data + test products)
-- Execute: Database/SampleData.sql
```

### Clearing Sample Data

To remove test data while keeping reference types:

```sql
-- Execute: Database/ClearSampleData.sql
```

---

## ☁️ Azure Deployment

### Azure App Service (Free Tier)

1. **Create Resources**
   - Create an Azure SQL Database (Basic tier works)
   - Create an Azure App Service (Free F1 tier)

2. **Configure Connection String**
   
   In Azure Portal → App Service → Configuration → Application Settings:
   
   | Name | Value |
   |------|-------|
   | `ConnectionStrings__BarDBConnection` | `Server=tcp:YOUR_SERVER.database.windows.net,1433;Database=BarDB;User ID=YOUR_USER;Password=YOUR_PASSWORD;Encrypt=true;TrustServerCertificate=false;` |

   Or add as a Connection String (type: SQLAzure):
   | Name | Value |
   |------|-------|
   | `BarDBConnection` | `Server=tcp:YOUR_SERVER.database.windows.net...` |

3. **Database Setup**
   - Connect to Azure SQL using SSMS or Azure Data Studio
   - Run the SQL scripts in order:
     1. `BarDB-Tables.sql`
     2. `BarDB-Procs.sql`
     3. `SeedReferenceData.sql` (or `SampleData.sql` for testing)

4. **Deploy Application**
   
   Using Visual Studio:
   - Right-click project → Publish → Azure → App Service
   
   Using CLI:
   ```bash
   dotnet publish -c Release
   az webapp deploy --resource-group YOUR_RG --name YOUR_APP --src-path ./publish
   ```

5. **Verify Deployment**
   - Navigate to `https://YOUR_APP.azurewebsites.net`
   - Login with `MartiniCzar` / `count$`

---

## 🔧 Development Tools

### SQL PLUS .NET ORM

This project uses SQL PLUS .NET for database access. The VSIX generates C# models and services from stored procedures.

**Installation:**
1. Download from [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=nicholabs.sql-plus-net)
2. Install the VSIX in Visual Studio 2022

**Regenerating ORM Classes:**
1. Open SQL Server Object Explorer
2. Right-click the database → SQL PLUS → Generate
3. Select stored procedures to generate
4. Output goes to `BarDB/` folder

**Important:** If regenerating, ensure stored procedure `@Id` parameters default to `NULL` (not `0`) for proper INSERT/UPDATE behavior.

---

## 📚 Training Guide

### What is CzarWare Inventory?

CzarWare Inventory is a mobile-friendly bar inventory management system designed for weekly or periodic inventory counts. It helps you:

- **Track what you have** — Count bottles across all storage areas
- **Record what you receive** — Log deliveries during each period
- **Document losses** — Track breakage, spillage, comps, and other losses
- **Analyze usage** — Compare counts to identify variances and trends

### Key Concepts

#### 📅 Sessions
A **session** represents one inventory counting period (typically weekly). Each session is independent — when you start a new session, ending counts from the previous session become starting quantities.

#### 📍 Areas
**Areas** are the physical locations where you store inventory: Main Bar Well, Back Bar, Walk-in Cooler, Dry Storage, etc. You count each product in each area where it exists.

#### 📦 Products
**Products** are the items you're tracking — bottles of liquor, wine, beer, mixers, etc. Each product has a brand, name, size, category, and unit cost.

#### 🔢 Counts (System of 10s)
For each product, you record **full units** (complete bottles) and optionally **partial amounts** (open bottles measured in tenths). A count of "3.7" means 3 full bottles plus one bottle that's 70% full.

#### 📥 Received
The **received quantity** tracks how many units were delivered during this counting period. This helps calculate actual usage.

### 💡 The Inventory Formula

```
Usage = Previous Count + Received − Current Count − Losses
```

Understanding this formula helps you spot problems. If usage seems too high, you might have unrecorded losses or theft. If it seems too low, check for missed deliveries.

---

### Application Pages

#### Dashboard
Your home screen showing:
- Session summary cards (total on hand, inventory value, items counted)
- Quick action buttons
- Current session status
- Recent losses

#### Sessions
Create and manage inventory counting periods:
- **+ New Session** — Start a new counting period
- **Complete Session** — Finalize when counting is done
- **View Summary** — See session statistics
- **Print Report** — Generate printable report

> ⚠️ Only one session can be active at a time. Complete the current session before starting a new one.

#### Capture (Counting)
The main counting interface:
- **Area Tabs** — Filter by storage location
- **Filter Tabs** — All / Uncounted / Counted
- **+/- Buttons** — Increment/decrement counts
- **½ Button** — Record partial bottles
- **✓ Button** — Mark item as counted
- **Search** — Find products quickly

#### Products
Master product list management:
- Add new products with brand, name, category, size, cost
- Edit existing products
- Mark products active/inactive
- Filter by category

#### Losses
Track inventory losses:
- **Loss Types:** Breakage, Spillage, Comp, Theft, Waste, Error
- Record product, quantity, and reason
- View loss history and totals

#### Lookup
Quick inventory check:
- Search for any product
- View current counts by area
- Check if you need to reorder

#### Settings
System configuration:
- **Product Categories** — Spirits, Wine, Beer, etc.
- **Container Types** — Bottle, Can, Keg, Box
- **Inventory Areas** — Storage locations
- **Loss Types** — Reasons for losses
- **Inventory Frequencies** — Daily, Weekly, Monthly

---

## 🔄 Common Workflows

### Weekly Inventory Count

1. **Start the Session**
   - Go to **Sessions** → **+ New Session**
   - Name it (e.g., "Week 1 - January 2026") and save

2. **Count Each Area**
   - Go to **Capture**
   - Select first area tab (e.g., "Main Bar Well")
   - Physically go to that location with your device
   - Count each product, clicking ✓ when done
   - Repeat for each area

3. **Record Deliveries**
   - For any products received this week:
   - Expand the product → Enter "Received this period"

4. **Log Any Losses**
   - Go to **Losses**
   - Record any breakage, spillage, comps, etc.

5. **Review & Complete**
   - Check the **Uncounted** filter — should be zero
   - Review the session report for any issues
   - Click **Complete Session**

### Recording a Broken Bottle

1. Go to **Losses**
2. Select **Breakage** as loss type
3. Search for and select the product
4. Enter quantity (usually 1)
5. Add reason: "Dropped while restocking"
6. Click **+ Add Loss**

### Adding a New Product

1. Go to **Products** → **+ Add Product**
2. Enter brand, name, category, size, cost
3. Save the product
4. Product will appear in the next new session automatically

### Investigating a Variance

1. Note which product shows unexpected usage
2. Check **Losses** — was breakage recorded?
3. Verify **Received** quantity is correct
4. Use **Lookup** to check counts by area
5. Physically recount if necessary

---

## 💡 Tips & Best Practices

| Tip | Description |
|-----|-------------|
| 📱 **Use Your Phone** | The app is designed for mobile. Walk around with your phone and count in real-time. |
| 📍 **Count by Area** | Always select a specific area tab. Don't try to count "All Areas" at once. |
| ⏰ **Same Time Each Week** | Count at the same time each period for consistent comparisons. |
| 📝 **Log Losses Immediately** | Record breakage and spillage when it happens, not later. |
| 🔍 **Use Search** | Don't scroll endlessly. Type a few letters to find products fast. |
| ✓ **Mark Items Done** | Click the checkmark after counting each item to track progress. |
| 📊 **Review Reports** | Look at your session report before completing. Catch errors early. |
| 🔄 **Complete Old Sessions** | Always complete the previous session before starting a new one. |

---

## 📄 License

MIT License - See LICENSE file for details.

---

## 🤝 Support

For issues or feature requests, please open a GitHub issue or contact the development team.

---

*Built with ❤️ by CzarWare*
