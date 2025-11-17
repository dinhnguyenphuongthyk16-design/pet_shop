using Microsoft.EntityFrameworkCore;
using Pet_Shop.Data;
using Pet_Shop.Services;
using Microsoft.AspNetCore.Authentication.Cookies;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

// Add Entity Framework
builder.Services.AddDbContext<PetShopDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Add AutoMapper
builder.Services.AddAutoMapper(typeof(Program));

// Add HttpContextAccessor for VNPay service
builder.Services.AddHttpContextAccessor();

// Add Memory Cache for embeddings
builder.Services.AddMemoryCache();

// Add domain services
builder.Services.AddScoped<DatabaseService>();
builder.Services.AddScoped<ProductService>();
builder.Services.AddScoped<EmailService>();
builder.Services.AddScoped<AuthenticationService>();
builder.Services.AddScoped<ProfileService>();
builder.Services.AddScoped<CategoryService>();
builder.Services.AddScoped<BannerService>();
builder.Services.AddScoped<CartService>();
builder.Services.AddScoped<OrderService>();
builder.Services.AddScoped<AddressService>();
builder.Services.AddScoped<WishlistService>();
builder.Services.AddScoped<VNPayService>();
builder.Services.AddScoped<PromotionService>();
builder.Services.AddScoped<InventoryService>();
builder.Services.AddScoped<CustomerService>();

// ===============================
// Local Recommendation Service
// ===============================
// Typed HttpClient that talks to your Python FastAPI recommender.
// Uses config: "RecommendationApi:BaseUrl" (fallback: http://localhost:8081)
builder.Services.AddHttpClient<LocalRecommendationService>((sp, client) =>
{
    var config = sp.GetRequiredService<IConfiguration>();
    var baseUrl = config["RecommendationApi:BaseUrl"] ?? "http://localhost:8081";

    client.BaseAddress = new Uri(baseUrl);
    client.Timeout = TimeSpan.FromSeconds(10);
});

// ❌ DON'T add AddScoped<LocalRecommendationService>() again,
//    the typed HttpClient registration above already registers it.

// ===============================
// Chatbot Service
// ===============================
// If ChatbotService needs HttpClient (e.g. call OpenAI or another API),
// keep it as a typed client as well:
builder.Services.AddHttpClient<ChatbotService>();

// ❌ Remove duplicate scoped registration to avoid conflicts
// builder.Services.AddScoped<ChatbotService>();

// ===============================
// Authentication
// ===============================
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/Account/Login";
        options.LogoutPath = "/Account/Logout";
        options.AccessDeniedPath = "/Account/AccessDenied";
        options.ExpireTimeSpan = TimeSpan.FromDays(30);
        options.SlidingExpiration = true;
    });

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
