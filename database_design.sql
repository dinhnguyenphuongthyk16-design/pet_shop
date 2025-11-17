
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



