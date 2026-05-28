USE [EmployeeDB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: Update an existing employee in tblEmployee.
-- =============================================
CREATE PROCEDURE [dbo].[prcUpdEmployee]
    @EmployeeID               int,
    @JobTitleID               int,
    @InOutGroupID             int,
    @CountyDepartmentTypeID   int,
    @SupervisorEmployeeID     int,
    @AsrEmployeeNumber        varchar(3),
    @FirstName                varchar(50),
    @PreferredName            varchar(50),
    @MiddleName               varchar(50),
    @LastName                 varchar(50),
    @LoginName                varchar(100),
    @Email                    varchar(100),
    @WorkPhone                varchar(10),
    @CellPhone                varchar(10),
    @OtherPhone               varchar(10),
    @SSN                      varchar(9),
    @IsExternalEmployee       bit,
    @IsActive                 bit,
    @SignatureFileName        varchar(500),
    @SignatureFileNameAndPath varchar(1000),
    @SignatureFileExtension   varchar(50),
    @LastModifiedEmpID        int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Error        int;
    DECLARE @Msg          varchar(max);
    DECLARE @CurrDateTime datetime;

    SET @CurrDateTime = GetDate();

    IF @LoginName IS NULL
        SET @LoginName = '';

    IF (@IsActive = 1)
    BEGIN
        -- validate @LoginName uniqueness (excluding current employee)
        IF (@LoginName <> '')
        IF EXISTS(SELECT EmployeeID FROM tblEmployee WHERE IsActive = 1 AND LoginName = @LoginName AND EmployeeID <> @EmployeeID)
        BEGIN
            SET @Msg = 'Login Name must be unique for active users.';
            RAISERROR (@Msg, 16, 1) WITH SETERROR;
            RETURN @@ERROR;
        END;
        -- validate name fields
        IF (@FirstName IS NULL) OR (@FirstName = '')
        BEGIN
            SET @Msg = 'First Name is required.';
            RAISERROR (@Msg, 16, 1) WITH SETERROR;
            RETURN @@ERROR;
        END;
        IF (@PreferredName IS NULL) OR (@PreferredName = '')
        BEGIN
            SET @Msg = 'Preferred Name is required.';
            RAISERROR (@Msg, 16, 1) WITH SETERROR;
            RETURN @@ERROR;
        END;
        IF (@LastName IS NULL) OR (@LastName = '')
        BEGIN
            SET @Msg = 'Last Name is required.';
            RAISERROR (@Msg, 16, 1) WITH SETERROR;
            RETURN @@ERROR;
        END;
        -- make sure DisplayName (PreferredName + LastName) will be unique (excluding current employee)
        IF EXISTS(SELECT EmployeeID FROM tblEmployee WHERE IsActive = 1 AND
                PreferredName = @PreferredName AND
                LastName = @LastName AND
                EmployeeID <> @EmployeeID)
        BEGIN
            SET @Msg = 'Preferred Name + Last Name must be unique for active users.';
            RAISERROR (@Msg, 16, 1) WITH SETERROR;
            RETURN @@ERROR;
        END;
    END;

    -- Make sure SSN is unique or empty (excluding current employee)
    IF (@SSN IS NOT NULL) AND (@SSN <> '')
    BEGIN
        IF EXISTS(SELECT EmployeeID FROM tblEmployee WHERE SSN = @SSN AND EmployeeID <> @EmployeeID)
        BEGIN
            SET @Msg = 'SSN must be unique.';
            RAISERROR (@Msg, 16, 1) WITH SETERROR;
            RETURN @@ERROR;
        END;
    END;

    UPDATE dbo.tblEmployee
    SET
        JobTitleID               = @JobTitleID,
        InOutGroupID             = @InOutGroupID,
        CountyDepartmentTypeID   = @CountyDepartmentTypeID,
        SupervisorEmployeeID     = @SupervisorEmployeeID,
        AsrEmployeeNumber        = @AsrEmployeeNumber,
        FirstName                = @FirstName,
        PreferredName            = @PreferredName,
        MiddleName               = @MiddleName,
        LastName                 = @LastName,
        LoginName                = @LoginName,
        Email                    = @Email,
        WorkPhone                = @WorkPhone,
        CellPhone                = @CellPhone,
        OtherPhone               = @OtherPhone,
        SSN                      = @SSN,
        IsExternalEmployee       = @IsExternalEmployee,
        IsActive                 = @IsActive,
        SignatureFileName        = @SignatureFileName,
        SignatureFileNameAndPath = @SignatureFileNameAndPath,
        SignatureFileExtension   = @SignatureFileExtension,
        LastModifiedEmpID        = @LastModifiedEmpID,
        LastModifiedDate         = @CurrDateTime
    WHERE EmployeeID = @EmployeeID;

    SET @Error = @@ERROR;
    RETURN @Error;
END
GO
