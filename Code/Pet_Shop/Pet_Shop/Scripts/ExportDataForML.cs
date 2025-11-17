using Microsoft.EntityFrameworkCore;
using Pet_Shop.Data;
using System.Text;

namespace Pet_Shop.Scripts
{
    /// <summary>
    /// Script để export data từ SQL Server sang CSV format cho ML training
    /// Chạy script này khi cần retrain models với data mới
    /// </summary>
    public class ExportDataForML
    {
        private readonly PetShopDbContext _context;

        public ExportDataForML(PetShopDbContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Export user-item interactions (cho CVAE-CF model)
        /// Format: user_id,item_id,order_id,quantity,event_type,timestamp
        /// </summary>
        public async Task<string> ExportInteractionsAsync(string outputPath)
        {
            var interactions = await _context.OrderItems
                .Include(oi => oi.Order)
                .Include(oi => oi.Product)
                .Where(oi => oi.Order.StatusID != 5 && // Không tính đơn hủy
                             !string.IsNullOrEmpty(oi.Product.ProductCode))
                .Select(oi => new
                {
                    UserID = oi.Order.UserID,
                    ItemID = oi.Product.ProductCode!,
                    OrderID = oi.Order.OrderNumber,
                    Quantity = oi.Quantity,
                    EventType = "purchase", // Có thể mở rộng với view, add_to_cart
                    Timestamp = oi.Order.OrderDate
                })
                .ToListAsync();

            var csv = new StringBuilder();
            csv.AppendLine("user_id,item_id,order_id,quantity,event_type,timestamp");

            foreach (var interaction in interactions)
            {
                csv.AppendLine($"{interaction.UserID},{interaction.ItemID},{interaction.OrderID}," +
                              $"{interaction.Quantity},{interaction.EventType},{interaction.Timestamp:yyyy-MM-dd HH:mm:ss}");
            }

            await File.WriteAllTextAsync(outputPath, csv.ToString());
            return $"Exported {interactions.Count} interactions to {outputPath}";
        }

