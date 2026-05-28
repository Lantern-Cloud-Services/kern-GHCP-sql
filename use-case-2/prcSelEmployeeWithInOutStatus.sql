USE [EmployeeDB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: Select employee(s) joined with their InOutStatus.
--              Pass NULL for @EmployeeID to return all employees.
-- =============================================
CREATE PROCEDURE [dbo].[prcSelEmployeeWithInOutStatus]
    @EmployeeID int = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        e.EmployeeID,
        e.JobTitleID,
        e.InOutGroupID,
        e.CountyDepartmentTypeID,
        e.SupervisorEmployeeID,
        e.AsrEmployeeNumber,
        e.FirstName,
        e.PreferredName,
        e.MiddleName,
        e.LastName,
        e.DisplayName,
        e.LoginName,
        e.Email,
        e.WorkPhone,
        e.CellPhone,
        e.OtherPhone,
        e.SSN,
        e.IsExternalEmployee,
        e.IsActive,
        e.SignatureFileName,
        e.SignatureFileNameAndPath,
        e.SignatureFileExtension,
        e.InsertedEmpID,
        e.InsertedDate,
        e.LastModifiedEmpID,
        e.LastModifiedDate,
        e.RowVer,
        s.IsCheckedIn,
        s.WorkHours,
        s.Comments
    FROM dbo.tblEmployee e
    LEFT JOIN dbo.tblInOutStatus s ON e.EmployeeID = s.EmployeeID
    WHERE (@EmployeeID IS NULL OR e.EmployeeID = @EmployeeID);
END
GO
