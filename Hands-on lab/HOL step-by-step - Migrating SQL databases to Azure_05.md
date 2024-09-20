## Exercise 1: Perform database assessments

In this lab, you will connect to the WideWorldImporters database on the SqlServer2008 VM and perform assessments for migration to Azure SQL Database and Azure SQL Managed Instance. These assessments will help you understand the compatibility and readiness of your database for migration to Azure. You will evaluate the database schema, data, and performance to identify any potential issues and determine the best migration strategy. This process ensures a smooth transition to Azure’s cloud services, leveraging their scalability, security, and advanced features.

## Lab Objective

In this lab, you will perform the following:

- Task 1: Connect to the WideWorldImporters database on the SqlServer2008 VM
- Task 2: Perform assessment for migration to Azure SQL Database
- Task 3: Perform assessment for migration to Azure SQL Managed Instance

## Duration: 20 minutes

### Task 1: Connect to the WideWorldImporters database on the SqlServer2008 VM

In this task, you perform some configuration for the `WideWorldImporters` database on the SQL Server 2008 R2 instance to prepare it for migration.

1. On Azure Portal page, in **Search resources, services and docs (G+/)** box at the top of the portal, enter **Resource groups**, and then select **Resource groups** under services.

   ![Resource groups is highlighted in the Azure services list.](media/new-image2.png)

1. Select the **<inject key="Resource Group Name" enableCopy="false"/>** resource group from the list.

   ![Resource groups is selected in the Azure navigation pane, and the "hands-on-lab resource group is highlighted.](media/new-image(3).png)

1. In the list of resources for your resource group, select the **<inject key="SQLVM Name" enableCopy="false"/>** VM.

    ![](media/new-image4.png)

1. From the overview page of  the **<inject key="SQLVM Name" enableCopy="false"/>** VM, select **Connect > Connect**.

    ![](media/new-image5.png)

1. On the **sql2008-<inject key="Suffix" enableCopy="false"/> | Connect** page, click on **Download RDP file (2)**. 
  
   ![](media/new-image6.png)

1. Click on **Keep**, on the Downloads pop-up. 

   ![The Passed tab is highlighted, and VA1219 is entered into the search filter. VA1219 with a status of PASS is highlighted in the results.](media/datamod15.png "Passed")

1. Click on **Open file**.

   ![](media/datamod16.png)

1. Next, on the RDP tab click on **Connect**.

   ![The Passed tab is highlighted, and VA1219 is entered into the search filter. VA1219 with a status of PASS is highlighted in the results.](media/datamod17.png "Passed")

1. Enter the following credentials when prompted, and then select **OK**:

   - **Username**: `sqlmiuser`
   - **Password**: `Password.1234567890`

      ![The credentials specified above are entered into the Enter your credentials dialog.](media/rdc-credentials-sql-2008.png "Enter your credentials")

1. Select **Yes** to connect if prompted that the remote computer's identity cannot be verified.

   ![In the Remote Desktop Connection dialog box, a warning states that the remote computer's identity cannot be verified and asks if you want to continue anyway. At the bottom, the Yes button is circled.](./media/remote-desktop-connection-identity-verification-sqlserver2008.png "Remote Desktop Connection dialog")

1. Click on **start (1)** , type **Azure Data Studio (2)** into the search bar and select **Azure Data Studio (3)** from the search results.

   ![](media/new-image7.png)
   
1. In the Azure Data Studio select **Extensions (1)** from the Activity Bar, enter **SQL Migration (2)** into the search bar, select **Azure SQL Migration (3)**, and click on **Install (4)**.  

    ![](media/new-image8.png)

1. In the Azure Data Studio select **Connections (1)** from the Activity Bar, click on **New Connection (1)** dialog, enter **<inject key="SQLVM Name" /> (2)** into the Server name box, ensure **Windows Authentication** is selected, and then select **Connect (3)**.
  
    ![The SQL Server Connect to Search dialog is displayed, with SQL2008-entered into the Server name and Windows Authentication selected.](media/Ex1-Task1-S10.png "Connect to Server")
    
    > **Note**: If you see **Connection error** pop-up click on **Enable Trust server certificate**.

      ![](media/new-image15.png)

1. Once connected, verify you see the `WideWorldImporters` database listed under databases.

    ![The WideWorldImporters database is highlighted under Databases on the SQL2008-instance.](media/Ex1-Task1-S11.png "WideWorldImporters database")

1. Right click on **<inject key="SQLVM Name" /> (1)**, click on **Manage (2)**, and select **New Query (3)** from the Azure Data Studio toolbar.

    ![The New Query button is highlighted in the SSMS toolbar.](media/Ex1-Task1-S12.png "SSMS Toolbar")

1. Next, copy and paste the SQL script below into the new query window. This script enables the Service broker and changes the database recovery model to FULL.

    ```sql
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

### Task 2: Perform assessment for migration to Azure SQL Database

In this task, you use the Microsoft Data Migration Assistant (DMA) to assess the `WideWorldImporters` database against the Azure SQL Database (Azure SQL DB). The assessment provides a report about any feature parity and compatibility issues between the on-premises database and the Azure SQL DB service.

1. In Azure Data Studio click on **<inject key="SQLVM Name" /> (1)** > **Azure SQL migration (2)** and select **+ New migration (3)**.

    ![](media/new-image16.png)

2. In **Step 1: Database for assessment**, select **widewordimplantation**, click on **Next**. 

   ![The new project icon is highlighted in DMA.](media/Ex1-Task2-S2.png "New DMA project")

3. In **Step 2: Assessment summary and SKU recommendation (1)**, you will view the summary and SKU recommendations for your SQL server. Click on **Next (2)**. 

   ![The new project settings for doing a SQL Server to Azure SQL Database migration assessment are entered into the dialog.](media/E1T2S31.png "New project settings")

4. In **Step 3: Target Platform and Assessment Results**, Select **Azure SQL DataBase(1)** from the drop down. Then select **WideWorldImporters(2)** under the database, review the migration assessment to determine the possibility of migrating to Azure SQL DB, and Click on the **Cancel (3)** button.

   ![The new project settings for doing a SQL Server to Azure SQL Database migration assessment are entered into the dialog.](media/E1T2S4.png "New project settings")

    > The DMA assessment for migrating the `WideWorldImporters` database to a target platform of Azure SQL DB reveals features in use that are not supported. These features, including Service broker, prevent WWI from migrating to the Azure SQL DB PaaS offering without making changes to their database.

### Task 3: Perform assessment for migration to Azure SQL Managed Instance

With one PaaS offering ruled out due to feature parity, perform a second DMA assessment against Azure SQL Managed Instance (SQL MI). The assessment provides a report about any feature parity and compatibility issues between the on-premises database and the SQL MI service.

1. In Azure Data Studio click on >  **<inject key="SQLVM Name" /> (1)** **Azure SQL migration (2)** and select **+ New migration (3)**.

    ![](media/new-image16.png)

2. In **Step 1: Database for assessment**, select **widewordimplantation**, click on **Next**. 

   ![The new project icon is highlighted in DMA.](media/Ex1-Task2-S2.png "New DMA project")

3. In **Step 2: Assessment summary and SKU recommendation (1)**, you will view the summary and SKU recommendations for your SQL server. Click on **Next (2)**. 

    ![The new project settings for doing a SQL Server to Azure SQL Database migration assessment are entered into the dialog.](media/E1T2S31.png "New project settings")

4. In **Step 3: Target Platform and Assessment Results**, Select **Azure SQL Managed Instance (1)** from the drop down. Then select **WideWorldImporters (2)** under the database, review the migration assessment to determine the possibility of migrating to Azure SQL DB, and Click on the **Cancel (3)** button.

     ![The new project settings for doing a SQL Server to Azure SQL Database migration assessment are entered into the dialog.](media/E1T3S4.png "New project settings")

  
>**Congratulations** on completing the Task! Now, it's time to validate it.

5. The database, including the Service Broker feature, can be migrated as is, providing an opportunity for WWI to have a fully managed PaaS database running in Azure. Previously, their only option for migrating a database using features incompatible with Azure SQL Database, such as Service Broker, was to deploy the database to a virtual machine running in Azure (IaaS) or modify the database and associated applications to remove the use of the unsupported features. The introduction of Azure SQL MI, however, provides the ability to migrate databases into a managed Azure SQL database service with _near 100% compatibility_, including the features that prevented them from using Azure SQL Database.

## Summary
By completing these tasks, you have assessed the WideWorldImporters database for compatibility with Azure SQL Database and Azure SQL Managed Instance, identifying the most suitable migration path for your database.

## Review 
In this lab, you have completed:

- Connect to the WideWorldImporters database on the SqlServer2008 VMTask 1: Connect to the WideWorldImporters database on the SqlServer2008 VM
- Perform assessment for migration to Azure SQL Database
- Perform assessment for migration to Azure SQL Managed Instance

### You have successfully completed this lab.
