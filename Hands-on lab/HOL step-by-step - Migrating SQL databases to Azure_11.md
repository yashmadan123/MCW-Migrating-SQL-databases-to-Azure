
Duration: 15 minutes

In this exercise, you examine how you can use the automatically created online secondary for reporting without feeling the impacts of a heavy transactional load on the primary database. Each database in the SQL MI Business Critical tier is automatically provisioned with several AlwaysON replicas to support the availability SLA. Using **Read Scale-Out** `https://docs.microsoft.com/azure/sql-database/sql-database-read-scale-out` allows you to load balance Azure SQL Database read-only workloads utilizing the capacity of one read-only replica.

### Task 1: View Leaderboard report in the WideWorldImporters web application

In this task, you open a web report using the web application you deployed to your App Service.

1. In the Azure portal `https://portal.azure.com`, select **Resource groups** from the Azure services list.

   ![Resource groups is highlighted in the Azure services list.](media/azure-services-resource-groups.png "Azure services")

2. Select the SQLMI-Shared-RG resource group from the list.

   ![Resource groups is selected in the Azure navigation pane, and the "hands-on-lab-SUFFIX" resource group is highlighted.](./media/resource-groups.png "Resource groups list")

3. In the hands-on-lab-SUFFIX resource group, select the **wwi-web-UNIQUEID** App Service from the list of resources.

   ![The App Service resource is selected from the list of resources in the hands-on-lab-SUFFIX resource group.](media/rg-app-service.png "hands-on-lab-SUFFIX resource group")

4. On the App Service overview blade, select the **URL** to open the web application in a browser window.

   ![The App service URL is highlighted.](media/app-service-url.png "App service URL")

5. In the WideWorldImporters web app, select **Leaderboard** from the menu.

   ![READ_WRITE is highlighted on the Leaderboard page.](media/gamer-leaderboard-read-write.png "Gamer Leaderboard within the Web App")

   > Note the `READ_WRITE` string on the page. This message is the output from reading the `Updateability` property associated with the `ApplicationIntent` option on the target database. This can be retrieved using the SQL query `SELECT DATABASEPROPERTYEX(DB_NAME(), "Updateability")`.

### Task 2: Update read-only connection string

In this task, you enable Read Scale-Out for the `WideWorldImporters`database, using the `ApplicationIntent` option in the connection string. This option dictates whether the connection is routed to the write replica or a read-only replica. Specifically, if the `ApplicationIntent` value is `ReadWrite` (the default value), the connection is directed to the database's read-write replica. If the `ApplicationIntent` value is `ReadOnly`, the connection is routed to a read-only replica.

1. Return to the App Service blade in the Azure portal and select **Configuration** under Settings on the left-hand side.

   ![The Configuration item is selected under Settings.](media/app-service-configuration-menu.png "Configuration")

2. On the Configuration blade, scroll down and locate the connection string named `WwiReadOnlyContext` within the **Connection strings** section, and select the Pencil (edit) icon on the right.

   ![The edit icon next to the read-only connection string is highlighted.](media/app-service-configuration-connection-strings-read-only.png "Connection strings")

3. In the Add/Edit connection string dialog, select the **Value** for the `WwiReadOnlyContext` and paste the following parameter to the end of the connection string.

   ```sql
   ApplicationIntent=ReadOnly;
   ```

4. The `WwiReadOnlyContext` connection string should now look something like the following:

   ```sql
   Server=tcp:sqlmi-kmtwpw3nia6n2.15b8611394c5.database.windows.net,1433;Database=WideWorldImporters;User ID=sqlmiuser;Password=Password.1234567890;Trusted_Connection=False;Encrypt=True;TrustServerCertificate=True;ApplicationIntent=ReadOnly;
   ```

5. Select **OK**.

6. Select **Save** at the top of the Configuration blade, and select **Continue** when prompted about restarting the application.

   ![The save button on the Application settings blade is highlighted.](media/app-service-configuration-save.png "Save")

### Task 3: Reload Leaderboard report in the web app

In this task, you refresh the Leaderboard report in the WideWorldImporters web app and observe the result.

1. Return to the gamer information website you opened previously, and refresh the **Leaderboard** page. The page should now look similar to the following:

   ![READ_ONLY is highlighted on the Reports page.](media/gamer-leaderboard-read-only.png "Gamer Leaderboard Web App")

   > Notice the `updateability` option is now displaying as `READ_ONLY`. With a simple addition to your database connection string, queries can be sent to an online secondary of your SQL MI Business-critical database. This setting allows for load-balancing read-only workloads using the capacity of one read-only replica. The SQL MI Business Critical cluster has a built-in Read Scale-Out capability that provides a free-of-charge built-in read-only node that can be used to run read-only queries that should not affect the performance of your primary workload.

