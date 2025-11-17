
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Addresses]') AND type IN ('U'))
	DROP TABLE [dbo].[Addresses]
GO

CREATE TABLE [dbo].[Addresses] (
  [AddressID] int  IDENTITY(1,1) NOT NULL,
  [UserID] int  NOT NULL,
  [FullName] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Phone] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Address] nvarchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Ward] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [District] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [City] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [IsDefault] bit DEFAULT 0 NULL,
  [CreatedDate] datetime DEFAULT getdate() NULL
)
GO

ALTER TABLE [dbo].[Addresses] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Addresses
-- ----------------------------
SET IDENTITY_INSERT [dbo].[Addresses] ON
GO

INSERT INTO [dbo].[Addresses] ([AddressID], [UserID], [FullName], [Phone], [Address], [Ward], [District], [City], [IsDefault], [CreatedDate]) VALUES (N'1', N'1', N'Nguy?n Van A', N'0901234567', N'123 Ðu?ng ABC', N'Phu?ng 1', N'Qu?n 1', N'TP. H? Chí Minh', N'0', N'2025-10-15 21:30:37.410')
GO

INSERT INTO [dbo].[Addresses] ([AddressID], [UserID], [FullName], [Phone], [Address], [Ward], [District], [City], [IsDefault], [CreatedDate]) VALUES (N'3', N'2', N'Tr?n Th? B', N'0987654321', N'789 Ðu?ng DEF', N'Phu?ng 3', N'Qu?n 3', N'TP. H? Chí Minh', N'0', N'2025-10-15 21:30:37.410')
GO

SET IDENTITY_INSERT [dbo].[Addresses] OFF
GO

-- ----------------------------
-- Table structure for OrderStatuses
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderStatuses]') AND type IN ('U'))
	DROP TABLE [dbo].[OrderStatuses]
GO

CREATE TABLE [dbo].[OrderStatuses] (
  [StatusID] int  IDENTITY(1,1) NOT NULL,
  [StatusName] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Description] nvarchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [SortOrder] int DEFAULT 0 NULL
)
GO

ALTER TABLE [dbo].[OrderStatuses] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of OrderStatuses
-- ----------------------------
SET IDENTITY_INSERT [dbo].[OrderStatuses] ON
GO

INSERT INTO [dbo].[OrderStatuses] ([StatusID], [StatusName], [Description], [SortOrder]) VALUES (N'1', N'New', N'Ðon hàng m?i', N'1')
GO

INSERT INTO [dbo].[OrderStatuses] ([StatusID], [StatusName], [Description], [SortOrder]) VALUES (N'2', N'Processing', N'Ðang x? lý', N'2')
GO

INSERT INTO [dbo].[OrderStatuses] ([StatusID], [StatusName], [Description], [SortOrder]) VALUES (N'3', N'Shipping', N'Ðang giao hàng', N'3')
GO

INSERT INTO [dbo].[OrderStatuses] ([StatusID], [StatusName], [Description], [SortOrder]) VALUES (N'4', N'Delivered', N'Ðã giao hàng', N'4')
GO

INSERT INTO [dbo].[OrderStatuses] ([StatusID], [StatusName], [Description], [SortOrder]) VALUES (N'5', N'Cancelled', N'Ðã h?y', N'5')
GO

SET IDENTITY_INSERT [dbo].[OrderStatuses] OFF
GO


-- ----------------------------
-- Table structure for PaymentMethods
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentMethods]') AND type IN ('U'))
	DROP TABLE [dbo].[PaymentMethods]
GO

CREATE TABLE [dbo].[PaymentMethods] (
  [PaymentMethodID] int  IDENTITY(1,1) NOT NULL,
  [MethodName] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Description] nvarchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [IsActive] bit DEFAULT 1 NULL
)
GO

ALTER TABLE [dbo].[PaymentMethods] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of PaymentMethods
-- ----------------------------
SET IDENTITY_INSERT [dbo].[PaymentMethods] ON
GO

INSERT INTO [dbo].[PaymentMethods] ([PaymentMethodID], [MethodName], [Description], [IsActive]) VALUES (N'1', N'COD', N'Thanh toán khi nhận hàng', N'0')
GO

INSERT INTO [dbo].[PaymentMethods] ([PaymentMethodID], [MethodName], [Description], [IsActive]) VALUES (N'2', N'VNPay', N'Thanh toán qua VNPay', N'0')
GO

SET IDENTITY_INSERT [dbo].[PaymentMethods] OFF
GO


-- ----------------------------
-- Table structure for Categories
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Categories]') AND type IN ('U'))
	DROP TABLE [dbo].[Categories]
GO

CREATE TABLE [dbo].[Categories] (
  [CategoryID] int  IDENTITY(1,1) NOT NULL,
  [CategoryName] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [ParentCategoryID] int  NULL,
  [Description] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [IsActive] bit DEFAULT 1 NULL,
  [SortOrder] int DEFAULT 0 NULL,
  [CreatedDate] datetime DEFAULT getdate() NULL
)
GO

ALTER TABLE [dbo].[Categories] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Categories
-- ----------------------------
SET IDENTITY_INSERT [dbo].[Categories] ON
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'1', N'Thức ăn chó', NULL, N'Các loại thức ăn  dành cho chó', N'0', N'0', N'2025-10-06 09:24:34.493')
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'2', N'Thức ăn mèo', NULL, N'Các loại thức ăn dành cho mèo', N'0', N'0', N'2025-10-06 09:24:34.493')
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'3', N'Phụ kiện chó', NULL, N'Dây dắt, chuồng, đồ chơi cho chó', N'0', N'0', N'2025-10-06 09:24:34.493')
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'4', N'Phụ kiện mèo', NULL, N'Khay cát, vòng cổ, đồ chơi cho mèo', N'0', N'0', N'2025-10-06 09:24:34.493')
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'5', N'Th?c an chó', NULL, N'Các lo?i th?c an dành cho chó', N'0', N'1', N'2025-10-15 21:30:37.410')
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'6', N'Th?c an mèo', NULL, N'Các lo?i th?c an dành cho mèo', N'0', N'2', N'2025-10-15 21:30:37.410')
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'7', N'Ph? ki?n chó', NULL, N'Dây d?t, chu?ng, d? choi cho chó', N'0', N'3', N'2025-10-15 21:30:37.410')
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'8', N'Ph? ki?n mèo', NULL, N'Khay cát, vòng c?, d? choi cho mèo', N'0', N'4', N'2025-10-15 21:30:37.410')
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'9', N'Th?c an khô', NULL, N'Th?c an khô cho thú cung', N'0', N'5', N'2025-10-15 21:30:37.410')
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'10', N'Th?c an u?t', NULL, N'Th?c an u?t cho thú cung', N'0', N'6', N'2025-10-15 21:30:37.410')
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'11', N'Ð? choi', NULL, N'Ð? choi cho thú cung', N'0', N'7', N'2025-10-15 21:30:37.410')
GO

INSERT INTO [dbo].[Categories] ([CategoryID], [CategoryName], [ParentCategoryID], [Description], [IsActive], [SortOrder], [CreatedDate]) VALUES (N'12', N'V? sinh', NULL, N'S?n ph?m v? sinh cho thú cung', N'0', N'8', N'2025-10-15 21:30:37.410')
GO

SET IDENTITY_INSERT [dbo].[Categories] OFF
GO


-- ----------------------------
-- Table structure for Brands
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Brands]') AND type IN ('U'))
	DROP TABLE [dbo].[Brands]
GO

CREATE TABLE [dbo].[Brands] (
  [BrandID] int  IDENTITY(1,1) NOT NULL,
  [BrandName] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [LogoURL] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [Description] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [IsActive] bit DEFAULT 1 NULL,
  [CreatedDate] datetime DEFAULT getdate() NULL
)
GO

ALTER TABLE [dbo].[Brands] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Brands
-- ----------------------------
SET IDENTITY_INSERT [dbo].[Brands] ON
GO

INSERT INTO [dbo].[Brands] ([BrandID], [BrandName], [LogoURL], [Description], [IsActive], [CreatedDate]) VALUES (N'46', N'Royal Canin', NULL, N'Thuong hi?u th?c an cao c?p cho thú cung', N'0', N'2025-10-15 21:39:57.657')
GO

INSERT INTO [dbo].[Brands] ([BrandID], [BrandName], [LogoURL], [Description], [IsActive], [CreatedDate]) VALUES (N'47', N'Whiskas', NULL, N'Th?c an cho mèo', N'0', N'2025-10-15 21:39:57.657')
GO

INSERT INTO [dbo].[Brands] ([BrandID], [BrandName], [LogoURL], [Description], [IsActive], [CreatedDate]) VALUES (N'48', N'Pedigree', NULL, N'Th?c an cho chó', N'0', N'2025-10-15 21:39:57.657')
GO

INSERT INTO [dbo].[Brands] ([BrandID], [BrandName], [LogoURL], [Description], [IsActive], [CreatedDate]) VALUES (N'49', N'Felix', NULL, N'Th?c an u?t cho mèo', N'0', N'2025-10-15 21:39:57.657')
GO

INSERT INTO [dbo].[Brands] ([BrandID], [BrandName], [LogoURL], [Description], [IsActive], [CreatedDate]) VALUES (N'50', N'Hill''s', NULL, N'Th?c an dinh du?ng cho thú cung', N'0', N'2025-10-15 21:39:57.657')
GO

INSERT INTO [dbo].[Brands] ([BrandID], [BrandName], [LogoURL], [Description], [IsActive], [CreatedDate]) VALUES (N'51', N'Purina', NULL, N'Th?c an da d?ng cho thú cung', N'0', N'2025-10-15 21:39:57.657')
GO

INSERT INTO [dbo].[Brands] ([BrandID], [BrandName], [LogoURL], [Description], [IsActive], [CreatedDate]) VALUES (N'52', N'Orijen', NULL, N'Th?c an cao c?p cho thú cung', N'0', N'2025-10-15 21:39:57.657')
GO

INSERT INTO [dbo].[Brands] ([BrandID], [BrandName], [LogoURL], [Description], [IsActive], [CreatedDate]) VALUES (N'53', N'Acana', NULL, N'Th?c an t? nhiên cho thú cung', N'0', N'2025-10-15 21:39:57.657')
GO

SET IDENTITY_INSERT [dbo].[Brands] OFF
GO


-- ----------------------------
-- Table structure for CustomerProfiles
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerProfiles]') AND type IN ('U'))
	DROP TABLE [dbo].[CustomerProfiles]
GO

CREATE TABLE [dbo].[CustomerProfiles] (
  [ProfileID] int  IDENTITY(1,1) NOT NULL,
  [UserID] int  NOT NULL,
  [DateOfBirth] date  NULL,
  [Gender] nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [TotalOrders] int DEFAULT 0 NULL,
  [TotalSpent] decimal(15,2) DEFAULT 0 NULL,
  [MembershipLevel] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'Bronze' NULL,
  [Points] int DEFAULT 0 NULL
)
GO

ALTER TABLE [dbo].[CustomerProfiles] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of CustomerProfiles
-- ----------------------------
SET IDENTITY_INSERT [dbo].[CustomerProfiles] ON
GO

INSERT INTO [dbo].[CustomerProfiles] ([ProfileID], [UserID], [DateOfBirth], [Gender], [TotalOrders], [TotalSpent], [MembershipLevel], [Points]) VALUES (N'1', N'1', N'2025-10-15', N'Nam', N'20', N'14700000.00', N'Bronze', N'1470')
GO

INSERT INTO [dbo].[CustomerProfiles] ([ProfileID], [UserID], [DateOfBirth], [Gender], [TotalOrders], [TotalSpent], [MembershipLevel], [Points]) VALUES (N'2', N'2', N'2025-10-09', N'Nam', N'20', N'16250000.00', N'Bronze', N'1620')
GO

SET IDENTITY_INSERT [dbo].[CustomerProfiles] OFF
GO