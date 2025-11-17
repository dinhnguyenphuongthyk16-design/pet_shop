
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


-- ----------------------------
-- Table structure for ContactMessages
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactMessages]') AND type IN ('U'))
	DROP TABLE [dbo].[ContactMessages]
GO

CREATE TABLE [dbo].[ContactMessages] (
  [MessageID] int  IDENTITY(1,1) NOT NULL,
  [FullName] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Email] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Phone] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [Subject] nvarchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Message] nvarchar(2000) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'New' NULL,
  [ReplyMessage] nvarchar(2000) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [RepliedBy] int  NULL,
  [RepliedDate] datetime  NULL,
  [CreatedDate] datetime DEFAULT getdate() NULL
)
GO

ALTER TABLE [dbo].[ContactMessages] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of ContactMessages
-- ----------------------------
SET IDENTITY_INSERT [dbo].[ContactMessages] ON
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'1', N'Nguy?n Van C', N'nguyenvanc@email.com', N'0912345678', N'H?i v? s?n ph?m', N'Tôi mu?n h?i v? th?c an cho chó con, có s?n ph?m nào phù h?p không?', N'New', NULL, NULL, NULL, N'2024-01-20 09:00:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'2', N'Tr?n Th? D', N'tranthid@email.com', N'0987654321', N'Khi?u n?i', N'Tôi dã d?t hàng nhung chua nh?n du?c, có th? ki?m tra giúp tôi không?', N'Read', NULL, NULL, NULL, N'2024-01-19 15:30:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'3', N'Lê Van E', N'levane@email.com', N'0909876543', N'Tu v?n', N'Tôi có con mèo 6 tháng tu?i, nên cho an th?c an gì?', N'Replied', NULL, NULL, NULL, N'2024-01-18 11:20:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'4', N'Nguy?n Van C', N'nguyenvanc@email.com', N'0912345678', N'H?i v? s?n ph?m', N'Tôi mu?n h?i v? th?c an cho chó con, có s?n ph?m nào phù h?p không?', N'New', NULL, NULL, NULL, N'2024-01-20 09:00:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'5', N'Tr?n Th? D', N'tranthid@email.com', N'0987654321', N'Khi?u n?i', N'Tôi dã d?t hàng nhung chua nh?n du?c, có th? ki?m tra giúp tôi không?', N'Read', NULL, NULL, NULL, N'2024-01-19 15:30:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'6', N'Lê Van E', N'levane@email.com', N'0909876543', N'Tu v?n', N'Tôi có con mèo 6 tháng tu?i, nên cho an th?c an gì?', N'Replied', NULL, NULL, NULL, N'2024-01-18 11:20:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'7', N'Nguy?n Van C', N'nguyenvanc@email.com', N'0912345678', N'H?i v? s?n ph?m', N'Tôi mu?n h?i v? th?c an cho chó con, có s?n ph?m nào phù h?p không?', N'New', NULL, NULL, NULL, N'2024-01-20 09:00:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'8', N'Tr?n Th? D', N'tranthid@email.com', N'0987654321', N'Khi?u n?i', N'Tôi dã d?t hàng nhung chua nh?n du?c, có th? ki?m tra giúp tôi không?', N'Read', NULL, NULL, NULL, N'2024-01-19 15:30:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'9', N'Lê Van E', N'levane@email.com', N'0909876543', N'Tu v?n', N'Tôi có con mèo 6 tháng tu?i, nên cho an th?c an gì?', N'Replied', NULL, NULL, NULL, N'2024-01-18 11:20:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'10', N'Nguy?n Van C', N'nguyenvanc@email.com', N'0912345678', N'H?i v? s?n ph?m', N'Tôi mu?n h?i v? th?c an cho chó con, có s?n ph?m nào phù h?p không?', N'New', NULL, NULL, NULL, N'2024-01-20 09:00:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'11', N'Tr?n Th? D', N'tranthid@email.com', N'0987654321', N'Khi?u n?i', N'Tôi dã d?t hàng nhung chua nh?n du?c, có th? ki?m tra giúp tôi không?', N'Read', NULL, NULL, NULL, N'2024-01-19 15:30:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'12', N'Lê Van E', N'levane@email.com', N'0909876543', N'Tu v?n', N'Tôi có con mèo 6 tháng tu?i, nên cho an th?c an gì?', N'Replied', NULL, NULL, NULL, N'2024-01-18 11:20:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'13', N'Nguy?n Van C', N'nguyenvanc@email.com', N'0912345678', N'H?i v? s?n ph?m', N'Tôi mu?n h?i v? th?c an cho chó con, có s?n ph?m nào phù h?p không?', N'New', NULL, NULL, NULL, N'2024-01-20 09:00:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'14', N'Tr?n Th? D', N'tranthid@email.com', N'0987654321', N'Khi?u n?i', N'Tôi dã d?t hàng nhung chua nh?n du?c, có th? ki?m tra giúp tôi không?', N'Read', NULL, NULL, NULL, N'2024-01-19 15:30:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'15', N'Lê Van E', N'levane@email.com', N'0909876543', N'Tu v?n', N'Tôi có con mèo 6 tháng tu?i, nên cho an th?c an gì?', N'Replied', NULL, NULL, NULL, N'2024-01-18 11:20:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'16', N'Nguy?n Van C', N'nguyenvanc@email.com', N'0912345678', N'H?i v? s?n ph?m', N'Tôi mu?n h?i v? th?c an cho chó con, có s?n ph?m nào phù h?p không?', N'New', NULL, NULL, NULL, N'2024-01-20 09:00:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'17', N'Tr?n Th? D', N'tranthid@email.com', N'0987654321', N'Khi?u n?i', N'Tôi dã d?t hàng nhung chua nh?n du?c, có th? ki?m tra giúp tôi không?', N'Read', NULL, NULL, NULL, N'2024-01-19 15:30:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'18', N'Lê Van E', N'levane@email.com', N'0909876543', N'Tu v?n', N'Tôi có con mèo 6 tháng tu?i, nên cho an th?c an gì?', N'Replied', NULL, NULL, NULL, N'2024-01-18 11:20:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'19', N'Nguy?n Van C', N'nguyenvanc@email.com', N'0912345678', N'H?i v? s?n ph?m', N'Tôi mu?n h?i v? th?c an cho chó con, có s?n ph?m nào phù h?p không?', N'New', NULL, NULL, NULL, N'2024-01-20 09:00:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'20', N'Tr?n Th? D', N'tranthid@email.com', N'0987654321', N'Khi?u n?i', N'Tôi dã d?t hàng nhung chua nh?n du?c, có th? ki?m tra giúp tôi không?', N'Read', NULL, NULL, NULL, N'2024-01-19 15:30:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'21', N'Lê Van E', N'levane@email.com', N'0909876543', N'Tu v?n', N'Tôi có con mèo 6 tháng tu?i, nên cho an th?c an gì?', N'Replied', NULL, NULL, NULL, N'2024-01-18 11:20:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'22', N'Nguy?n Van C', N'nguyenvanc@email.com', N'0912345678', N'H?i v? s?n ph?m', N'Tôi mu?n h?i v? th?c an cho chó con, có s?n ph?m nào phù h?p không?', N'New', NULL, NULL, NULL, N'2024-01-20 09:00:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'23', N'Tr?n Th? D', N'tranthid@email.com', N'0987654321', N'Khi?u n?i', N'Tôi dã d?t hàng nhung chua nh?n du?c, có th? ki?m tra giúp tôi không?', N'Read', NULL, NULL, NULL, N'2024-01-19 15:30:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'24', N'Lê Van E', N'levane@email.com', N'0909876543', N'Tu v?n', N'Tôi có con mèo 6 tháng tu?i, nên cho an th?c an gì?', N'Replied', NULL, NULL, NULL, N'2024-01-18 11:20:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'25', N'Nguy?n Van C', N'nguyenvanc@email.com', N'0912345678', N'H?i v? s?n ph?m', N'Tôi mu?n h?i v? th?c an cho chó con, có s?n ph?m nào phù h?p không?', N'New', NULL, NULL, NULL, N'2024-01-20 09:00:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'26', N'Tr?n Th? D', N'tranthid@email.com', N'0987654321', N'Khi?u n?i', N'Tôi dã d?t hàng nhung chua nh?n du?c, có th? ki?m tra giúp tôi không?', N'Read', NULL, NULL, NULL, N'2024-01-19 15:30:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'27', N'Lê Van E', N'levane@email.com', N'0909876543', N'Tu v?n', N'Tôi có con mèo 6 tháng tu?i, nên cho an th?c an gì?', N'Replied', NULL, NULL, NULL, N'2024-01-18 11:20:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'28', N'Nguy?n Van C', N'nguyenvanc@email.com', N'0912345678', N'H?i v? s?n ph?m', N'Tôi mu?n h?i v? th?c an cho chó con, có s?n ph?m nào phù h?p không?', N'New', NULL, NULL, NULL, N'2024-01-20 09:00:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'29', N'Tr?n Th? D', N'tranthid@email.com', N'0987654321', N'Khi?u n?i', N'Tôi dã d?t hàng nhung chua nh?n du?c, có th? ki?m tra giúp tôi không?', N'Read', NULL, NULL, NULL, N'2024-01-19 15:30:00.000')
GO

INSERT INTO [dbo].[ContactMessages] ([MessageID], [FullName], [Email], [Phone], [Subject], [Message], [Status], [ReplyMessage], [RepliedBy], [RepliedDate], [CreatedDate]) VALUES (N'30', N'Lê Van E', N'levane@email.com', N'0909876543', N'Tu v?n', N'Tôi có con mèo 6 tháng tu?i, nên cho an th?c an gì?', N'Replied', NULL, NULL, NULL, N'2024-01-18 11:20:00.000')
GO

SET IDENTITY_INSERT [dbo].[ContactMessages] OFF
GO


-- ----------------------------
-- Table structure for Banners
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Banners]') AND type IN ('U'))
	DROP TABLE [dbo].[Banners]
GO

CREATE TABLE [dbo].[Banners] (
  [BannerID] int  IDENTITY(1,1) NOT NULL,
  [BannerName] nvarchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [ImageURL] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [LinkURL] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [AltText] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [Position] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [SortOrder] int DEFAULT 0 NULL,
  [StartDate] datetime  NULL,
  [EndDate] datetime  NULL,
  [IsActive] bit DEFAULT 1 NULL,
  [CreatedDate] datetime DEFAULT getdate() NULL
)
GO

ALTER TABLE [dbo].[Banners] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Banners
-- ----------------------------
SET IDENTITY_INSERT [dbo].[Banners] ON
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'1', N'Banner chính trang ch?', N'/images/banners/homepage-banner-1.jpg', N'/products', N'Khuy?n mãi th?c an thú cung', N'Homepage', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:37.430')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'2', N'Banner s?n ph?m m?i', N'/images/banners/new-products-banner.jpg', N'/products?filter=new', N'S?n ph?m m?i cho thú cung', N'Homepage', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:37.430')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'3', N'Banner khuy?n mãi', N'/images/banners/promotion-banner.jpg', N'/promotions', N'Gi?m giá lên d?n 50%', N'Homepage', N'3', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:37.430')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'4', N'Banner th?c an chó', N'/images/banners/dog-food-banner.jpg', N'/category/1', N'Th?c an cho chó', N'Category', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:37.430')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'5', N'Banner th?c an mèo', N'/images/banners/cat-food-banner.jpg', N'/category/2', N'Th?c an cho mèo', N'Category', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:37.430')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'6', N'Banner chính trang ch?', N'/images/banners/homepage-banner-1.jpg', N'/products', N'Khuy?n mãi th?c an thú cung', N'Homepage', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:45.050')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'7', N'Banner s?n ph?m m?i', N'/images/banners/new-products-banner.jpg', N'/products?filter=new', N'S?n ph?m m?i cho thú cung', N'Homepage', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:45.050')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'8', N'Banner khuy?n mãi', N'/images/banners/promotion-banner.jpg', N'/promotions', N'Gi?m giá lên d?n 50%', N'Homepage', N'3', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:45.050')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'9', N'Banner th?c an chó', N'/images/banners/dog-food-banner.jpg', N'/category/1', N'Th?c an cho chó', N'Category', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:45.050')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'10', N'Banner th?c an mèo', N'/images/banners/cat-food-banner.jpg', N'/category/2', N'Th?c an cho mèo', N'Category', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:45.050')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'11', N'Banner chính trang ch?', N'/images/banners/homepage-banner-1.jpg', N'/products', N'Khuy?n mãi th?c an thú cung', N'Homepage', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:57.333')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'12', N'Banner s?n ph?m m?i', N'/images/banners/new-products-banner.jpg', N'/products?filter=new', N'S?n ph?m m?i cho thú cung', N'Homepage', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:57.333')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'13', N'Banner khuy?n mãi', N'/images/banners/promotion-banner.jpg', N'/promotions', N'Gi?m giá lên d?n 50%', N'Homepage', N'3', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:57.333')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'14', N'Banner th?c an chó', N'/images/banners/dog-food-banner.jpg', N'/category/1', N'Th?c an cho chó', N'Category', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:57.333')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'15', N'Banner th?c an mèo', N'/images/banners/cat-food-banner.jpg', N'/category/2', N'Th?c an cho mèo', N'Category', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:30:57.333')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'16', N'Banner chính trang ch?', N'/images/banners/homepage-banner-1.jpg', N'/products', N'Khuy?n mãi th?c an thú cung', N'Homepage', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:31:38.490')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'17', N'Banner s?n ph?m m?i', N'/images/banners/new-products-banner.jpg', N'/products?filter=new', N'S?n ph?m m?i cho thú cung', N'Homepage', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:31:38.490')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'18', N'Banner khuy?n mãi', N'/images/banners/promotion-banner.jpg', N'/promotions', N'Gi?m giá lên d?n 50%', N'Homepage', N'3', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:31:38.490')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'19', N'Banner th?c an chó', N'/images/banners/dog-food-banner.jpg', N'/category/1', N'Th?c an cho chó', N'Category', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:31:38.490')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'20', N'Banner th?c an mèo', N'/images/banners/cat-food-banner.jpg', N'/category/2', N'Th?c an cho mèo', N'Category', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:31:38.490')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'21', N'Banner chính trang ch?', N'/images/banners/homepage-banner-1.jpg', N'/products', N'Khuy?n mãi th?c an thú cung', N'Homepage', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:33:03.030')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'22', N'Banner s?n ph?m m?i', N'/images/banners/new-products-banner.jpg', N'/products?filter=new', N'S?n ph?m m?i cho thú cung', N'Homepage', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:33:03.030')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'23', N'Banner khuy?n mãi', N'/images/banners/promotion-banner.jpg', N'/promotions', N'Gi?m giá lên d?n 50%', N'Homepage', N'3', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:33:03.030')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'24', N'Banner th?c an chó', N'/images/banners/dog-food-banner.jpg', N'/category/1', N'Th?c an cho chó', N'Category', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:33:03.030')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'25', N'Banner th?c an mèo', N'/images/banners/cat-food-banner.jpg', N'/category/2', N'Th?c an cho mèo', N'Category', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:33:03.030')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'26', N'Banner chính trang ch?', N'/images/banners/homepage-banner-1.jpg', N'/products', N'Khuy?n mãi th?c an thú cung', N'Homepage', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:33:17.030')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'27', N'Banner s?n ph?m m?i', N'/images/banners/new-products-banner.jpg', N'/products?filter=new', N'S?n ph?m m?i cho thú cung', N'Homepage', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:33:17.030')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'28', N'Banner khuy?n mãi', N'/images/banners/promotion-banner.jpg', N'/promotions', N'Gi?m giá lên d?n 50%', N'Homepage', N'3', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:33:17.030')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'29', N'Banner th?c an chó', N'/images/banners/dog-food-banner.jpg', N'/category/1', N'Th?c an cho chó', N'Category', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:33:17.030')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'30', N'Banner th?c an mèo', N'/images/banners/cat-food-banner.jpg', N'/category/2', N'Th?c an cho mèo', N'Category', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:33:17.030')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'31', N'Banner chính trang ch?', N'/images/banners/homepage-banner-1.jpg', N'/products', N'Khuy?n mãi th?c an thú cung', N'Homepage', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:37:29.933')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'32', N'Banner s?n ph?m m?i', N'/images/banners/new-products-banner.jpg', N'/products?filter=new', N'S?n ph?m m?i cho thú cung', N'Homepage', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:37:29.933')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'33', N'Banner khuy?n mãi', N'/images/banners/promotion-banner.jpg', N'/promotions', N'Gi?m giá lên d?n 50%', N'Homepage', N'3', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:37:29.933')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'34', N'Banner th?c an chó', N'/images/banners/dog-food-banner.jpg', N'/category/1', N'Th?c an cho chó', N'Category', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:37:29.933')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'35', N'Banner th?c an mèo', N'/images/banners/cat-food-banner.jpg', N'/category/2', N'Th?c an cho mèo', N'Category', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:37:29.933')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'36', N'Banner chính trang ch?', N'/images/banners/homepage-banner-1.jpg', N'/products', N'Khuy?n mãi th?c an thú cung', N'Homepage', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:38:44.063')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'37', N'Banner s?n ph?m m?i', N'/images/banners/new-products-banner.jpg', N'/products?filter=new', N'S?n ph?m m?i cho thú cung', N'Homepage', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:38:44.063')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'38', N'Banner khuy?n mãi', N'/images/banners/promotion-banner.jpg', N'/promotions', N'Gi?m giá lên d?n 50%', N'Homepage', N'3', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:38:44.063')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'39', N'Banner th?c an chó', N'/images/banners/dog-food-banner.jpg', N'/category/1', N'Th?c an cho chó', N'Category', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:38:44.063')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'40', N'Banner th?c an mèo', N'/images/banners/cat-food-banner.jpg', N'/category/2', N'Th?c an cho mèo', N'Category', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:38:44.063')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'41', N'Banner chính trang ch?', N'/images/banners/homepage-banner-1.jpg', N'/products', N'Khuy?n mãi th?c an thú cung', N'Homepage', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:39:17.823')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'42', N'Banner s?n ph?m m?i', N'/images/banners/new-products-banner.jpg', N'/products?filter=new', N'S?n ph?m m?i cho thú cung', N'Homepage', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:39:17.823')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'43', N'Banner khuy?n mãi', N'/images/banners/promotion-banner.jpg', N'/promotions', N'Gi?m giá lên d?n 50%', N'Homepage', N'3', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:39:17.823')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'44', N'Banner th?c an chó', N'/images/banners/dog-food-banner.jpg', N'/category/1', N'Th?c an cho chó', N'Category', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:39:17.823')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'45', N'Banner th?c an mèo', N'/images/banners/cat-food-banner.jpg', N'/category/2', N'Th?c an cho mèo', N'Category', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:39:17.823')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'46', N'Banner chính trang ch?', N'/images/banners/homepage-banner-1.jpg', N'/products', N'Khuy?n mãi th?c an thú cung', N'Homepage', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:39:57.663')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'47', N'Banner s?n ph?m m?i', N'/images/banners/new-products-banner.jpg', N'/products?filter=new', N'S?n ph?m m?i cho thú cung', N'Homepage', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:39:57.663')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'48', N'Banner khuy?n mãi', N'/images/banners/promotion-banner.jpg', N'/promotions', N'Gi?m giá lên d?n 50%', N'Homepage', N'3', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:39:57.663')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'49', N'Banner th?c an chó', N'/images/banners/dog-food-banner.jpg', N'/category/1', N'Th?c an cho chó', N'Category', N'1', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:39:57.663')
GO

INSERT INTO [dbo].[Banners] ([BannerID], [BannerName], [ImageURL], [LinkURL], [AltText], [Position], [SortOrder], [StartDate], [EndDate], [IsActive], [CreatedDate]) VALUES (N'50', N'Banner th?c an mèo', N'/images/banners/cat-food-banner.jpg', N'/category/2', N'Th?c an cho mèo', N'Category', N'2', N'2024-01-01 00:00:00.000', N'2024-12-31 00:00:00.000', N'0', N'2025-10-15 21:39:57.663')
GO

SET IDENTITY_INSERT [dbo].[Banners] OFF
GO


-- ----------------------------
-- Table structure for ProductImages
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductImages]') AND type IN ('U'))
	DROP TABLE [dbo].[ProductImages]
GO

CREATE TABLE [dbo].[ProductImages] (
  [ImageID] int  IDENTITY(1,1) NOT NULL,
  [ProductID] int  NOT NULL,
  [ImageURL] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [AltText] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [IsPrimary] bit DEFAULT 0 NULL,
  [SortOrder] int DEFAULT 0 NULL,
  [CreatedDate] datetime DEFAULT getdate() NULL
)
GO

ALTER TABLE [dbo].[ProductImages] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of ProductImages
-- ----------------------------
SET IDENTITY_INSERT [dbo].[ProductImages] ON
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'70', N'60', N'/images/products/royal-canin-adult-1.jpg', N'Royal Canin Adult - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'71', N'60', N'/images/products/royal-canin-adult-2.jpg', N'Royal Canin Adult - Hình ph?', N'0', N'2', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'72', N'60', N'/images/products/royal-canin-adult-3.jpg', N'Royal Canin Adult - Hình ph?', N'0', N'3', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'73', N'61', N'/images/products/pedigree-adult-1.jpg', N'Pedigree Adult - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'74', N'61', N'/images/products/pedigree-adult-2.jpg', N'Pedigree Adult - Hình ph?', N'0', N'2', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'75', N'62', N'/images/products/hills-science-1.jpg', N'Hill''s Science Diet - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'76', N'62', N'/images/products/hills-science-2.jpg', N'Hill''s Science Diet - Hình ph?', N'0', N'2', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'77', N'63', N'/images/products/whiskas-adult-1.jpg', N'Whiskas Adult - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'78', N'63', N'/images/products/whiskas-adult-2.jpg', N'Whiskas Adult - Hình ph?', N'0', N'2', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'79', N'64', N'/images/products/felix-wet-1.jpg', N'Felix Wet Food - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'80', N'65', N'/images/products/royal-canin-kitten-1.jpg', N'Royal Canin Kitten - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'81', N'65', N'/images/products/royal-canin-kitten-2.jpg', N'Royal Canin Kitten - Hình ph?', N'0', N'2', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'82', N'66', N'/images/products/dog-leash-1.jpg', N'Dây d?t chó - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'83', N'67', N'/images/products/dog-cage-1.jpg', N'Chu?ng chó - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'84', N'67', N'/images/products/dog-cage-2.jpg', N'Chu?ng chó - Hình ph?', N'0', N'2', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'85', N'68', N'/images/products/dog-bowl-1.jpg', N'Bát an chó - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'86', N'69', N'/images/products/cat-litter-1.jpg', N'Khay cát mèo - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'87', N'69', N'/images/products/cat-litter-2.jpg', N'Khay cát mèo - Hình ph?', N'0', N'2', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'88', N'70', N'/images/products/cat-collar-1.jpg', N'Vòng c? mèo - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'89', N'71', N'/images/products/cat-scratch-1.jpg', N'C?t mài vu?t mèo - Hình chính', N'0', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[ProductImages] ([ImageID], [ProductID], [ImageURL], [AltText], [IsPrimary], [SortOrder], [CreatedDate]) VALUES (N'90', N'71', N'/images/products/cat-scratch-2.jpg', N'C?t mài vu?t mèo - Hình ph?', N'0', N'2', N'2025-10-15 21:39:57.660')
GO

SET IDENTITY_INSERT [dbo].[ProductImages] OFF
GO


-- ----------------------------
-- Table structure for InventoryTransactions
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryTransactions]') AND type IN ('U'))
	DROP TABLE [dbo].[InventoryTransactions]
GO

CREATE TABLE [dbo].[InventoryTransactions] (
  [TransactionID] int  IDENTITY(1,1) NOT NULL,
  [ProductID] int  NOT NULL,
  [TransactionType] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Quantity] int  NOT NULL,
  [UnitPrice] decimal(15,2)  NULL,
  [TotalValue] decimal(15,2)  NULL,
  [ReferenceNumber] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [Notes] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [CreatedBy] int  NOT NULL,
  [CreatedDate] datetime DEFAULT getdate() NULL
)
GO

ALTER TABLE [dbo].[InventoryTransactions] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of InventoryTransactions
-- ----------------------------
SET IDENTITY_INSERT [dbo].[InventoryTransactions] ON
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'43', N'60', N'Import', N'50', N'300000.00', N'15000000.00', N'IMP-001', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'44', N'61', N'Import', N'80', N'120000.00', N'9600000.00', N'IMP-002', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'45', N'62', N'Import', N'30', N'250000.00', N'7500000.00', N'IMP-003', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'46', N'63', N'Import', N'100', N'80000.00', N'8000000.00', N'IMP-004', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'47', N'64', N'Import', N'200', N'15000.00', N'3000000.00', N'IMP-005', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'48', N'65', N'Import', N'40', N'200000.00', N'8000000.00', N'IMP-006', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'49', N'66', N'Import', N'25', N'80000.00', N'2000000.00', N'IMP-007', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'50', N'67', N'Import', N'10', N'500000.00', N'5000000.00', N'IMP-008', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'51', N'68', N'Import', N'60', N'40000.00', N'2400000.00', N'IMP-009', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'52', N'69', N'Import', N'15', N'120000.00', N'1800000.00', N'IMP-010', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'53', N'70', N'Import', N'40', N'25000.00', N'1000000.00', N'IMP-011', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'54', N'71', N'Import', N'20', N'100000.00', N'2000000.00', N'IMP-012', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'55', N'60', N'Export', N'1', N'400000.00', N'400000.00', N'ORDER_20251015223222', N'Bán hàng', N'1', N'2025-10-15 22:32:22.557')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'56', N'60', N'Export', N'1', N'400000.00', N'400000.00', N'ORDER_20251015223605', N'Bán hàng', N'1', N'2025-10-15 22:36:05.050')
GO

SET IDENTITY_INSERT [dbo].[InventoryTransactions] OFF
GO


-- ----------------------------
-- Table structure for InventoryTransactions
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryTransactions]') AND type IN ('U'))
	DROP TABLE [dbo].[InventoryTransactions]
GO

CREATE TABLE [dbo].[InventoryTransactions] (
  [TransactionID] int  IDENTITY(1,1) NOT NULL,
  [ProductID] int  NOT NULL,
  [TransactionType] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Quantity] int  NOT NULL,
  [UnitPrice] decimal(15,2)  NULL,
  [TotalValue] decimal(15,2)  NULL,
  [ReferenceNumber] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [Notes] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [CreatedBy] int  NOT NULL,
  [CreatedDate] datetime DEFAULT getdate() NULL
)
GO

ALTER TABLE [dbo].[InventoryTransactions] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of InventoryTransactions
-- ----------------------------
SET IDENTITY_INSERT [dbo].[InventoryTransactions] ON
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'43', N'60', N'Import', N'50', N'300000.00', N'15000000.00', N'IMP-001', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'44', N'61', N'Import', N'80', N'120000.00', N'9600000.00', N'IMP-002', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'45', N'62', N'Import', N'30', N'250000.00', N'7500000.00', N'IMP-003', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'46', N'63', N'Import', N'100', N'80000.00', N'8000000.00', N'IMP-004', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'47', N'64', N'Import', N'200', N'15000.00', N'3000000.00', N'IMP-005', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'48', N'65', N'Import', N'40', N'200000.00', N'8000000.00', N'IMP-006', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'49', N'66', N'Import', N'25', N'80000.00', N'2000000.00', N'IMP-007', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'50', N'67', N'Import', N'10', N'500000.00', N'5000000.00', N'IMP-008', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'51', N'68', N'Import', N'60', N'40000.00', N'2400000.00', N'IMP-009', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'52', N'69', N'Import', N'15', N'120000.00', N'1800000.00', N'IMP-010', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'53', N'70', N'Import', N'40', N'25000.00', N'1000000.00', N'IMP-011', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'54', N'71', N'Import', N'20', N'100000.00', N'2000000.00', N'IMP-012', N'Nh?p hàng l?n d?u', N'1', N'2025-10-15 21:39:57.660')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'55', N'60', N'Export', N'1', N'400000.00', N'400000.00', N'ORDER_20251015223222', N'Bán hàng', N'1', N'2025-10-15 22:32:22.557')
GO

INSERT INTO [dbo].[InventoryTransactions] ([TransactionID], [ProductID], [TransactionType], [Quantity], [UnitPrice], [TotalValue], [ReferenceNumber], [Notes], [CreatedBy], [CreatedDate]) VALUES (N'56', N'60', N'Export', N'1', N'400000.00', N'400000.00', N'ORDER_20251015223605', N'Bán hàng', N'1', N'2025-10-15 22:36:05.050')
GO

SET IDENTITY_INSERT [dbo].[InventoryTransactions] OFF
GO


-- ----------------------------
-- Table structure for Cart
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Cart]') AND type IN ('U'))
	DROP TABLE [dbo].[Cart]
GO

CREATE TABLE [dbo].[Cart] (
  [CartID] int  IDENTITY(1,1) NOT NULL,
  [UserID] int  NOT NULL,
  [ProductID] int  NOT NULL,
  [Quantity] int DEFAULT 1 NOT NULL,
  [AddedDate] datetime DEFAULT getdate() NULL
)
GO

ALTER TABLE [dbo].[Cart] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Cart
-- ----------------------------
SET IDENTITY_INSERT [dbo].[Cart] ON
GO

INSERT INTO [dbo].[Cart] ([CartID], [UserID], [ProductID], [Quantity], [AddedDate]) VALUES (N'21', N'2', N'60', N'2', N'2024-01-21 14:30:00.000')
GO

INSERT INTO [dbo].[Cart] ([CartID], [UserID], [ProductID], [Quantity], [AddedDate]) VALUES (N'22', N'2', N'64', N'5', N'2024-01-21 14:35:00.000')
GO

INSERT INTO [dbo].[Cart] ([CartID], [UserID], [ProductID], [Quantity], [AddedDate]) VALUES (N'29', N'1', N'62', N'1', N'2025-10-15 22:39:59.817')
GO

SET IDENTITY_INSERT [dbo].[Cart] OFF
GO


-- ----------------------------
-- Table structure for Orders
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type IN ('U'))
	DROP TABLE [dbo].[Orders]
GO

CREATE TABLE [dbo].[Orders] (
  [OrderID] int  IDENTITY(1,1) NOT NULL,
  [OrderNumber] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [UserID] int  NOT NULL,
  [OrderDate] datetime DEFAULT getdate() NULL,
  [StatusID] int  NOT NULL,
  [PaymentMethodID] int  NOT NULL,
  [SubTotal] decimal(15,2)  NOT NULL,
  [ShippingFee] decimal(15,2) DEFAULT 0 NULL,
  [DiscountAmount] decimal(15,2) DEFAULT 0 NULL,
  [TotalAmount] decimal(15,2)  NOT NULL,
  [PromotionID] int  NULL,
  [ShippingAddress] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [Notes] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [AdminNotes] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [CreatedDate] datetime DEFAULT getdate() NULL,
  [UpdatedDate] datetime DEFAULT getdate() NULL
)
GO

ALTER TABLE [dbo].[Orders] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Orders
-- ----------------------------
SET IDENTITY_INSERT [dbo].[Orders] ON
GO

INSERT INTO [dbo].[Orders] ([OrderID], [OrderNumber], [UserID], [OrderDate], [StatusID], [PaymentMethodID], [SubTotal], [ShippingFee], [DiscountAmount], [TotalAmount], [PromotionID], [ShippingAddress], [Notes], [AdminNotes], [CreatedDate], [UpdatedDate]) VALUES (N'1', N'ORD-2024-001', N'1', N'2024-01-15 10:30:00.000', N'4', N'1', N'600000.00', N'30000.00', N'0.00', N'630000.00', NULL, N'123 Ðu?ng ABC, Phu?ng 1, Qu?n 1, TP. H? Chí Minh', N'Giao hàng vào bu?i chi?u', NULL, N'2024-01-15 10:30:00.000', N'2025-10-15 21:30:37.427')
GO

INSERT INTO [dbo].[Orders] ([OrderID], [OrderNumber], [UserID], [OrderDate], [StatusID], [PaymentMethodID], [SubTotal], [ShippingFee], [DiscountAmount], [TotalAmount], [PromotionID], [ShippingAddress], [Notes], [AdminNotes], [CreatedDate], [UpdatedDate]) VALUES (N'2', N'ORD-2024-002', N'2', N'2024-01-16 14:20:00.000', N'3', N'2', N'1200000.00', N'50000.00', N'100000.00', N'1150000.00', NULL, N'789 Ðu?ng DEF, Phu?ng 3, Qu?n 3, TP. H? Chí Minh', N'Thanh toán qua VNPay', NULL, N'2024-01-16 14:20:00.000', N'2025-10-15 21:30:37.427')
GO

INSERT INTO [dbo].[Orders] ([OrderID], [OrderNumber], [UserID], [OrderDate], [StatusID], [PaymentMethodID], [SubTotal], [ShippingFee], [DiscountAmount], [TotalAmount], [PromotionID], [ShippingAddress], [Notes], [AdminNotes], [CreatedDate], [UpdatedDate]) VALUES (N'3', N'ORD-2024-003', N'1', N'2024-01-18 09:15:00.000', N'2', N'1', N'800000.00', N'40000.00', N'0.00', N'840000.00', NULL, N'123 Ðu?ng ABC, Phu?ng 1, Qu?n 1, TP. H? Chí Minh', N'C?n giao nhanh', NULL, N'2024-01-18 09:15:00.000', N'2025-10-15 21:30:37.427')
GO

INSERT INTO [dbo].[Orders] ([OrderID], [OrderNumber], [UserID], [OrderDate], [StatusID], [PaymentMethodID], [SubTotal], [ShippingFee], [DiscountAmount], [TotalAmount], [PromotionID], [ShippingAddress], [Notes], [AdminNotes], [CreatedDate], [UpdatedDate]) VALUES (N'4', N'ORD-2024-004', N'2', N'2024-01-20 16:45:00.000', N'1', N'2', N'450000.00', N'25000.00', N'0.00', N'475000.00', NULL, N'789 Ðu?ng DEF, Phu?ng 3, Qu?n 3, TP. H? Chí Minh', N'Ðon hàng m?i', NULL, N'2024-01-20 16:45:00.000', N'2025-10-15 21:30:37.427')
GO

INSERT INTO [dbo].[Orders] ([OrderID], [OrderNumber], [UserID], [OrderDate], [StatusID], [PaymentMethodID], [SubTotal], [ShippingFee], [DiscountAmount], [TotalAmount], [PromotionID], [ShippingAddress], [Notes], [AdminNotes], [CreatedDate], [UpdatedDate]) VALUES (N'13', N'PS20251015223222', N'1', N'2025-10-15 22:32:22.287', N'1', N'1', N'400000.00', N'30000.00', N'0.00', N'430000.00', NULL, N'fdf, fdf, fdf, fdfd', NULL, NULL, N'2025-10-15 22:32:22.287', N'2025-10-15 22:32:22.287')
GO

INSERT INTO [dbo].[Orders] ([OrderID], [OrderNumber], [UserID], [OrderDate], [StatusID], [PaymentMethodID], [SubTotal], [ShippingFee], [DiscountAmount], [TotalAmount], [PromotionID], [ShippingAddress], [Notes], [AdminNotes], [CreatedDate], [UpdatedDate]) VALUES (N'14', N'PS20251015223605', N'1', N'2025-10-15 22:36:05.017', N'1', N'2', N'400000.00', N'30000.00', N'0.00', N'430000.00', NULL, N'dsds, dsds, das, dsdsds', NULL, NULL, N'2025-10-15 22:36:05.017', N'2025-10-15 22:36:05.017')
GO

SET IDENTITY_INSERT [dbo].[Orders] OFF
GO


-- ----------------------------
-- Table structure for OrderItems
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderItems]') AND type IN ('U'))
	DROP TABLE [dbo].[OrderItems]
GO

CREATE TABLE [dbo].[OrderItems] (
  [OrderItemID] int  IDENTITY(1,1) NOT NULL,
  [OrderID] int  NOT NULL,
  [ProductID] int  NOT NULL,
  [Quantity] int  NOT NULL,
  [UnitPrice] decimal(15,2)  NOT NULL,
  [TotalPrice] decimal(15,2)  NOT NULL
)
GO

ALTER TABLE [dbo].[OrderItems] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of OrderItems
-- ----------------------------
SET IDENTITY_INSERT [dbo].[OrderItems] ON
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'37', N'1', N'60', N'1', N'400000.00', N'400000.00')
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'38', N'1', N'63', N'2', N'100000.00', N'200000.00')
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'39', N'2', N'61', N'2', N'150000.00', N'300000.00')
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'40', N'2', N'64', N'10', N'20000.00', N'200000.00')
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'41', N'2', N'67', N'1', N'700000.00', N'700000.00')
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'42', N'3', N'62', N'1', N'350000.00', N'350000.00')
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'43', N'3', N'66', N'2', N'120000.00', N'240000.00')
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'44', N'3', N'68', N'1', N'60000.00', N'60000.00')
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'45', N'4', N'65', N'1', N'280000.00', N'280000.00')
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'46', N'4', N'69', N'1', N'180000.00', N'180000.00')
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'47', N'13', N'60', N'1', N'400000.00', N'400000.00')
GO

INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice]) VALUES (N'48', N'14', N'60', N'1', N'400000.00', N'400000.00')
GO

SET IDENTITY_INSERT [dbo].[OrderItems] OFF
GO


-- ----------------------------
-- Table structure for OrderStatusHistory
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderStatusHistory]') AND type IN ('U'))
	DROP TABLE [dbo].[OrderStatusHistory]
GO

CREATE TABLE [dbo].[OrderStatusHistory] (
  [HistoryID] int  IDENTITY(1,1) NOT NULL,
  [OrderID] int  NOT NULL,
  [OldStatusID] int  NULL,
  [NewStatusID] int  NOT NULL,
  [ChangedBy] int  NOT NULL,
  [ChangedDate] datetime DEFAULT getdate() NULL,
  [Notes] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[OrderStatusHistory] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of OrderStatusHistory
-- ----------------------------
SET IDENTITY_INSERT [dbo].[OrderStatusHistory] ON
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'1', N'1', NULL, N'1', N'1', N'2024-01-15 10:30:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'2', N'1', N'1', N'2', N'1', N'2024-01-15 11:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'3', N'1', N'2', N'3', N'1', N'2024-01-15 14:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'4', N'1', N'3', N'4', N'1', N'2024-01-15 16:30:00.000', N'Ðã giao hàng thành công')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'5', N'2', NULL, N'1', N'2', N'2024-01-16 14:20:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'6', N'2', N'1', N'2', N'1', N'2024-01-16 15:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'7', N'2', N'2', N'3', N'1', N'2024-01-17 09:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'8', N'3', NULL, N'1', N'1', N'2024-01-18 09:15:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'9', N'3', N'1', N'2', N'1', N'2024-01-18 10:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'10', N'4', NULL, N'1', N'2', N'2024-01-20 16:45:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'11', N'1', NULL, N'1', N'1', N'2024-01-15 10:30:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'12', N'1', N'1', N'2', N'1', N'2024-01-15 11:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'13', N'1', N'2', N'3', N'1', N'2024-01-15 14:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'14', N'1', N'3', N'4', N'1', N'2024-01-15 16:30:00.000', N'Ðã giao hàng thành công')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'15', N'2', NULL, N'1', N'2', N'2024-01-16 14:20:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'16', N'2', N'1', N'2', N'1', N'2024-01-16 15:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'17', N'2', N'2', N'3', N'1', N'2024-01-17 09:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'18', N'3', NULL, N'1', N'1', N'2024-01-18 09:15:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'19', N'3', N'1', N'2', N'1', N'2024-01-18 10:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'20', N'4', NULL, N'1', N'2', N'2024-01-20 16:45:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'21', N'1', NULL, N'1', N'1', N'2024-01-15 10:30:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'22', N'1', N'1', N'2', N'1', N'2024-01-15 11:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'23', N'1', N'2', N'3', N'1', N'2024-01-15 14:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'24', N'1', N'3', N'4', N'1', N'2024-01-15 16:30:00.000', N'Ðã giao hàng thành công')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'25', N'2', NULL, N'1', N'2', N'2024-01-16 14:20:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'26', N'2', N'1', N'2', N'1', N'2024-01-16 15:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'27', N'2', N'2', N'3', N'1', N'2024-01-17 09:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'28', N'3', NULL, N'1', N'1', N'2024-01-18 09:15:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'29', N'3', N'1', N'2', N'1', N'2024-01-18 10:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'30', N'4', NULL, N'1', N'2', N'2024-01-20 16:45:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'31', N'1', NULL, N'1', N'1', N'2024-01-15 10:30:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'32', N'1', N'1', N'2', N'1', N'2024-01-15 11:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'33', N'1', N'2', N'3', N'1', N'2024-01-15 14:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'34', N'1', N'3', N'4', N'1', N'2024-01-15 16:30:00.000', N'Ðã giao hàng thành công')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'35', N'2', NULL, N'1', N'2', N'2024-01-16 14:20:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'36', N'2', N'1', N'2', N'1', N'2024-01-16 15:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'37', N'2', N'2', N'3', N'1', N'2024-01-17 09:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'38', N'3', NULL, N'1', N'1', N'2024-01-18 09:15:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'39', N'3', N'1', N'2', N'1', N'2024-01-18 10:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'40', N'4', NULL, N'1', N'2', N'2024-01-20 16:45:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'41', N'1', NULL, N'1', N'1', N'2024-01-15 10:30:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'42', N'1', N'1', N'2', N'1', N'2024-01-15 11:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'43', N'1', N'2', N'3', N'1', N'2024-01-15 14:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'44', N'1', N'3', N'4', N'1', N'2024-01-15 16:30:00.000', N'Ðã giao hàng thành công')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'45', N'2', NULL, N'1', N'2', N'2024-01-16 14:20:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'46', N'2', N'1', N'2', N'1', N'2024-01-16 15:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'47', N'2', N'2', N'3', N'1', N'2024-01-17 09:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'48', N'3', NULL, N'1', N'1', N'2024-01-18 09:15:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'49', N'3', N'1', N'2', N'1', N'2024-01-18 10:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'50', N'4', NULL, N'1', N'2', N'2024-01-20 16:45:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'51', N'1', NULL, N'1', N'1', N'2024-01-15 10:30:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'52', N'1', N'1', N'2', N'1', N'2024-01-15 11:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'53', N'1', N'2', N'3', N'1', N'2024-01-15 14:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'54', N'1', N'3', N'4', N'1', N'2024-01-15 16:30:00.000', N'Ðã giao hàng thành công')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'55', N'2', NULL, N'1', N'2', N'2024-01-16 14:20:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'56', N'2', N'1', N'2', N'1', N'2024-01-16 15:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'57', N'2', N'2', N'3', N'1', N'2024-01-17 09:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'58', N'3', NULL, N'1', N'1', N'2024-01-18 09:15:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'59', N'3', N'1', N'2', N'1', N'2024-01-18 10:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'60', N'4', NULL, N'1', N'2', N'2024-01-20 16:45:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'61', N'1', NULL, N'1', N'1', N'2024-01-15 10:30:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'62', N'1', N'1', N'2', N'1', N'2024-01-15 11:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'63', N'1', N'2', N'3', N'1', N'2024-01-15 14:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'64', N'1', N'3', N'4', N'1', N'2024-01-15 16:30:00.000', N'Ðã giao hàng thành công')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'65', N'2', NULL, N'1', N'2', N'2024-01-16 14:20:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'66', N'2', N'1', N'2', N'1', N'2024-01-16 15:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'67', N'2', N'2', N'3', N'1', N'2024-01-17 09:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'68', N'3', NULL, N'1', N'1', N'2024-01-18 09:15:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'69', N'3', N'1', N'2', N'1', N'2024-01-18 10:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'70', N'4', NULL, N'1', N'2', N'2024-01-20 16:45:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'71', N'1', NULL, N'1', N'1', N'2024-01-15 10:30:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'72', N'1', N'1', N'2', N'1', N'2024-01-15 11:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'73', N'1', N'2', N'3', N'1', N'2024-01-15 14:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'74', N'1', N'3', N'4', N'1', N'2024-01-15 16:30:00.000', N'Ðã giao hàng thành công')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'75', N'2', NULL, N'1', N'2', N'2024-01-16 14:20:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'76', N'2', N'1', N'2', N'1', N'2024-01-16 15:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'77', N'2', N'2', N'3', N'1', N'2024-01-17 09:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'78', N'3', NULL, N'1', N'1', N'2024-01-18 09:15:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'79', N'3', N'1', N'2', N'1', N'2024-01-18 10:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'80', N'4', NULL, N'1', N'2', N'2024-01-20 16:45:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'81', N'1', NULL, N'1', N'1', N'2024-01-15 10:30:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'82', N'1', N'1', N'2', N'1', N'2024-01-15 11:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'83', N'1', N'2', N'3', N'1', N'2024-01-15 14:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'84', N'1', N'3', N'4', N'1', N'2024-01-15 16:30:00.000', N'Ðã giao hàng thành công')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'85', N'2', NULL, N'1', N'2', N'2024-01-16 14:20:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'86', N'2', N'1', N'2', N'1', N'2024-01-16 15:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'87', N'2', N'2', N'3', N'1', N'2024-01-17 09:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'88', N'3', NULL, N'1', N'1', N'2024-01-18 09:15:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'89', N'3', N'1', N'2', N'1', N'2024-01-18 10:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'90', N'4', NULL, N'1', N'2', N'2024-01-20 16:45:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'91', N'1', NULL, N'1', N'1', N'2024-01-15 10:30:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'92', N'1', N'1', N'2', N'1', N'2024-01-15 11:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'93', N'1', N'2', N'3', N'1', N'2024-01-15 14:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'94', N'1', N'3', N'4', N'1', N'2024-01-15 16:30:00.000', N'Ðã giao hàng thành công')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'95', N'2', NULL, N'1', N'2', N'2024-01-16 14:20:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'96', N'2', N'1', N'2', N'1', N'2024-01-16 15:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'97', N'2', N'2', N'3', N'1', N'2024-01-17 09:00:00.000', N'Ðang giao hàng')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'98', N'3', NULL, N'1', N'1', N'2024-01-18 09:15:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'99', N'3', N'1', N'2', N'1', N'2024-01-18 10:00:00.000', N'B?t d?u x? lý')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'100', N'4', NULL, N'1', N'2', N'2024-01-20 16:45:00.000', N'Ðon hàng du?c t?o')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'101', N'13', NULL, N'1', N'1', N'2025-10-15 22:32:22.523', N'Đơn hàng được tạo')
GO

INSERT INTO [dbo].[OrderStatusHistory] ([HistoryID], [OrderID], [OldStatusID], [NewStatusID], [ChangedBy], [ChangedDate], [Notes]) VALUES (N'102', N'14', NULL, N'1', N'1', N'2025-10-15 22:36:05.040', N'Đơn hàng được tạo')
GO

SET IDENTITY_INSERT [dbo].[OrderStatusHistory] OFF
GO
