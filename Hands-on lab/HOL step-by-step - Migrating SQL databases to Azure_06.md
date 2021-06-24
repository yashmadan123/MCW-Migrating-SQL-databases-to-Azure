## Exercise 2: Migrate the database to SQL MI

Duration: 60 minutes

In this exercise, you use the **Azure Database Migration Service** here `https://azure.microsoft.com/services/database-migration/` (DMS) to migrate the `WideWorldImporters` database from an on-premises SQL Server 2008 R2 database into Azure SQL Managed Instance (SQL MI). WWI mentioned the importance of their gamer information web application in driving revenue, so for this migration, the online migration option is used to minimize downtime. Targeting the **Business Critical service tier** here `https://docs.microsoft.com/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview#managed-instance-service-tiers` allows WWI to meet its customer's high-availability requirements.

> The Business Critical service tier is designed for business applications with the highest performance and high-availability (HA) requirements. To learn more, read the Managed Instance service tiers documentation.

### Task 1: Create an SMB network share on the Sql2008-SUFFIX VM

In this task, you create a new SMB network share on the Sql2008-SUFFIX VM. DMS uses this shared folder for retrieving backups of the `WideWorldImporters` database during the database migration process.

1. On the Sql2008-SUFFIX VM, open **Windows Explorer** by selecting its icon on the Windows Taskbar.

   ![The Windows Explorer icon is highlighted in the Windows Taskbar.](media/windows-task-bar.png "Windows Taskbar")

2. In the Windows Explorer window, expand **Computer** in the tree view, select **Windows (C:)**, and then select **New folder** in the top menu.

   ![In Windows Explorer, Windows (C:) is selected under Computer in the left-hand tree view, and New folder is highlighted in the top menu.](media/windows-explorer-new-folder.png "Windows Explorer")

3. Name the new folder **dms-backups**, then right-click the folder and select **Share with** and **Specific people** in the context menu.

   ![In Windows Explorer, the context menu for the dms-backups folder is displayed, with Share with and Specific people highlighted.](media/windows-explorer-folder-share-with.png "Windows Explorer")

4. In the File Sharing dialog, ensure the **sqlmiuser** is listed with a **Read/Write** permission level, and then select **Share**.

   ![In the File Sharing dialog, the sqlmiuser is highlighted and assigned a permission level of Read/Write.](media/file-sharing.png "File Sharing")

5. In the **Network discovery and file sharing** dialog, select the default value of **No, make the network that I am connected to a private network**.

   ![In the Network discovery and file sharing dialog, No, make the network that I am connected to a private network is highlighted.](media/network-discovery-and-file-sharing.png "Network discovery and file sharing")

6. Back on the File Sharing dialog, note the shared folder's path, `\\SQL2008-SUFFIX\dms-backups`, and select **Done** to complete the sharing process.

   ![The Done button is highlighted on the File Sharing dialog.](media/file-sharing-done.png "File Sharing")

### Task 2: Change MSSQLSERVER service to run under sqlmiuser account

In this task, you use the SQL Server Configuration Manager to update the service account used by the SQL Server (MSSQLSERVER) service to the `sqlmiuser` account. Changing the account used for this service ensures it has the appropriate permissions to write backups to the shared folder.

1. On your Sql2008-SUFFIX VM, select the **Start menu**, enter "sql configuration" into the search bar, and then select **SQL Server Configuration Managed** from the search results.

   ![In the Windows Start menu, "sql configuration" is entered into the search box, and SQL Server Configuration Manager is highlighted in the search results.](media/windows-start-sql-configuration-manager.png "Windows search")

   > **Note**
   >
   > Be sure to choose **SQL Server Configuration Manager**, and not **SQL Server 2017 Configuration Manager**, which does not work for the installed SQL Server 2008 R2 database.

2. In the SQL Server Configuration Managed dialog, select **SQL Server Services** from the tree view on the left, then right-click **SQL Server (MSSQLSERVER)** in the list of services and select **Properties** from the context menu.

   ![SQL Server Services is selected and highlighted in the tree view of the SQL Server Configuration Manager. In the Services pane, SQL Server (MSSQLSERVER) is selected and highlighted. Properties is highlighted in the context menu.](media/sql-server-configuration-manager-services.png "SQL Server Configuration Manager")

3. In the SQL Server (MSSQLSERVER) Properties dialog, select **This account** under Log on as, and enter the following:

   - **Account name**: `sqlmiuser`
   - **Password**: `Password.1234567890`

   ![In the SQL Server (MSSQLSERVER) Properties dialog, This account is selected under Log on as, and the sqlmiuser account name and password are entered.](media/sql-server-service-properties.png "SQL Server (MSSQLSERVER) Properties")

4. Select **OK**.

5. Select **Yes** in the Confirm Account Change dialog.

   ![The Yes button is highlighted in the Confirm Account Change dialog.](media/confirm-account-change.png "Confirm Account Change")

6. Observe that the **Log On As** value for the SQL Server (MSSQLSERVER) service changed to `./sqlmiuser`.

   ![In the list of SQL Server Services, the SQL Server (MSSQLSERVER) service is highlighted.](media/sql-server-service.png "SQL Server Services")

7. Close the SQL Server Configuration Manager.

### Task 3: Create a backup of the WideWorldImporters database

To perform online data migrations, DMS looks for database and transaction log backups in the shared SMB backup folder on the source database server. In this task, you create a backup of the `WideWorldImporters` database using SSMS and write it to the `\\SQL2008-SUFFIX\dms-backups` SMB network share you made in a previous task. The backup file needs to include a checksum, so you add that during the backup steps.

1. On the Sql2008-SUFFIX VM, open **Microsoft SQL Server Management Studio 17** by entering "sql server" into the search bar in the Windows Start menu.

   ![SQL Server is entered into the Windows Start menu search box, and Microsoft SQL Server Management Studio 17 is highlighted in the search results.](media/start-menu-ssms-17.png "Windows start menu search")

2. In the SSMS **Connect to Server** dialog, enter **SQL2008-SUFFIX** into the Server name box, ensure **Windows Authentication** is selected, and then select **Connect**.

   ![The SQL Server Connect to Search dialog is displayed, with SQL2008-SUFFIX entered into the Server name and Windows Authentication selected.](https://raw.githubusercontent.com/CloudLabs-MCW/MCW-Migrating-SQL-databases-to-Azure/fix/Hands-on%20lab/media/ssms.png "Connect to Server")

3. Once connected, expand **Databases** under SQL2008-SUFFIX in the Object Explorer, and then right-click the **WideWorldImporters** database. In the context menu, select **Tasks** and then **Back Up**.

   ![In the SSMS Object Explorer, the context menu for the WideWorldImporters database is displayed, with Tasks and Back Up... highlighted.](https://raw.githubusercontent.com/CloudLabs-MCW/MCW-Migrating-SQL-databases-to-Azure/fix/Hands-on%20lab/media/dm5.png "SSMS Backup")

4. In the Back Up Database dialog, you should see `C:\WideWorldImporters.bak` listed in the Destinations box. This device is no longer needed, so select it and then select **Remove**.

   ![In the General tab of the Back Up Database dialog, C:\WideWorldImporters.bak is selected, and the Remove button is highlighted under destinations.](media/ssms-back-up-database-general-remove.png)

5. Next, select **Add** to add the SMB network share as a backup destination.

   ![In the General tab of the Back Up Database dialog, the Add button is highlighted under destinations.](media/ssms-back-up-database-general.png "Back Up Database")

6. In the Select Backup Destination dialog, select the Browse (`...`) button.

   ![The Browse button is highlighted in the Select Backup Destination dialog.](media/ssms-select-backup-destination.png "Select Backup Destination")

7. In the Location Database Files dialog, select the `C:\dms-backups` folder, enter `WideWorldImporters.bak` into the File name field, and then select **OK**.

   ![In the Select the file pane, the C:\dms-backups folder is selected and highlighted, and WideWorldImporters.bak is entered into the File name field.](media/ssms-locate-database-files.png "Location Database Files")

8. Select **OK** to close the Select Backup Destination dialog.

   ![The OK button is highlighted on the Select Backup Destination dialog and C:\dms-backups\WideWorldImporters.bak is entered in the File name textbox.](media/ssms-backup-destination.png "Backup Destination")

9. In the Back Up Database dialog, select **Media Options** in the Select a page pane, and then set the following:

   - Select **Back up to the existing media set** and then select **Overwrite all existing backup sets**.
   - Under Reliability, check the box for **Perform checksum before writing to media**. A checksum is required by DMS when using the backup to restore the database to SQL MI.

   ![In the Back Up Database dialog, the Media Options page is selected, and Overwrite all existing backup sets and Perform checksum before writing to media are selected and highlighted.](media/ssms-back-up-database-media-options.png "Back Up Database")

10. Select **OK** to perform the backup.

11. You will receive a message when the backup is complete. Select **OK**.

    ![Screenshot of the dialog confirming the database backup was completed successfully.](media/ssms-backup-complete.png "Backup complete")

### Task 4: Retrieve SQL MI and SQL Server 2008 VM connection information

In this task, you use the Azure Cloud shell to retrieve the information necessary to connect to your Sql2008-SUFFIX VM from DMS.

1. In the Azure portal `https://portal.azure.com`, select the Azure Cloud Shell icon from the top menu.

   ![The Azure Cloud Shell icon is highlighted in the Azure portal's top menu.](media/cloud-shell-icon.png "Azure Cloud Shell")

2. In the Cloud Shell window that opens at the bottom of your browser window, select **PowerShell**.

   ![In the Welcome to Azure Cloud Shell window, PowerShell is highlighted.](media/cloud-shell-select-powershell.png "Azure Cloud Shell")

3. If prompted about not having a storage account mounted, select the subscription you are using for this hands-on lab and select **Create storage**.

   ![In the You have no storage mounted dialog, a subscription has been selected, and the Create Storage button is highlighted.](media/cloud-shell-create-storage.png "Azure Cloud Shell")

   > **Note**
   >
   > If the creation fails, you may need to select **Advanced settings** and specify the subscription, region, and resource group for the new storage account.

4. After a moment, a message is displayed that you have successfully requested a Cloud Shell, and you are presented with a PS Azure prompt.

   ![In the Azure Cloud Shell dialog, a message is displayed that requesting a Cloud Shell succeeded, and the PS Azure prompt is displayed.](media/cloud-shell-ps-azure-prompt.png "Azure Cloud Shell")

5. At the prompt, retrieve the public IP address of the SqlSerer2008 VM. This IP address will be used to connect to the database on that server. Enter the following PowerShell command, **replacing `<your-resource-group-name>`** in the resource group name variable with the name of your resource group: **hands-on-lab-SUFFIX** and replace SUFFIX in the VM name. 

   ```powershell
   $resourceGroup = "<your-resource-group-name>"
   az vm list-ip-addresses -g $resourceGroup -n Sql2008-SUFFIX --output table
   ```

   > **Note**
   >
   > If you have multiple Azure subscriptions, and the account you are using for this hands-on lab is not your default account, you may need to run `az account list --output table` at the Azure Cloud Shell prompt to output a list of your subscriptions, then copy the Subscription Id of the account you are using for this lab and then run `az account set --subscription <your-subscription-id>` to set the appropriate account for the Azure CLI commands.

6. Within the output, locate and copy the value of the `ipAddress` property below the `PublicIPAddresses` field. Paste the value into a text editor, such as Notepad.exe, for later reference.

   ![The output from the az vm list-ip-addresses command is displayed in the Cloud Shell, and the public IP address for the Sql2008-SUFFIX VM is highlighted.](https://raw.githubusercontent.com/CloudLabs-MCW/MCW-Migrating-SQL-databases-to-Azure/fix/Hands-on%20lab/media/vmip.png "Azure Cloud Shell")

7. Leave the Azure Cloud Shell open for the next task.

### Task 5: Create and run an online data migration project

In this task, you create a new online data migration project in DMS for the `WideWorldImporters` database.

1. In the Azure portal `https://portal.azure.com`, navigate to the Azure Database Migration Service by selecting **Resource groups** from the left-hand navigation menu, selecting the **hands-on-lab-SUFFIX** resource group, and then selecting the **wwi-dms** Azure Database Migration Service in the list of resources.

   ![The wwi-dms Azure Database Migration Service is highlighted in the list of resources in the hands-on-lab-SUFFIX resource group.](media/resource-group-dms-resource.png "Resources")

2. On the Azure Database Migration Service blade, select **+New Migration Project**.

   ![On the Azure Database Migration Service blade, +New Migration Project is highlighted in the toolbar.](media/dms-add-new-migration-project.png "Azure Database Migration Service New Project")

3. On the New migration project blade, enter the following:

   - **Project name**: Enter `OnPremToSqlMi`
   - **Source server type**: Select **SQL Server**.
   - **Target server type**: Select **Azure SQL Database Managed Instance**.
   - **Choose type of activity**: Select **Online data migration**

   ![The New migration project blade is displayed, with the values specified above entered into the appropriate fields.](media/sqlnndbdbdbd.png "New migration project")

4. Select **Create and run activity**.

5. On the Migration Wizard **Select source** tab, enter the following:

   - **Source SQL Server instance name**: Enter the IP address of your Sql2008-SUFFIX VM that you copied into a text editor in the previous task. For example, `40.65.112.26`.
   - **Authentication type**: Select SQL Authentication.
   - **Username**: Enter `WorkshopUser`
   - **Password**: Enter `Password.1234567890`
   - **Connection properties**: Check both Encrypt connection and Trust server certificate.

   ![The Migration Wizard Select source tab is displayed, with the values specified above entered into the appropriate fields.](media/dms-migration-wizard-select-source.png "Migration Wizard Select source")

6. Select **Next : Select target**.

7. On the Migration Wizard **Select target** tab, enter the following:

   - **Application ID**: Enter the `Application/Client ID` value from the lab details page..
   - **Key**: Enter the `Application Secret Key` value from the lab details page.
   - **Skip the Application ID Contributor level access check on the subscription**: Leave this unchecked.
   - **Subscription**: Select the subscription you are using for this hand-on lab.
   - **Target Azure SQL Managed Instance**: Select the sqlmi--cus instance.
   - **SQL Username**: Enter `contosoadmin`
   - **Password**: Enter `IAE5fAijit0w^rDM`

   ![The Migration Wizard Select target tab is displayed, with the values specified above entered into the appropriate fields.](https://raw.githubusercontent.com/SpektraSystems/MCW-Migrating-SQL-databases-to-Azure/stage/Hands-on%20lab/media/h2.png "Migration Wizard Select target")

8. Select **Next : Select databases**.

9. On the Migration Wizard **Select databases** tab, select `WideWorldImporters`.

   ![The Migration Wizard Select databases tab is displayed, with the WideWorldImporters database selected.](media/dms-migration-wizard-select-databases.png "Migration Wizard Select databases")

10. Select **Next : Configure migration settings**.

11. On the Migration Wizard **Configure migration settings** tab, enter the following configuration:

    - **Network share location**: Populate this field with the path to the SMB network share you created previously by entering `\\SQL2008-SUFFIX\dms-backups`.
    - **Windows User Azure Database Migration Service impersonates to upload files to Azure Storage**: Enter `SQL2008-SUFFIX\sqlmiuser.`
    - **Password**: Enter `Password.1234567890`
    - **Subscription containing storage account**: Select the subscription you are using for this hands-on lab.
    - **Storage account**: Select the **sqlmistoreUNIQUEID** storage account.

    ![The Migration Wizard Configure migration settings tab is displayed, with the values specified above entered into the appropriate fields.](https://raw.githubusercontent.com/CloudLabs-MCW/MCW-Migrating-SQL-databases-to-Azure/fix/Hands-on%20lab/media/dm12.png "Migration Wizard Configure migration settings")
 
 - Click on **Advance Settings**. 
 - **WideWorldImporters**: Enter **Target Database name** WideWorldImportersSUFFIX. 

   Note: - You can get SUFFIX details from you Environment details page 

    ![The Migration Wizard Configure migration settings blade is displayed, with the values specified above entered into the appropriate fields.](https://raw.githubusercontent.com/CloudLabs-MCW/MCW-Migrating-SQL-databases-to-Azure/fix/Hands-on%20lab/media/dm14.png "Migration Wizard Configure migration settings")

12. Select **Next : Summary**.

13. On the Migration Wizard **Summary** tab, enter `WwiMigration` as the **Activity name**.

    ![The Migration Wizard summary tab is displayed, WwiMigration is entered into the name field, and Validate my database(s) is selected in the Choose validation option blade, with all three validation options selected.](media/dms-migration-wizard-migration-summary.png "Migration Wizard Summary")

14. Select **Start migration**.

15. Monitor the migration on the status screen that appears. You can select the refresh icon in the toolbar to retrieve the latest status. Continue selecting **Refresh** every 5-10 seconds until you see the status change to **Log shipping in progress**. When that status appears, move on to the next task.

    ![In the migration monitoring window, a status of Log shipping in progress is highlighted.](media/dms-migration-wizard-status-log-files-uploading.png "Migration status")

### Task 6: Perform migration cutover

Since you performed an "online data migration," the migration wizard continuously monitors the SMB network share for newly added log backup files. Online migrations enable any updates on the source database to be captured until you initiate the cut over to the SQL MI database. In this task, you add a record to one of the database tables, backup the logs, and complete the migration of the `WideWorldImporters` database by cutting over to the SQL MI database.

1. In the Azure portal's migration status window and select **WideWorldImporters** under database name to view further details about the database migration.

   ![The WideWorldImporters database name is highlighted in the migration status window.](media/dms-migration-wizard-database-name.png "Migration status")

2. On the WideWorldImporters screen, note the status of **Restored** for the `WideWorldImporters.bak` file.

   ![On the WideWorldImporters blade, a status of Restored is highlighted next to the WideWorldImporters.bak file in the list of active backup files.](media/dms-migration-wizard-database-restored.png "Migration Wizard")

3. To demonstrate log shipping and how transactions made on the source database during the migration process are added to the target SQL MI database, you will add a record to one of the database tables.

4. Return to SSMS on your Sql2008-SUFFIX VM and select **New Query** from the toolbar.

   ![The New Query button is highlighted in the SSMS toolbar.](media/ssms-new-query.png "SSMS Toolbar")

5. Paste the following SQL script, which inserts a record into the `Game` table, into the new query window:

   ```sql
   USE WideWorldImporters;
   GO

   INSERT [dbo].[Game] (Title, Description, Rating, IsOnlineMultiplayer)
   VALUES ('Space Adventure', 'Explore the universe with are newest online multiplayer gaming experience. Build custom  rocket ships, and take off for the stars in an infinite open-world adventure.', 'T', 1)
   ```

6. Execute the query by selecting **Execute** in the SSMS toolbar.

   ![The Execute button is highlighted in the SSMS toolbar.](media/ssms-execute.png "SSMS Toolbar")

7. After adding the new record to the `Games` table, back up the transaction logs. DMS detects any new backups and ships them to the migration service. Select **New Query** again in the toolbar, and paste the following script into the new query window:

   ```sql
   USE master;
   GO

   BACKUP LOG WideWorldImporters
   TO DISK = 'c:\dms-backups\WideWorldImportersLog.trn'
   WITH CHECKSUM
   GO
   ```

8. Execute the query by selecting **Execute** in the SSMS toolbar.

9. Return to the migration status page in the Azure portal. On the WideWorldImporters screen, select **Refresh**, and you should see the **WideWorldImportersLog.trn** file appear with a status of **Queued**.

   ![On the WideWorldImporters blade, the Refresh button is highlighted. A status of Uploaded is highlighted next to the WideWorldImportersLog.trn file in the list of active backup files.](media/dms-migration-wizard-transaction-log-queued.png "Migration wizard")

   > **Note**
   >
   > If you don't see it the transaction logs entry, continue selecting refresh every 10-15 seconds until it appears.

10. Continue selecting **Refresh**, and you should see the **WideWorldImportersLog.trn** status change to **Uploaded**.

11. After the transaction logs are uploaded, they are restored to the database. Once again, continue selecting **Refresh** every 10-15 seconds until you see the status change to **Restored**, which can take a minute or two.

    ![A status of Restored is highlighted next to the WideWorldImportersLog.trn file in the list of active backup files.](media/dms-migration-wizard-transaction-log-restored.png "Migration Wizard")

12. After verifying the transaction log status of **Restored**, select **Start Cutover**.

    ![The Start Cutover button is displayed.](media/dms-migration-wizard-start-cutover.png "DMS Migration Wizard")

13. On the Complete cutover dialog, verify pending log backups is `0`, check **Confirm**, and then select **Apply**.

    ![In the Complete cutover dialog, 0 is highlighted next to Pending log backups, and the Confirm checkbox is checked.](media/dms-migration-wizard-complete-cutover-apply.png "Migration Wizard")

14. A progress bar below the Apply button in the Complete cutover dialog provides updates on the cutover status. When the migration finishes, the status changes to **Completed**.

    ![A status of Completed is displayed in the Complete cutover dialog.](media/dms-migration-wizard-complete-cutover-completed.png "Migration Wizard")

    > **Note**
    >
    > If the progress bar has not moved after a few minutes, you can proceed to the next step and monitor the cutover progress on the WwiMigration blade by selecting refresh.

15. To return to the WwiMigration blade, close the Complete cutover dialog by selecting the "X" in the upper right corner of the dialog, and do the same thing for the WideWorldImporters blade. Select **Refresh**, and you should see a status of **Completed** from the WideWorldImporters database.

    ![On the Migration job blade, the status of Completed is highlighted.](media/dms-migration-wizard-status-complete.png "Migration with Completed status")

16. You have successfully migrated the `WideWorldImporters` database to Azure SQL Managed Instance.

### Task 7: Verify database and transaction log migration

In this task, you connect to the SQL MI database using SSMS and quickly verify the migration.

1. First, use the Azure Cloud Shell to retrieve the fully qualified domain name of your SQL MI database. In the Azure portal `https://portal.azure.com`, select the Azure Cloud Shell icon from the top menu.

   ![The Azure Cloud Shell icon is highlighted in the Azure portal's top menu.](media/cloud-shell-icon.png "Azure Cloud Shell")

2. In the Cloud Shell window that opens at the bottom of your browser window, select **PowerShell**.

   ![In the Welcome to Azure Cloud Shell window, PowerShell is highlighted.](media/cloud-shell-select-powershell.png "Azure Cloud Shell")

3. After a moment, a message is displayed that you have successfully requested a Cloud Shell, and be presented with a PS Azure prompt.

   ![In the Azure Cloud Shell dialog, a message is displayed that requesting a Cloud Shell succeeded, and the PS Azure prompt is displayed.](media/cloud-shell-ps-azure-prompt.png "Azure Cloud Shell")

4. At the prompt, retrieve information about SQL MI in the SQLMI-Shared-RG resource group by entering the following PowerShell command, **replacing `<your-resource-group-name>`** in the resource group name variable with the name of your resource group: **SQLMI-Shared-RG**

   ```powershell
   $resourceGroup = "<your-resource-group-name>"
   az sql mi list --resource-group $resourceGroup
   ```

   > **Note**
   >
   > If you have multiple Azure subscriptions, and the account you are using for this hands-on lab is not your default account, you may need to run `az account list --output table` at the Azure Cloud Shell prompt to output a list of your subscriptions. Copy the Subscription Id of the account you are using for this lab and then run `az account set --subscription <your-subscription-id>` to set the appropriate account for the Azure CLI commands.

5. Within the above command's output, locate and copy the value of the `fullyQualifiedDomainName` property. Paste the value into a text editor, such as Notepad.exe, for reference below.

   ![The output from the az sql mi list command is displayed in the Cloud Shell, and the fullyQualifiedDomainName property and value are highlighted.](media/cloud-shell-az-sql-mi-list-output.png "Azure Cloud Shell")

6. Return to SSMS on your Sql2008-SUFFIX VM, and then select **Connect** and **Database Engine** from the Object Explorer menu.

   ![In the SSMS Object Explorer, Connect is highlighted in the menu, and Database Engine is highlighted in the Connect context menu.](media/ssms-object-explorer-connect.png "SSMS Connect")

7. In the Connect to Server dialog, enter the following:

   - **Server name**: Enter the fully qualified domain name of your SQL managed instance, which you copied from the Azure Cloud Shell in the previous steps.
   - **Authentication**: Select **SQL Server Authentication**.
   - **Login**: Enter `contosoadmin`
   -  **Password:** Enter IAE5fAijit0w^rDM
   - Check the **Remember password** box.

   ![The SQL managed instance details specified above are entered into the Connect to Server dialog.](https://raw.githubusercontent.com/SpektraSystems/MCW-Migrating-SQL-databases-to-Azure/stage/Hands-on%20lab/media/ssmsmi.png "Connect to Server")

8. Select **Connect**. 

9. The SQL MI connection appears below the SQL2008-SUFFIX connection. Expand Databases the SQL MI connection and select the `WideWorldImportersSUFFIX` database.

   ![In the SSMS Object Explorer, the SQL MI connection is expanded, and the WideWorldImporters database is highlighted and selected.](https://raw.githubusercontent.com/CloudLabs-MCW/MCW-Migrating-SQL-databases-to-Azure/fix/Hands-on%20lab/media/dm23.png "SSMS Object Explorer")

10. With the `WideWorldImportersSUFFIX` database selected, select **New Query** on the SSMS toolbar to open a new query window.

11. In the new query window, enter the following SQL script:

    ```sql
    USE WideWorldImportersSUFFIX;
    GO

    SELECT * FROM Game
    ```

12. Select **Execute** on the SSMS toolbar to run the query. Observe the records contained within the `Game` table, including the new `Space Adventure` game you added after initiating the migration process.

    ![In the new query window, the query above has been entered, and in the results pane, the new Space Adventure game is highlighted.](media/ssms-query-game-table.png "SSMS Query")

13. You are done using the Sql2008-SUFFIX VM. Close any open windows and log off the VM. The JumpBox VM is used for the remaining tasks of this hands-on lab.

