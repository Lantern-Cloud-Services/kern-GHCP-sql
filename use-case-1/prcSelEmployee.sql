USE [EmployeeDB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: Select employee(s) from tblEmployee.
--              Pass NULL for @EmployeeID to return all employees.
-- =============================================
CREATE PROCEDURE [dbo].[prcSelEmployee]
    @EmployeeID int = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        EmployeeID,
        JobTitleID,
        InOutGroupID,
        CountyDepartmentTypeID,
        SupervisorEmployeeID,
        AsrEmployeeNumber,
        FirstName,
        PreferredName,
        MiddleName,
        LastName,
        DisplayName,
        LoginName,
        Email,
        WorkPhone,
        CellPhone,
        OtherPhone,
        SSN,
        IsExternalEmployee,
        IsActive,
        SignatureFileName,
        SignatureFileNameAndPath,
        SignatureFileExtension,
        InsertedEmpID,
        InsertedDate,
        LastModifiedEmpID,
        LastModifiedDate,
        RowVer
    FROM dbo.tblEmployee
    WHERE (@EmployeeID IS NULL OR EmployeeID = @EmployeeID);
END
GO
