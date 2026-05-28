USE [EmployeeDB]
GO

/****** Object:  Table [dbo].[tblEmployee]    Script Date: 5/26/2026 1:56:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblEmployee](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[JobTitleID] [int] NULL,
	[InOutGroupID] [int] NULL,
	[CountyDepartmentTypeID] [int] NULL,
	[SupervisorEmployeeID] [int] NULL,
	[AsrEmployeeNumber] [varchar](3) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[PreferredName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[DisplayName]  AS (([PreferredName]+' ')+[LastName]) PERSISTED NOT NULL,
	[LoginName] [varchar](100) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[WorkPhone] [varchar](10) NOT NULL,
	[CellPhone] [varchar](10) NOT NULL,
	[OtherPhone] [varchar](10) NOT NULL,
	[SSN] [varchar](9) NOT NULL,
	[IsExternalEmployee] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[SignatureFileName] [varchar](500) NULL,
	[SignatureFileNameAndPath] [varchar](1000) NULL,
	[SignatureFileExtension] [varchar](50) NULL,
	[SignatureImage] [varbinary](max) NULL,
	[InsertedEmpID] [int] NULL,
	[InsertedDate] [datetime] NOT NULL,
	[LastModifiedEmpID] [int] NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[RowVer] [timestamp] NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblEmployee] ADD  CONSTRAINT [DF_tblEmployee_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE [dbo].[tblEmployee] ADD  CONSTRAINT [DF_tblEmployee_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

ALTER TABLE [dbo].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployee_tblCountyDepartmentType] FOREIGN KEY([CountyDepartmentTypeID])
REFERENCES [dbo].[tblCountyDepartmentType] ([CountyDepartmentTypeID])
GO

ALTER TABLE [dbo].[tblEmployee] CHECK CONSTRAINT [FK_tblEmployee_tblCountyDepartmentType]
GO

ALTER TABLE [dbo].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployee_tblEmployee] FOREIGN KEY([SupervisorEmployeeID])
REFERENCES [dbo].[tblEmployee] ([EmployeeID])
GO

ALTER TABLE [dbo].[tblEmployee] CHECK CONSTRAINT [FK_tblEmployee_tblEmployee]
GO

ALTER TABLE [dbo].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployee_tblInOutGroup] FOREIGN KEY([InOutGroupID])
REFERENCES [dbo].[tblInOutGroup] ([InOutGroupID])
GO

ALTER TABLE [dbo].[tblEmployee] CHECK CONSTRAINT [FK_tblEmployee_tblInOutGroup]
GO

ALTER TABLE [dbo].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployee_tblJobTitle] FOREIGN KEY([JobTitleID])
REFERENCES [dbo].[tblJobTitle] ([JobTitleID])
GO

ALTER TABLE [dbo].[tblEmployee] CHECK CONSTRAINT [FK_tblEmployee_tblJobTitle]
GO

ALTER TABLE [dbo].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [CK_tblEmployee_AsrEmployeeNumber] CHECK  ((len([AsrEmployeeNumber])=(3) OR [AsrEmployeeNumber]=''))
GO

ALTER TABLE [dbo].[tblEmployee] CHECK CONSTRAINT [CK_tblEmployee_AsrEmployeeNumber]
GO

ALTER TABLE [dbo].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [CK_tblEmployee_SSN] CHECK  ((len([SSN])=(9) OR [SSN]=''))
GO

ALTER TABLE [dbo].[tblEmployee] CHECK CONSTRAINT [CK_tblEmployee_SSN]
GO

ALTER TABLE [dbo].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [CK_tblEmployee_Supervisor] CHECK  (([SupervisorEmployeeID]<>[EmployeeID]))
GO

ALTER TABLE [dbo].[tblEmployee] CHECK CONSTRAINT [CK_tblEmployee_Supervisor]
GO


