-- =============================================
-- Use Case 3: Upsert ETL - SITUS (SSISStaging) to tblSitus (Property)
--
-- Source:      [SSISStaging].[dbo].[SITUS]
-- Destination: [Property].[dbo].[tblSitus]
--
-- Rules:
--   - Source records where IsValid = 0 are excluded.
--   - Match source to destination on SITUS_NO = SitusNo.
--   - Insert new records; update changed existing records.
--
-- SSIS Implementation Notes:
--   This script implements the upsert logic as a stored procedure in the
--   destination database and can be called from an SSIS Execute SQL Task.
--   Alternatively, the equivalent SSIS Data Flow approach uses:
--     1. OLE DB Source  (SSISStaging - query below filtered by IsValid = 1)
--     2. Lookup         (Property.dbo.tblSitus on SitusNo; retrieve SitusID)
--     3. Conditional Split (No Match -> Insert path; Match -> Update path)
--     4. OLE DB Destination (Insert path)
--     5. OLE DB Command     (Update path)
-- =============================================

USE [Property]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: Upsert ETL stored procedure.  Merges valid records from
--              SSISStaging.dbo.SITUS into Property.dbo.tblSitus.
--              Records where IsValid = 0 in the source are not moved.
-- =============================================
CREATE PROCEDURE [dbo].[prcUpsertSitusETL]
    @InsertedEmpID    int = NULL,
    @LastModifiedEmpID int = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrDateTime datetime;
    SET @CurrDateTime = GetDate();

    MERGE dbo.tblSitus AS dst
    USING (
        -- Source query: only valid records
        SELECT
            SITUS_NO,
            RTRIM(STR_NO)           AS StrNo,
            RTRIM(STR_NO_FRACTION)  AS StrNoFraction,
            RTRIM(STR_NAME)         AS StrName,
            RTRIM(STR_DIR)          AS StrDir,
            RTRIM(STR_TYPE_CODE)    AS StrTypeCode,
            RTRIM(CITY)             AS City,
            RTRIM(AD_UNIT_TYPE)     AS AdUnitType,
            RTRIM(AD_UNIT_ID)       AS AdUnitIdentifier,
            -- Build CombinedStreetAddress from components (max 50 chars)
            RTRIM(
                LTRIM(RTRIM(STR_NO))
                + CASE WHEN LTRIM(RTRIM(STR_NO_FRACTION)) <> '' THEN ' ' + LTRIM(RTRIM(STR_NO_FRACTION)) ELSE '' END
                + CASE WHEN LTRIM(RTRIM(STR_DIR))  <> '' THEN ' ' + LTRIM(RTRIM(STR_DIR))  ELSE '' END
                + CASE WHEN LTRIM(RTRIM(STR_NAME)) <> '' THEN ' ' + LTRIM(RTRIM(STR_NAME)) ELSE '' END
                + CASE WHEN LTRIM(RTRIM(STR_TYPE_CODE)) <> '' THEN ' ' + LTRIM(RTRIM(STR_TYPE_CODE)) ELSE '' END
            ) AS CombinedStreetAddress
        FROM SSISStaging.dbo.SITUS
        WHERE IsValid = 1
    ) AS src
    ON dst.SitusNo = src.SITUS_NO

    -- Update existing records when any field has changed
    WHEN MATCHED AND (
        dst.StrNo              <> src.StrNo              OR
        dst.StrNoFraction      <> src.StrNoFraction      OR
        dst.StrName            <> src.StrName            OR
        dst.StrDir             <> src.StrDir             OR
        dst.StrTypeCode        <> src.StrTypeCode        OR
        dst.City               <> src.City               OR
        dst.AdUnitType         <> src.AdUnitType         OR
        dst.AdUnitIdentifier   <> src.AdUnitIdentifier   OR
        dst.CombinedStreetAddress <> src.CombinedStreetAddress
    )
    THEN UPDATE SET
        dst.StrNo                 = src.StrNo,
        dst.StrNoFraction         = src.StrNoFraction,
        dst.StrName               = src.StrName,
        dst.StrDir                = src.StrDir,
        dst.StrTypeCode           = src.StrTypeCode,
        dst.City                  = src.City,
        dst.AdUnitType            = src.AdUnitType,
        dst.AdUnitIdentifier      = src.AdUnitIdentifier,
        dst.CombinedStreetAddress = src.CombinedStreetAddress,
        dst.LastModifiedEmpID     = @LastModifiedEmpID,
        dst.LastModifiedDate      = @CurrDateTime

    -- Insert new records
    WHEN NOT MATCHED BY TARGET THEN INSERT
        (SitusNo,
        StrNo,
        StrNoFraction,
        StrName,
        StrDir,
        StrTypeCode,
        City,
        AdUnitType,
        AdUnitIdentifier,
        CombinedStreetAddress,
        InsertedEmpID,
        InsertedDate,
        LastModifiedEmpID,
        LastModifiedDate)
    VALUES
        (src.SITUS_NO,
        src.StrNo,
        src.StrNoFraction,
        src.StrName,
        src.StrDir,
        src.StrTypeCode,
        src.City,
        src.AdUnitType,
        src.AdUnitIdentifier,
        src.CombinedStreetAddress,
        @InsertedEmpID,
        @CurrDateTime,
        @LastModifiedEmpID,
        @CurrDateTime);

END
GO
