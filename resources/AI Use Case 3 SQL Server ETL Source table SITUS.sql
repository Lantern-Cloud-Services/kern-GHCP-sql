USE [SSISStaging]
GO

/****** Object:  Table [dbo].[SITUS]    Script Date: 5/26/2026 4:18:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SITUS](
	[SITUS_NO] [numeric](7, 0) NOT NULL,
	[STR_NO] [char](6) NOT NULL,
	[STR_NO_FRACTION] [char](1) NOT NULL,
	[STR_NAME] [char](20) NOT NULL,
	[STR_DIR] [char](2) NOT NULL,
	[STR_TYPE_CODE] [char](2) NOT NULL,
	[CITY] [char](15) NOT NULL,
	[AD_UNIT_TYPE] [char](3) NOT NULL,
	[AD_UNIT_ID] [char](4) NOT NULL,
	[IsValid] [bit] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SITUS] ADD  CONSTRAINT [DF_SITUS_IsValid]  DEFAULT ((1)) FOR [IsValid]
GO


