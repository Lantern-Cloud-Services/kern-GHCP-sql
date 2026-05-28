# kern-GHCP-sql Use Cases

#1: AI Use Case 1 SQL Server create table tblEmployee.sql
Have the AI process the SQL Server created table statement and produce stored procedures to Select, Insert and Update.

#2: AI Use Case 2 SQL Server create table tblEmployee and tblInOutStatus.sql
Have the AI process the 2 SQL Server created table statements and produce stored procedures to Select, Insert and Update in both tables using a transaction for the insert and update.

#3: 
AI Use Case 3 SQL Server ETL Source table SITUS.sql
AI Use Case 3 SQL Server ETL Destination table tblSitus.sql
Have the AI create an Upsert ETL in SSIS with the “situs” source and destination tables. Source records where IsValid=0 should not be moved.

#4:
AI Use Case 4 C-Sharp Business Logic Layer prcInsEmployee.sql
Have the AI create an industry standard  C# Business Logic Layer function that calls this SQL stored procedure. It should use Microsoft Enterprise Library as the Data Access Layer.
