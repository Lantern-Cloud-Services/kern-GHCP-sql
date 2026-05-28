USE [Property]
GO

/****** Object:  Table [dbo].[tblSitus]    Script Date: 5/26/2026 5:03:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblSitus](
	[SitusID] [int] IDENTITY(1,1) NOT NULL,
	[SitusNo] [numeric](7, 0) NOT NULL,
	[StrNo] [varchar](6) NOT NULL,
	[StrNoFraction] [varchar](1) NOT NULL,
	[StrName] [varchar](20) NOT NULL,
	[StrDir] [varchar](2) NOT NULL,
	[StrTypeCode] [varchar](2) NOT NULL,
	[City] [varchar](15) NOT NULL,
	[AdUnitType] [varchar](3) NOT NULL,
	[AdUnitIdentifier] [varchar](4) NOT NULL,
	[CombinedStreetAddress] [varchar](50) NOT NULL,
	[InsertedEmpID] [int] NULL,
	[InsertedDate] [datetime] NOT NULL,
	[LastModifiedEmpID] [int] NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[RowVer] [timestamp] NOT NULL,
 CONSTRAINT [PK_tblSitus] PRIMARY KEY CLUSTERED 
(
	[SitusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblSitus] ADD  CONSTRAINT [DF_tblSitus_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE [dbo].[tblSitus] ADD  CONSTRAINT [DF_tblSitus_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO


