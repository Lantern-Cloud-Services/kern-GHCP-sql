USE [EmployeeDB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: Insert a new employee into tblEmployee and create a
--              corresponding tblInOutStatus record using a transaction.
--              Returns the new EmployeeID via the @EmployeeID output parameter.
-- =============================================
CREATE PROCEDURE [dbo].[prcInsEmployee]
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
    @LastModifiedEmpID        int,
    @EmployeeID               int OUT
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
        -- validate @LoginName
        IF (@LoginName <> '')
        IF EXISTS(SELECT EmployeeID FROM tblEmployee WHERE IsActive = 1 AND LoginName = @LoginName)
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
        -- make sure DisplayName (PreferredName + LastName) will be unique
        IF EXISTS(SELECT EmployeeID FROM tblEmployee WHERE IsActive = 1 AND
                PreferredName = @PreferredName AND
                LastName = @LastName)
        BEGIN
            SET @Msg = 'Preferred Name + Last Name must be unique for active users.';
            RAISERROR (@Msg, 16, 1) WITH SETERROR;
            RETURN @@ERROR;
        END;
    END;

    -- Make sure SSN is unique or empty
    IF (@SSN IS NOT NULL) AND (@SSN <> '')
    BEGIN
        IF EXISTS(SELECT EmployeeID FROM tblEmployee WHERE SSN = @SSN)
        BEGIN
            SET @Msg = 'SSN must be unique.';
            RAISERROR (@Msg, 16, 1) WITH SETERROR;
            RETURN @@ERROR;
        END;
    END;

    BEGIN TRANSACTION TransAct1;

        INSERT INTO tblEmployee
                   (JobTitleID,
                   InOutGroupID,
                   CountyDepartmentTypeID,
                   SupervisorEmployeeID,
                   AsrEmployeeNumber,
                   FirstName,
                   PreferredName,
                   MiddleName,
                   LastName,
                   LoginName,
                   Email,
                   WorkPhone,
                   CellPhone,
                   OtherPhone,
                   SSN,
                   IsExternalEmployee,
                   IsActive,
                   InsertedEmpID,
                   InsertedDate,
                   LastModifiedEmpID,
                   LastModifiedDate)
             VALUES
                   (@JobTitleID,
                   @InOutGroupID,
                   @CountyDepartmentTypeID,
                   @SupervisorEmployeeID,
                   @AsrEmployeeNumber,
                   @FirstName,
                   @PreferredName,
                   @MiddleName,
                   @LastName,
                   @LoginName,
                   @Email,
                   @WorkPhone,
                   @CellPhone,
                   @OtherPhone,
                   @SSN,
                   @IsExternalEmployee,
                   @IsActive,
                   @LastModifiedEmpID,
                   @CurrDateTime,
                   @LastModifiedEmpID,
                   @CurrDateTime);

        -- capture error number and get new record key
        SELECT @Error = @@ERROR, @EmployeeID = SCOPE_IDENTITY();

        IF @Error = 0
        BEGIN
            INSERT INTO tblInOutStatus
                       (EmployeeID,
                       IsCheckedIn,
                       WorkHours,
                       Comments,
                       InsertedEmpID,
                       InsertedDate,
                       LastModifiedEmpID,
                       LastModifiedDate)
                 VALUES
                       (@EmployeeID,
                       0,
                       '',
                       '',
                       @LastModifiedEmpID,
                       @CurrDateTime,
                       @LastModifiedEmpID,
                       @CurrDateTime);
            SET @Error = @@ERROR;
        END;

    IF @Error = 0
        COMMIT TRANSACTION TransAct1;
    ELSE
        ROLLBACK TRANSACTION TransAct1;

    RETURN @Error;
END
GO
