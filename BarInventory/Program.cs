using BarInventory.Services;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.SignalR;
using BarInventory.BarDB.Models;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();


// Register our inventory service as singleton (in-memory store)
builder.Services.AddSingleton<InventoryService>();

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

// Use the validated barDBConnection value to create the Settings instance
builder.Services.AddScoped<BarInventory.Helpers.Settings>((s) => new BarInventory.Helpers.Settings(barDBConnection));
builder.Services.AddScoped<BarInventory.BarDB.Service>((s) => new BarInventory.BarDB.Service(builder.Configuration["BarDBConnection"]));


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
