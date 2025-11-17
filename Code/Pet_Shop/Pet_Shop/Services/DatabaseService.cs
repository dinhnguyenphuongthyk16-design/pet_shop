using Microsoft.EntityFrameworkCore;
using Pet_Shop.Data;

namespace Pet_Shop.Services
{
    public class DatabaseService
    {
        private readonly PetShopDbContext _context;

        public DatabaseService(PetShopDbContext context)
        {
            _context = context;
        }

        public async Task<bool> TestConnectionAsync()
        {
            try
            {
                await _context.Database.CanConnectAsync();
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Database connection failed: {ex.Message}");
                return false;
            }
        }

        public async Task<bool> EnsureDatabaseCreatedAsync()
        {
            try
            {
                await _context.Database.EnsureCreatedAsync();
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Database creation failed: {ex.Message}");
                return false;
            }
        }

        public async Task SeedInitialDataAsync()
        {
            try
            {
                // Check if data already exists
                if (await _context.UserRoles.AnyAsync())
                {
                    return; // Data already seeded
                }

