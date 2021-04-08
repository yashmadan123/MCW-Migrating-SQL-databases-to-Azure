## Exercise 6: Enable Dynamic Data Masking

Duration: 15 minutes

In this exercise, you enable **Dynamic Data Masking** `https://docs.microsoft.com/azure/sql-database/sql-database-dynamic-data-masking-get-started` (DDM) on credit card numbers in the `WideWorldImporters` database. DDM limits sensitive data exposure by masking it to non-privileged users. This feature helps prevent unauthorized access to sensitive data by enabling customers to designate how much of the sensitive data to reveal with minimal impact on the application layer. It is a policy-based security feature that hides the sensitive data in the result set of a query over designated database fields while the data in the database is not changed.

For example, a call center's service representative may identify callers by several digits of their credit card number. However, the full credit card number should not be fully exposed to the service representative. A masking rule can be defined that obfuscates all but the last four digits of any credit card number in any query result. As another example, an appropriate data mask can be created to protect personally identifiable information (PII) data so that a developer can query production environments for troubleshooting purposes without violating compliance regulations.

### Task 1: Enable DDM on credit card numbers

When inspecting the data in the `WideWorldImporters` database using the ADS Data Discovery & Classification tool, you set the Sensitivity label for credit card numbers to Highly Confidential. In this task, you take another step to protect this information by enabling DDM on the `CardNumber` field in the `CreditCard` table. DDM prevents queries against that table from returning the full credit card number.

1. On your JumpBox VM, return to the SQL Server Management Studio (SSMS) window you opened previously.

2. Expand **Tables** under the **WideWorldImportersSUFFIX** database and locate the `Sales.CreditCard` table. Expand the table columns and observe that there is a column named `CardNumber`. Right-click the table, and choose **Select Top 1000 Rows** from the context menu.

   ![The Select Top 1000 Rows item is highlighted in the context menu for the Sales.CreditCard table.](media/ssms-sql-mi-credit-card-table-select.png "Select Top 1000 Rows")

3. In the query window that opens review the Results, including the `CardNumber` field. Notice it is displayed in plain text, making the data available to anyone with access to query the database.

   ![Plain text credit card numbers are highlighted in the query results.](media/ssms-sql-mi-credit-card-table-select-results.png "Results")

4. To be able to test the mask being applied to the `CardNumber` field, you first create a user in the database to use for testing the masked field. In SSMS, select **New Query** and paste the following SQL script into the new query window:

   ```sql
   USE [WideWorldImportersSUFFIX];
   GO

   CREATE USER DDMUser WITHOUT LOGIN;
   GRANT SELECT ON [Sales].[CreditCard] TO DDMUser;
   ```

   > The SQL script above creates a new user in the database named `DDMUser` and grants that user `SELECT` rights on the `Sales.CreditCard` table.

5. Select **Execute** from the SSMS toolbar to run the query. You will get a message that the commands completed successfully in the Messages pane.

6. With the new user created, run a quick query to observe the results. Select **New Query** again, and paste the following into the new query window.

   ```sql
   USE [WideWorldImportersSUFFIX];
   GO

   EXECUTE AS USER = 'DDMUser';
   SELECT TOP 10 * FROM [Sales].[CreditCard];
   REVERT;
   ```

7. Select **Execute** from the toolbar and examine the Results pane. Notice the credit card number, as above, is visible in plain text.

   ![The credit card number is unmasked in the query results.](media/ssms-sql-mi-ddm-results-unmasked.png "Query results")

8. You now apply DDM on the `CardNumber` field to prevent it from being viewed in query results. Select **New Query** from the SSMS toolbar,  paste the following query into the query window to apply a mask to the `CardNumber` field and then select **Execute**.

   ```sql
   USE [WideWorldImportersSUFFIX];
   GO

   ALTER TABLE [Sales].[CreditCard]
   ALTER COLUMN [CardNumber] NVARCHAR(25) MASKED WITH (FUNCTION = 'partial(0,"xxx-xxx-xxx-",4)')
   ```

9. Run the `SELECT` query you opened in step 6 above again, and observe the results. Specifically, inspect the output in the `CardNumber` field. For reference, the query is below.

   ```sql
   USE [WideWorldImportersSUFFIX];
   GO

   EXECUTE AS USER = 'DDMUser';
   SELECT TOP 10 * FROM [Sales].[CreditCard];
   REVERT;
   ```

   ![The credit card number is masked in the query results.](media/ssms-sql-mi-ddm-results-masked.png "Query results")

   > The `CardNumber` is now displayed using the mask applied to it, so only the card number's last four digits are visible. Dynamic Data Masking is a powerful feature that enables you to prevent unauthorized users from viewing sensitive or restricted information. It's a policy-based security feature that hides the sensitive data in the result set of a query over designated database fields while the data in the database is not changed.

### Task 2: Apply DDM to email addresses

From the findings of the Data Discovery & Classification report in ADS, you saw that email addresses are labeled Confidential. In this task, you use one of the built-in functions for making email addresses using DDM to help protect this information.

1. For this, you target the `LoginEmail` field in the `[dbo].[Gamer]` table. Open a new query window and execute the following script:

   ```sql
   USE [WideWorldImportersSUFFIX];
   GO

   SELECT TOP 10 * FROM [dbo].[Gamer]
   ```

   ![In the query results, full email addresses are visible.](media/ddm-select-gamer-results.png "Query results")

2. Now, as you did above, grant the `DDMUser` `SELECT` rights on the [dbo].[Gamer]. In a new query window and enter the following script, and then select **Execute**:

   ```sql
   USE [WideWorldImportersSUFFIX];
   GO

   GRANT SELECT ON [dbo].[Gamer] to DDMUser;
   ```

3. Next, apply DDM on the `LoginEmail` field to prevent it from being viewed in full in query results. Select **New Query** from the SSMS toolbar, paste the following query into the query window to apply a mask to the `LoginEmail` field, and then select **Execute**.

   ```sql
   USE [WideWorldImportersSUFFIX];
   GO

   ALTER TABLE [dbo].[Gamer]
   ALTER COLUMN [LoginEmail] NVARCHAR(250) MASKED WITH (FUNCTION = 'Email()');
   ```

   > **Note**
   >
   > Observe the use of the built-in `Email()` masking function above. This masking function is one of several pre-defined masks available in SQL Server databases.

4. Run the `SELECT` query below, and observe the results. Specifically, inspect the output in the `LoginEmail` field. For reference, the query is below.

   ```sql
   USE [WideWorldImportersSUFFIX];
   GO

   EXECUTE AS USER = 'DDMUser';
   SELECT TOP 10 * FROM [dbo].[Gamer];
   REVERT;
   ```

   ![The email addresses are masked in the query results.](media/ddm-select-gamer-results-masked.png "Query results")


## You have successfully completed the lab.
