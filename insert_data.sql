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

/* 1) USER ROLES */
IF NOT EXISTS (SELECT 1 FROM UserRoles WHERE RoleName = 'Admin')
    INSERT INTO UserRoles (RoleName, Description) VALUES ('Admin', N'Quản trị viên hệ thống');
IF NOT EXISTS (SELECT 1 FROM UserRoles WHERE RoleName = 'Employee')
    INSERT INTO UserRoles (RoleName, Description) VALUES ('Employee', N'Nhân viên cửa hàng');
IF NOT EXISTS (SELECT 1 FROM UserRoles WHERE RoleName = 'Customer')
    INSERT INTO UserRoles (RoleName, Description) VALUES ('Customer', N'Khách hàng');

/* 2) ORDER STATUSES */
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

/* 3) PAYMENT METHODS */
IF NOT EXISTS (SELECT 1 FROM PaymentMethods WHERE MethodName = 'COD')
    INSERT INTO PaymentMethods (MethodName, Description) VALUES ('COD',  N'Thanh toán khi nhận hàng');
IF NOT EXISTS (SELECT 1 FROM PaymentMethods WHERE MethodName = 'VNPay')
    INSERT INTO PaymentMethods (MethodName, Description) VALUES ('VNPay',N'Thanh toán qua VNPay');

/* 4) CATEGORIES */
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Thức ăn chó')
    INSERT INTO Categories (CategoryName, Description, SortOrder) VALUES (N'Thức ăn chó',  N'Các loại thức ăn dành cho chó', 1);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Thức ăn mèo')
    INSERT INTO Categories (CategoryName, Description, SortOrder) VALUES (N'Thức ăn mèo',  N'Các loại thức ăn dành cho mèo', 2);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Phụ kiện chó')
    INSERT INTO Categories (CategoryName, Description, SortOrder) VALUES (N'Phụ kiện chó', N'Dây dắt, chuồng, đồ chơi cho chó', 3);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Phụ kiện mèo')
    INSERT INTO Categories (CategoryName, Description, SortOrder) VALUES (N'Phụ kiện mèo', N'Khay cát, vòng cổ, đồ chơi cho mèo', 4);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Thức ăn khô')
    INSERT INTO Categories (CategoryName, Description, SortOrder) VALUES (N'Thức ăn khô',  N'Thức ăn khô cho thú cưng', 5);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Thức ăn ướt')
    INSERT INTO Categories (CategoryName, Description, SortOrder) VALUES (N'Thức ăn ướt',  N'Thức ăn ướt cho thú cưng', 6);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Đồ chơi')
    INSERT INTO Categories (CategoryName, Description, SortOrder) VALUES (N'Đồ chơi',      N'Đồ chơi cho thú cưng', 7);
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Vệ sinh')
    INSERT INTO Categories (CategoryName, Description, SortOrder) VALUES (N'Vệ sinh',      N'Sản phẩm vệ sinh cho thú cưng', 8);

/* 5) BRANDS */
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = 'Royal Canin')
    INSERT INTO Brands (BrandName, Description) VALUES ('Royal Canin', N'Thương hiệu thức ăn cao cấp cho thú cưng');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = 'Whiskas')
    INSERT INTO Brands (BrandName, Description) VALUES ('Whiskas',     N'Thức ăn cho mèo');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = 'Pedigree')
    INSERT INTO Brands (BrandName, Description) VALUES ('Pedigree',    N'Thức ăn cho chó');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = 'Felix')
    INSERT INTO Brands (BrandName, Description) VALUES ('Felix',       N'Thức ăn ướt cho mèo');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = 'Hill''s')
    INSERT INTO Brands (BrandName, Description) VALUES ('Hill''s',     N'Thức ăn dinh dưỡng cho thú cưng');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = 'Purina')
    INSERT INTO Brands (BrandName, Description) VALUES ('Purina',      N'Thức ăn đa dạng cho thú cưng');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = 'Orijen')
    INSERT INTO Brands (BrandName, Description) VALUES ('Orijen',      N'Thức ăn cao cấp cho thú cưng');
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandName = 'Acana')
    INSERT INTO Brands (BrandName, Description) VALUES ('Acana',       N'Thức ăn tự nhiên cho thú cưng');

/* === Lookups for IDs === */
DECLARE @CatFoodDog INT = (SELECT CategoryID FROM Categories WHERE CategoryName=N'Thức ăn chó');
DECLARE @CatFoodCat INT = (SELECT CategoryID FROM Categories WHERE CategoryName=N'Thức ăn mèo');
DECLARE @CatAccDog  INT = (SELECT CategoryID FROM Categories WHERE CategoryName=N'Phụ kiện chó');
DECLARE @CatAccCat  INT = (SELECT CategoryID FROM Categories WHERE CategoryName=N'Phụ kiện mèo');
DECLARE @CatToy     INT = (SELECT CategoryID FROM Categories WHERE CategoryName=N'Đồ chơi');
DECLARE @CatHyg     INT = (SELECT CategoryID FROM Categories WHERE CategoryName=N'Vệ sinh');

DECLARE @B_Royal    INT = (SELECT BrandID FROM Brands WHERE BrandName='Royal Canin');
DECLARE @B_Whiskas  INT = (SELECT BrandID FROM Brands WHERE BrandName='Whiskas');
DECLARE @B_Pedigree INT = (SELECT BrandID FROM Brands WHERE BrandName='Pedigree');
DECLARE @B_Felix    INT = (SELECT BrandID FROM Brands WHERE BrandName='Felix');
DECLARE @B_Hills    INT = (SELECT BrandID FROM Brands WHERE BrandName='Hill''s');
DECLARE @B_Purina   INT = (SELECT BrandID FROM Brands WHERE BrandName='Purina');
DECLARE @B_Orijen   INT = (SELECT BrandID FROM Brands WHERE BrandName='Orijen');
DECLARE @B_Acana    INT = (SELECT BrandID FROM Brands WHERE BrandName='Acana');
