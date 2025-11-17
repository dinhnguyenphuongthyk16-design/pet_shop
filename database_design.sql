
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
