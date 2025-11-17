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



/* 6) CORE 12 PRODUCTS (fully spelled out, idempotent) */
INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Royal Canin Adult','RC-ADULT-001', @CatFoodDog,@B_Royal,'Food','Dog',3.0,'30x20x10 cm','2025-12-31',
       N'Thức ăn khô cao cấp cho chó trưởng thành, giàu protein và vitamin',N'Thức ăn khô cho chó trưởng thành',450000,400000,300000,1,1,1
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='RC-ADULT-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Pedigree Adult','PED-ADULT-001', @CatFoodDog,@B_Pedigree,'Food','Dog',2.5,'25x18x8 cm','2025-11-30',
       N'Thức ăn khô cho chó trưởng thành, giá cả hợp lý',N'Thức ăn khô cho chó trưởng thành',180000,150000,120000,0,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='PED-ADULT-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Hill''s Science Diet','HILLS-ADULT-001', @CatFoodDog,@B_Hills,'Food','Dog',4.0,'35x25x12 cm','2025-10-31',
       N'Thức ăn dinh dưỡng khoa học cho chó',N'Thức ăn dinh dưỡng cho chó',380000,350000,250000,0,1,1
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='HILLS-ADULT-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Whiskas Adult','WHISKAS-ADULT-001', @CatFoodCat,@B_Whiskas,'Food','Cat',1.5,'20x15x6 cm','2025-12-31',
       N'Thức ăn khô cho mèo trưởng thành',N'Thức ăn khô cho mèo',120000,100000,80000,0,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='WHISKAS-ADULT-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Felix Wet Food','FELIX-WET-001', @CatFoodCat,@B_Felix,'Food','Cat',0.4,'10x8x3 cm','2025-09-30',
       N'Thức ăn ướt cho mèo, hương cá',N'Thức ăn ướt cho mèo',25000,20000,15000,1,1,1
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='FELIX-WET-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Royal Canin Kitten','RC-KITTEN-001', @CatFoodCat,@B_Royal,'Food','Cat',2.0,'25x18x8 cm','2025-11-30',
       N'Thức ăn cho mèo con',N'Thức ăn cho mèo con',320000,280000,200000,0,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='RC-KITTEN-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Dây dắt chó','DOG-LEASH-001', @CatAccDog,@B_Acana,'Accessory','Dog',0.3,'120x2 cm',NULL,
       N'Dây dắt chó chất lượng cao, chống rỉ',N'Dây dắt chó cao cấp',150000,120000,80000,0,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='DOG-LEASH-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Chuồng chó','DOG-CAGE-001', @CatAccDog,@B_Acana,'Accessory','Dog',5.0,'80x60x70 cm',NULL,
       N'Chuồng chó bằng thép, có thể gập lại',N'Chuồng chó di động',800000,700000,500000,1,1,1
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='DOG-CAGE-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Bát ăn chó','DOG-BOWL-001', @CatAccDog,@B_Acana,'Accessory','Dog',0.5,'20x20x8 cm',NULL,
       N'Bát ăn chó bằng inox, chống trượt',N'Bát ăn chó inox',80000,60000,40000,0,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='DOG-BOWL-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Khay cát mèo','CAT-LITTER-001', @CatAccCat,@B_Acana,'Accessory','Cat',2.0,'50x40x15 cm',NULL,
       N'Khay cát mèo có nắp, chống tràn',N'Khay cát mèo cao cấp',200000,180000,120000,0,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='CAT-LITTER-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Vòng cổ mèo','CAT-COLLAR-001', @CatAccCat,@B_Acana,'Accessory','Cat',0.1,'25x2 cm',NULL,
       N'Vòng cổ mèo có chuông',N'Vòng cổ mèo',50000,40000,25000,0,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='CAT-COLLAR-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Cột mài vuốt','CAT-SCRATCH-001', @CatAccCat,@B_Acana,'Accessory','Cat',1.0,'60x15x15 cm',NULL,
       N'Cột mài vuốt cho mèo, có đồ chơi',N'Cột mài vuốt mèo',180000,150000,100000,1,1,1
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='CAT-SCRATCH-001');

/* 7) EXTENDED 7 PRODUCTS (idempotent) */
INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Purina ONE Adult Dog','PURINA-DOG-ADULT-001', @CatFoodDog,@B_Purina,'Food','Dog',3.0,'30x20x10 cm','2026-02-28',
       N'Thức ăn khô Purina ONE cho chó trưởng thành, giàu protein và khoáng chất',N'Thức ăn khô Purina ONE cho chó',350000,320000,230000,1,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='PURINA-DOG-ADULT-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Orijen Adult Dog','ORIJEN-DOG-ADULT-001', @CatFoodDog,@B_Orijen,'Food','Dog',2.0,'28x18x9 cm','2026-03-31',
       N'Thức ăn hạt Orijen cho chó, thành phần thịt tươi giàu dinh dưỡng',N'Thức ăn hạt Orijen cho chó',550000,520000,400000,1,1,1
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='ORIJEN-DOG-ADULT-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Acana Indoor Cat','ACANA-CAT-INDOOR-001', @CatFoodCat,@B_Acana,'Food','Cat',1.8,'25x18x8 cm','2026-01-31',
       N'Thức ăn cho mèo sống trong nhà, kiểm soát cân nặng và bóng lông',N'Thức ăn Acana cho mèo nhà',380000,350000,260000,1,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='ACANA-CAT-INDOOR-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Bóng đồ chơi cho chó','DOG-TOY-BALL-001', @CatToy,@B_Royal,'Accessory','Dog',0.2,'10x10x10 cm',NULL,
       N'Bóng cao su đàn hồi, giúp chó vận động và giải trí',N'Bóng đồ chơi cao su cho chó',70000,60000,30000,1,1,1
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='DOG-TOY-BALL-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Chuột đồ chơi cho mèo','CAT-TOY-MOUSE-001', @CatToy,@B_Whiskas,'Accessory','Cat',0.1,'8x5x4 cm',NULL,
       N'Chuột giả có chuông, kích thích bản năng săn mồi của mèo',N'Chuột đồ chơi cho mèo',60000,50000,25000,1,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='CAT-TOY-MOUSE-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Sữa tắm chó dịu nhẹ','DOG-SHAMPOO-001', @CatHyg,@B_Hills,'Accessory','Dog',0.5,'20x8x5 cm',NULL,
       N'Sữa tắm dịu nhẹ cho chó, giảm rụng lông và khử mùi',N'Sữa tắm cho chó',120000,100000,60000,1,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='DOG-SHAMPOO-001');

INSERT INTO Products (ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType, Weight, Dimensions, ExpiryDate, Description, ShortDescription, Price, SalePrice, Cost, IsNew, IsActive, IsFeatured)
SELECT N'Cát vệ sinh vón cục','CAT-LITTER-CLUMP-001', @CatHyg,@B_Purina,'Accessory','Cat',5.0,'40x30x10 cm',NULL,
       N'Cát vệ sinh vón cục, khử mùi tốt, dễ dọn dẹp cho mèo',N'Cát vệ sinh vón cục cho mèo',260000,230000,150000,1,1,0
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode='CAT-LITTER-CLUMP-001');

/* 8) INVENTORY for all existing products that lack inventory */
INSERT INTO Inventory (ProductID, QuantityInStock, MinStockLevel, MaxStockLevel)
SELECT p.ProductID, 50, 10, 200
FROM Products p
LEFT JOIN Inventory i ON i.ProductID = p.ProductID
WHERE i.ProductID IS NULL;

/* 9) MASS-GENERATE 80 DEMO PRODUCTS (idempotent) */

;WITH Tally AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Tally WHERE n < 80
),
Gen AS (
    SELECT
        n,
        CASE ((n - 1) % 6)
            WHEN 0 THEN @CatFoodDog
            WHEN 1 THEN @CatFoodCat
            WHEN 2 THEN @CatAccDog
            WHEN 3 THEN @CatAccCat
            WHEN 4 THEN @CatToy
            WHEN 5 THEN @CatHyg
        END AS CategoryID,
        CASE ((n - 1) % 8)
            WHEN 0 THEN @B_Royal
            WHEN 1 THEN @B_Whiskas
            WHEN 2 THEN @B_Pedigree
            WHEN 3 THEN @B_Felix
            WHEN 4 THEN @B_Hills
            WHEN 5 THEN @B_Purina
            WHEN 6 THEN @B_Orijen
            WHEN 7 THEN @B_Acana
        END AS BrandID,
        CASE ((n - 1) % 6)
            WHEN 0 THEN 'DOG-FOOD'
            WHEN 1 THEN 'CAT-FOOD'
            WHEN 2 THEN 'DOG-ACC'
            WHEN 3 THEN 'CAT-ACC'
            WHEN 4 THEN 'PET-TOY'
            WHEN 5 THEN 'PET-HYGIENE'
        END AS GroupCode,
        CASE ((n - 1) % 6)
            WHEN 0 THEN 'Food'
            WHEN 1 THEN 'Food'
            WHEN 2 THEN 'Accessory'
            WHEN 3 THEN 'Accessory'
            WHEN 4 THEN 'Accessory'
            WHEN 5 THEN 'Accessory'
        END AS ProductType,
        CASE ((n - 1) % 6)
            WHEN 0 THEN 'Dog'
            WHEN 1 THEN 'Cat'
            WHEN 2 THEN 'Dog'
            WHEN 3 THEN 'Cat'
            WHEN 4 THEN 'All'
            WHEN 5 THEN 'All'
        END AS PetType
    FROM Tally
)
INSERT INTO Products
(
    ProductName, ProductCode, CategoryID, BrandID, ProductType, PetType,
    Weight, Dimensions, ExpiryDate,
    Description, ShortDescription,
    Price, SalePrice, Cost,
    IsNew, IsActive, IsFeatured
)
SELECT
    /* ProductName */
    N'Demo ' + g.GroupCode + N' ' + RIGHT('000' + CAST(g.n AS VARCHAR(3)), 3) AS ProductName,
    /* ProductCode */
    'DEMO-' + g.GroupCode + '-' + RIGHT('000' + CAST(g.n AS VARCHAR(3)), 3)   AS ProductCode,
    g.CategoryID,
    g.BrandID,
    g.ProductType,
    g.PetType,
    /* Weight */
    CASE g.GroupCode WHEN 'DOG-FOOD' THEN 2.0
                     WHEN 'CAT-FOOD' THEN 1.5
                     WHEN 'PET-HYGIENE' THEN 0.6
                     WHEN 'PET-TOY' THEN 0.2
                     WHEN 'DOG-ACC' THEN 0.8
                     WHEN 'CAT-ACC' THEN 0.5
                     ELSE 1.0 END AS Weight,
    /* Dimensions */
    CASE g.GroupCode WHEN 'DOG-FOOD' THEN '30x20x10 cm'
                     WHEN 'CAT-FOOD' THEN '25x18x8 cm'
                     WHEN 'PET-TOY' THEN '10x10x10 cm'
                     WHEN 'PET-HYGIENE' THEN '22x8x5 cm'
                     WHEN 'DOG-ACC' THEN '40x30x15 cm'
                     WHEN 'CAT-ACC' THEN '35x25x12 cm'
                     ELSE '25x18x8 cm' END AS Dimensions,
    /* ExpiryDate: only for Food, otherwise NULL */
    CASE WHEN g.ProductType = 'Food' THEN CONVERT(date, '2026-12-31') ELSE NULL END AS ExpiryDate,
    /* Description */
    N'Sản phẩm demo ' + g.GroupCode + N' – tự động sinh.',
    N'SP demo ' + g.GroupCode,
    /* Price / SalePrice / Cost: simple tiers */
    CASE g.GroupCode WHEN 'DOG-FOOD' THEN 180000
                     WHEN 'CAT-FOOD' THEN 160000
                     WHEN 'DOG-ACC' THEN 220000
                     WHEN 'CAT-ACC' THEN 200000
                     WHEN 'PET-TOY' THEN  80000
                     WHEN 'PET-HYGIENE' THEN 120000
                     ELSE 150000 END AS Price,
    CASE g.GroupCode WHEN 'DOG-FOOD' THEN 150000
                     WHEN 'CAT-FOOD' THEN 140000
                     WHEN 'DOG-ACC' THEN 190000
                     WHEN 'CAT-ACC' THEN 170000
                     WHEN 'PET-TOY' THEN  65000
                     WHEN 'PET-HYGIENE' THEN 100000
                     ELSE 130000 END AS SalePrice,
    CASE g.GroupCode WHEN 'DOG-FOOD' THEN 100000
                     WHEN 'CAT-FOOD' THEN  90000
                     WHEN 'DOG-ACC' THEN 130000
                     WHEN 'CAT-ACC' THEN 120000
                     WHEN 'PET-TOY' THEN  30000
                     WHEN 'PET-HYGIENE' THEN  60000
                     ELSE  90000 END AS Cost,
    /* Flags */
    1 AS IsNew, 1 AS IsActive,
    CASE WHEN ((g.n - 1) % 10) IN (0,1) THEN 1 ELSE 0 END AS IsFeatured
FROM Gen g
WHERE NOT EXISTS (
    SELECT 1 FROM Products p
    WHERE p.ProductCode = 'DEMO-' + g.GroupCode + '-' + RIGHT('000' + CAST(g.n AS VARCHAR(3)), 3)
)
OPTION (MAXRECURSION 0);

/* 10) INVENTORY for new DEMO products (that still lack inventory) */
INSERT INTO Inventory (ProductID, QuantityInStock, MinStockLevel, MaxStockLevel)
SELECT p.ProductID, 
       CASE WHEN p.ProductType='Food' THEN 100 ELSE 60 END AS QuantityInStock,
       10, 
       CASE WHEN p.ProductType='Food' THEN 300 ELSE 150 END AS MaxStockLevel
FROM Products p
LEFT JOIN Inventory i ON i.ProductID = p.ProductID
WHERE i.ProductID IS NULL
  AND p.ProductCode LIKE 'DEMO-%';

/* ========== SUMMARY ========== */
DECLARE 
    @ProductCount   INT,
    @InventoryCount INT;

SELECT @ProductCount   = COUNT(*) FROM Products;
SELECT @InventoryCount = COUNT(*) FROM Inventory;

PRINT '==========================================';
PRINT N'TỔNG SẢN PHẨM (Products): ' + CAST(@ProductCount AS VARCHAR(10));
PRINT N'TỔNG DÒNG TỒN KHO (Inventory): ' + CAST(@InventoryCount AS VARCHAR(10));
PRINT '==========================================';

COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    DECLARE @Msg NVARCHAR(4000)=ERROR_MESSAGE(), @Line INT=ERROR_LINE(), @Num INT=ERROR_NUMBER();
    PRINT 'SEED FAILED at line ' + CAST(@Line AS VARCHAR(10)) + ' (Err ' + CAST(@Num AS VARCHAR(10)) + '): ' + @Msg;
END CATCH;
