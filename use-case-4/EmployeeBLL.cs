using System;
using System.Data;
using System.Data.Common;
using Microsoft.Practices.EnterpriseLibrary.Data;

namespace EmployeeApp.BusinessLogic
{
    /// <summary>
    /// Business Logic Layer for Employee operations.
    /// Uses the Microsoft Enterprise Library Data Access Application Block (DAAB)
    /// to interact with the EmployeeDB database.
    /// </summary>
    public class EmployeeBLL
    {
        // The connection string name must match an entry in App.config / Web.config
        // under <connectionStrings>.
        private const string DatabaseName = "EmployeeDB";

        /// <summary>
        /// Inserts a new employee record into the database by calling the
        /// prcInsEmployee stored procedure.  A corresponding tblInOutStatus row
        /// is also created inside the stored procedure transaction.
        /// </summary>
        /// <param name="jobTitleID">Foreign key to tblJobTitle.</param>
        /// <param name="inOutGroupID">Foreign key to tblInOutGroup.</param>
        /// <param name="countyDepartmentTypeID">Foreign key to tblCountyDepartmentType.</param>
        /// <param name="supervisorEmployeeID">EmployeeID of the supervisor (self-referencing FK).</param>
        /// <param name="asrEmployeeNumber">3-character ASR employee number.</param>
        /// <param name="firstName">Employee first name (required when active).</param>
        /// <param name="preferredName">Employee preferred name (required when active).</param>
        /// <param name="middleName">Employee middle name.</param>
        /// <param name="lastName">Employee last name (required when active).</param>
        /// <param name="loginName">Network login name (must be unique among active employees).</param>
        /// <param name="email">Employee e-mail address.</param>
        /// <param name="workPhone">10-digit work phone number.</param>
        /// <param name="cellPhone">10-digit cell phone number.</param>
        /// <param name="otherPhone">10-digit other phone number.</param>
        /// <param name="ssn">9-digit Social Security Number (must be unique when supplied).</param>
        /// <param name="isExternalEmployee">True if the employee is external (contractor, etc.).</param>
        /// <param name="isActive">True if the employee is currently active.</param>
        /// <param name="lastModifiedEmpID">EmployeeID of the user performing the insert.</param>
        /// <returns>The newly assigned EmployeeID.</returns>
        /// <exception cref="ApplicationException">
        /// Thrown when the stored procedure returns a non-zero error code or raises
        /// a SQL Server error (e.g. duplicate login, duplicate name, duplicate SSN).
        /// </exception>
        public int InsertEmployee(
            int?   jobTitleID,
            int?   inOutGroupID,
            int?   countyDepartmentTypeID,
            int?   supervisorEmployeeID,
            string asrEmployeeNumber,
            string firstName,
            string preferredName,
            string middleName,
            string lastName,
            string loginName,
            string email,
            string workPhone,
            string cellPhone,
            string otherPhone,
            string ssn,
            bool   isExternalEmployee,
            bool   isActive,
            int?   lastModifiedEmpID)
        {
            Database db = DatabaseFactory.CreateDatabase(DatabaseName);

            using (DbCommand cmd = db.GetStoredProcCommand("prcInsEmployee"))
            {
                // Input parameters
                db.AddInParameter(cmd, "@JobTitleID",             DbType.Int32,   jobTitleID);
                db.AddInParameter(cmd, "@InOutGroupID",           DbType.Int32,   inOutGroupID);
                db.AddInParameter(cmd, "@CountyDepartmentTypeID", DbType.Int32,   countyDepartmentTypeID);
                db.AddInParameter(cmd, "@SupervisorEmployeeID",   DbType.Int32,   supervisorEmployeeID);
                db.AddInParameter(cmd, "@AsrEmployeeNumber",      DbType.String,  asrEmployeeNumber  ?? string.Empty);
                db.AddInParameter(cmd, "@FirstName",              DbType.String,  firstName          ?? string.Empty);
                db.AddInParameter(cmd, "@PreferredName",          DbType.String,  preferredName      ?? string.Empty);
                db.AddInParameter(cmd, "@MiddleName",             DbType.String,  middleName         ?? string.Empty);
                db.AddInParameter(cmd, "@LastName",               DbType.String,  lastName           ?? string.Empty);
                db.AddInParameter(cmd, "@LoginName",              DbType.String,  loginName          ?? string.Empty);
                db.AddInParameter(cmd, "@Email",                  DbType.String,  email              ?? string.Empty);
                db.AddInParameter(cmd, "@WorkPhone",              DbType.String,  workPhone          ?? string.Empty);
                db.AddInParameter(cmd, "@CellPhone",              DbType.String,  cellPhone          ?? string.Empty);
                db.AddInParameter(cmd, "@OtherPhone",             DbType.String,  otherPhone         ?? string.Empty);
                db.AddInParameter(cmd, "@SSN",                    DbType.String,  ssn                ?? string.Empty);
                db.AddInParameter(cmd, "@IsExternalEmployee",     DbType.Boolean, isExternalEmployee);
                db.AddInParameter(cmd, "@IsActive",               DbType.Boolean, isActive);
                db.AddInParameter(cmd, "@LastModifiedEmpID",      DbType.Int32,   lastModifiedEmpID);

                // Output parameter - receives the new EmployeeID
                db.AddOutParameter(cmd, "@EmployeeID", DbType.Int32, sizeof(int));

                db.ExecuteNonQuery(cmd);

                object employeeIDValue = db.GetParameterValue(cmd, "@EmployeeID");

                if (employeeIDValue == null || employeeIDValue == DBNull.Value)
                    throw new ApplicationException("InsertEmployee: stored procedure did not return a new EmployeeID.");

                return Convert.ToInt32(employeeIDValue);
            }
        }
    }
}
