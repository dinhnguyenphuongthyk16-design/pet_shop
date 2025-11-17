/* =====================================================
   PET SHOP – CLEAN SEED (with 80+ extra demo products)
   Safe to re-run. No placeholders. No syntax shorthands.
   ===================================================== */

USE PetShopDB;
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
BEGIN TRAN;

/* 0) Helper: ensure basic tables exist (optional)
   -- Comment this out if your schema is guaranteed ready
-- SELECT TOP 0 * FROM UserRoles;
-- SELECT TOP 0 * FROM OrderStatuses;
-- SELECT TOP 0 * FROM PaymentMethods;
-- SELECT TOP 0 * FROM Categories;
-- SELECT TOP 0 * FROM Brands;
-- SELECT TOP 0 * FROM Products;
-- SELECT TOP 0 * FROM Inventory;
*/

/* ORDER STATUSES */
IF NOT EXISTS (SELECT 1 FROM OrderStatuses WHERE StatusName = 'New')
    INSERT INTO OrderStatuses (StatusName, Description, SortOrder) VALUES ('New',       N'Đơn hàng mới',   1);
IF NOT EXISTS (SELECT 1 FROM OrderStatuses WHERE StatusName = 'Processing')
    INSERT INTO OrderStatuses (StatusName, Description, SortOrder) VALUES ('Processing',N'Đang xử lý',     2);
IF NOT EXISTS (SELECT 1 FROM OrderStatuses WHERE StatusName = 'Shipping')
    INSERT INTO OrderStatuses (StatusName, Description, SortOrder) VALUES ('Shipping',  N'Đang giao hàng', 3);
IF NOT EXISTS (SELECT 1 FROM OrderStatuses WHERE StatusName = 'Delivered')
    INSERT INTO OrderStatuses (StatusName, Description, SortOrder) VALUES ('Delivered', N'Đã giao hàng',   4);
IF NOT EXISTS (SELECT 1 FROM OrderStatuses WHERE StatusName = 'Cancelled')
    INSERT INTO OrderStatuses (StatusName, Description, SortOrder) VALUES ('Cancelled', N'Đã hủy',         5);
