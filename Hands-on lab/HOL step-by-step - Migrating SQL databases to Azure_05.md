# Exercise 1: Perform database assessments

Duration: 20 minutes

In this exercise, you use the Azure Data Studio to perform assessments on the `WideWorldImporters` database. You create two assessments: one for SQL DB and a second for SQL MI. These assessments provide reports about any feature parity and compatibility issues between the on-premises database and the Azure-managed SQL database service options.

> Azure Data Studio helps you upgrade to a modern data platform by detecting compatibility issues that can impact database functionality in your new version of SQL Server or Azure SQL Database. Azure Data Studio recommends performance and reliability improvements for your target environment and allows you to move your schema, data, and uncontained objects from your source server to your target server.

## Task 1: Connect to the WideWorldImporters database on the SqlServer2008 VM

In this task, you perform some configuration for the `WideWorldImporters` database on the SQL Server 2008 R2 instance to prepare it for migration.

1. On the JumpVM, click **Start (1)**, enter **Azure Data Studio (2)** in the search bar, and choose **Azure Data Studio (3)** from the search results.

   ![](media/azuredata.png "Windows start menu search")
   
1. In the Azure Data Studio select **Extensions (1)** from the Activity Bar, enter **SQL Migration (2)** into the search bar, select **Azure SQL Migration (3)**, and click on **Install (4)**.  

   ![](media/Ex1-Task1-S9b.png)

1. In the Azure Data Studio select **Connections (1)** from the Activity Bar, click on **New Connection (1)** dialog, enter **<inject key="SQLVM Name" /> (2)** into the Server name box, ensure **Windows Authentication** is selected, and then select **Connect (3)**.
  
    ![The SQL Server Connect to Search dialog is displayed, with SQL2008-entered into the Server name and Windows Authentication selected.](media/Ex1-Task1-S10.png "Connect to Server")
    
    > **Note**: If you see **Connection error** pop-up click on **Enable Trust server certificate**.

      ![](media/ex1-note.png "Connect issue")

1. Once connected, verify you see the `WideWorldImporters` database listed under databases.

    ![The WideWorldImporters database is highlighted under Databases on the SQL2008-instance.](media/Ex1-Task1-S11.png "WideWorldImporters database")

1. Right click on **<inject key="SQLVM Name" /> (1)**, click on **Manage (2)**, and select **New Query (3)** from the Azure Data Studio toolbar.

    ![The New Query button is highlighted in the SSMS toolbar.](media/Ex1-Task1-S12.png "SSMS Toolbar")

1. Next, copy and paste the SQL script below into the new query window. This script enables the Service broker and changes the database recovery model to FULL.

    ```SQL
    USE master;
    GO

    -- Update the recovery model of the database to FULL and enable Service Broker
    ALTER DATABASE WideWorldImporters SET
    RECOVERY FULL,
    ENABLE_BROKER WITH ROLLBACK IMMEDIATE;
    GO
    ```

1. To run the script, select **Run** from the Azure Data Studio toolbar.

    ![The Execute button is highlighted in the SSMS toolbar.](media/Ex1-Task1-S14.png "SSMS Toolbar")

## Task 2: Perform assessment for migration to Azure SQL Database

In this task, you use the Microsoft Data Migration Assistant (DMA) to assess the `WideWorldImporters` database against the Azure SQL Database (Azure SQL DB). The assessment provides a report about any feature parity and compatibility issues between the on-premises database and the Azure SQL DB service.

1. In Azure Data Studio click on **Azure SQL migration** and click on **+ New migration**.

   ![In the Windows Start menu, "data migration" is entered into the search bar, and Microsoft Data Migration Assistant is highlighted in the Windows start menu search results.](media/Ex1-Task2-S1.png "Data Migration Assistant")

2. In **Step 1: Database for assessment**, select **WideWorldImporters**, click on **Next**. 

   ![The new project icon is highlighted in DMA.](media/Ex1-Task2-S2.png "New DMA project")

3. In **Step 2: Assessment summary and SKU recommendation**, you will view the summary and SKU recommendations for your SQL server. Click on **Next**. 

   ![The new project settings for doing a SQL Server to Azure SQL Database migration assessment are entered into the dialog.](media/13125(3).png "New project settings")

4. In **Step 3: Target Platform and Assessment Results**, Select **Azure SQL Database (1)** from the drop down. Then select **WideWorldImporters (2)** under the database, review the migration assessment to determine the possibility of migrating to Azure SQL DB, and Click on the **Cancel (3)** button.

   ![The new project settings for doing a SQL Server to Azure SQL Database migration assessment are entered into the dialog.](media/E1T2S4.png "New project settings")

   > The DMA assessment for migrating the `WideWorldImporters` database to a target platform of Azure SQL DB reveals features in use that are not supported. These features, including Service broker, prevent WWI from migrating to the Azure SQL DB PaaS offering without making changes to their database.

1. Click on **Yes** to cancel the migration.

   ![The new project settings for doing a SQL Server to Azure SQL Database migration assessment are entered into the dialog.](media/13125(4).png "New project settings")

## Task 3: Perform assessment for migration to Azure SQL Managed Instance

With one PaaS offering ruled out due to feature parity, perform a second DMA assessment against Azure SQL Managed Instance (SQL MI). The assessment provides a report about any feature parity and compatibility issues between the on-premises database and the SQL MI service.

1. In Azure Data Studio click on **Azure SQL migration** and click on **+ New migration**.

   ![In the Windows Start menu, "data migration" is entered into the search bar, and Microsoft Data Migration Assistant is highlighted in the Windows start menu search results.](media/Ex1-Task2-S1.png "Data Migration Assistant")

2. In **Step 1: Database for assessment**, select **WideWorldImporters**, click on **Next**. 

   ![The new project icon is highlighted in DMA.](media/Ex1-Task2-S2.png "New DMA project")

3. In **Step 2: Assessment summary and SKU recommendation**, you will view the summary and SKU recommendations for your SQL server. Click on **Next**. 

   ![The new project settings for doing a SQL Server to Azure SQL Database migration assessment are entered into the dialog.](media/13125(3).png "New project settings")

4. In **Step 3: Target Platform and Assessment Results**, Select **Azure SQL Managed Instance (1)** from the drop down. Then select **WideWorldImporters (2)** under the database, review the migration assessment to determine the possibility of migrating to Azure SQL DB, and Click on the **Cancel (3)** button.

    ![The new project settings for doing a SQL Server to Azure SQL Database migration assessment are entered into the dialog.](media/E1T3S4.png "New project settings")

1. Click on **Yes** to cancel the migration.

   ![The new project settings for doing a SQL Server to Azure SQL Database migration assessment are entered into the dialog.](media/13125(4).png "New project settings")
  
   >**Congratulations** on completing the Task! Now, it's time to validate it. Here are the steps:
   > - Navigate to the Lab Validation tab, from the upper right corner in the lab guide section.
   > - Hit the Validate button for the corresponding task. If you receive a success message, you have successfully validated the lab. 
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com.

5. The database, including the Service Broker feature, can be migrated as is, providing an opportunity for WWI to have a fully managed PaaS database running in Azure. Previously, their only option for migrating a database using features incompatible with Azure SQL Database, such as Service Broker, was to deploy the database to a virtual machine running in Azure (IaaS) or modify the database and associated applications to remove the use of the unsupported features. The introduction of Azure SQL MI, however, provides the ability to migrate databases into a managed Azure SQL database service with _near 100% compatibility_, including the features that prevented them from using Azure SQL Database.

### **Summary:**

By completing these tasks, you have assessed the WideWorldImporters database for compatibility with Azure SQL Database and Azure SQL Managed Instance, identifying the most suitable migration path for your database.
