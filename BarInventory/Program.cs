using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.SignalR;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

builder.Services.AddServerSideBlazor()
    .AddCircuitOptions(options => { options.DetailedErrors = true; });

builder.Services.Configure<HubOptions>(options =>
{
    options.DisableImplicitFromServicesParameters = true;
});

// Configure request limits
builder.Services.Configure<FormOptions>(options =>
{
    options.MultipartBodyLengthLimit = 552428800; // 550 MB
});

// Add the configuration file
builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);

// Ensure that the "BarDBConnection" key exists in the configuration and has a non-null value
var barDBConnection = builder.Configuration["BarDBConnection"];
if (string.IsNullOrEmpty(barDBConnection))
{
    throw new InvalidOperationException("The configuration key 'BarDBConnection' is missing or has a null/empty value.");
}

// Register Settings and BarDB.Service for SQL data access
builder.Services.AddScoped<BarInventory.Helpers.Settings>((s) => new BarInventory.Helpers.Settings(barDBConnection));
builder.Services.AddScoped<BarInventory.BarDB.Service>((s) => new BarInventory.BarDB.Service(barDBConnection));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();
