## Exercise 1: Improve database security posture with Data Discovery and Classification and Azure Defender for SQL

Duration: 30 minutes

In this exercise, you are able to set up some of the advanced security features of SQL MI and explore some of the security benefits that come with running your database in Azure. [Azure Defender for SQL](https://docs.microsoft.com/azure/azure-sql/database/azure-defender-for-sql) provides advanced SQL security capabilities, including functionality for surfacing and mitigating potential database vulnerabilities and detecting anomalous activities that could indicate a threat to your database. Also, [Data Discovery and Classification](https://docs.microsoft.com/azure/azure-sql/database/data-discovery-and-classification-overview) allows you to discover and classify sensitive data within the database.

### Task 1: Configure Data Discovery and Classification

In this task, you review the [Data Discovery and Classification](https://docs.microsoft.com/azure/azure-sql/database/data-discovery-and-classification-overview) feature of Azure SQL. Data Discovery & Classification introduces a new tool for discovering, classifying, labelling, and reporting the sensitive data in your databases. It introduces a set of advanced services, forming a new SQL Information Protection paradigm aimed at protecting the data in your database, not just the database. Discovering and classifying your most sensitive data (e.g., business, financial, healthcare) can play a pivotal role in your organizational information protection stature.

1. Navigate to **SQLMI-Shared-RG** resource group and select the SQL Managed instance named **sqlmi--cus**. Now, from the **Overview** tab select the Managed database named **<inject key="Database Name" enableCopy="false"/>**.

1. On the <inject key="Database Name" enableCopy="false"/> Managed database blade, select **Data Discovery & Classification** from the left-hand menu.

   ![The Data Discovery & Classification tile is displayed.](media/ads-data-discovery-and-classification-pane.png "Data Discovery & Classification Dashboard")

1. In the **Data Discovery & Classification** blade, select the info link with the message **Currently database is using SQL information Protection policy. Found 35 columns with classification recommendations**.

   ![The recommendations link on the Data Discovery & Classification blade is highlighted.](media/datamod12.png "Data Discovery & Classification")

1. Look over the list of recommendations to get a better understanding of the types of data and classifications that can be assigned, based on the built-in classification settings. In the list of classification recommendations, select the recommendation for the **Sales - CreditCard - CardNumber** field.

   ![The CreditCard number recommendation is highlighted in the recommendations list.](media/ads-data-discovery-and-classification-recommendations-credit-card.png "Data Discovery & Classification")

1. Due to the risk of exposing credit card information, WWI would like a way to classify it as highly confidential, not just **Confidential**, as the recommendation suggests. To correct this, select **+ Add classification** at the top of the Data Discovery & Classification blade.

   ![The +Add classification button is highlighted in the toolbar.](media/ads-data-discovery-and-classification-add-classification-button.png "Data Discovery & Classification")

1. Quickly expand the **Sensitivity label** field and review the various built-in labels from which you can choose. You can also add custom labels, should you desire.

   ![The list of built-in Sensitivity labels is displayed.](media/ads-data-discovery-and-classification-sensitivity-labels.png "Data Discovery & Classification")

1. In the Add classification dialog, enter the following:

   - **Schema name**: Select **Sales**.
   - **Table name**: Select **CreditCard**.
   - **Column name**: Select **CardNumber (nvarchar)**.
   - **Information type**: Select **Credit Card**.
   - **Sensitivity level**: Select **Highly Confidential**.

      ![The values specified above are entered into the Add classification dialog.](media/ads-data-discovery-and-classification-add-classification.png "Add classification")

1. Select **Add classification**.

1. Notice that the **Sales - CreditCard - CardNumber** field disappears from the recommendations list, and the number of recommendations drops by 1.

1. Select **Save** on the toolbar of the Data Classification window. It may take several minutes for the save to complete.

   ![Save the updates to the classified columns list.](media/ads-data-discovery-and-classification-save.png "Save")

1. Other recommendations you can review are the **HumanResources - Employee** fields for **NationIDNumber** and **BirthDate**. Note that the recommendation service flagged these fields as **Confidential - GDPR**. WWI maintains data about gamers from around the world, including Europe, so having a tool that helps them discover data that may be relevant to GDPR compliance is very helpful.

    ![GDPR information is highlighted in the list of recommendations](media/ads-data-discovery-and-classification-recommendations-gdpr.png "Data Discovery & Classification")

1. Check the **Select all** checkbox at the top of the list to select all the remaining recommended classifications, and then select **Accept selected recommendations**.

    ![All the recommended classifications are checked, and the Accept selected recommendations button is highlighted.](media/ads-data-discovery-and-classification-accept-recommendations.png "Data Discovery & Classification")

1. Select **Save** on the toolbar of the Data Classification window. It may take several minutes for the save to complete.

    ![Save the updates to the classified columns list.](media/ads-data-discovery-and-classification-save.png "Save")

1. When the save completes, select the **Overview** tab on the Data Discovery & Classification blade to view a report with a full summary of the database classification state.

    ![The View Report button is highlighted on the toolbar.](media/ads-data-discovery-and-classification-overview-report.png "View report")

### Task 2: Review an Azure Defender for SQL Vulnerability Assessment

In this task, you review an assessment report generated by Azure Defender for the `WideWorldImporters` database and take action to remediate one of the findings in the `WideWorldImporters` database. The [SQL Vulnerability Assessment service](https://docs.microsoft.com/azure/sql-database/sql-vulnerability-assessment) is a service that provides visibility into your security state and includes actionable steps to resolve security issues and enhance your database security.

1. Select **Microsoft Defender for Cloud** from the left hand navigation menu of the **<inject key="Database Name" enableCopy="false"/>** Managed database.

1. On the **Microsoft Defender for Cloud** blade for the <inject key="Database Name" enableCopy="false"/> Managed database, Scroll down and click on **View additional findings in Vulnerability Assessment** to open the Vulnerability Assessment blade.

   ![The Vulnerability tile is displayed.](media/Microsoft-Defender-for-Cloud.png "Azure Defender for SQL Vulnerability Assessment tile")

1. On the Vulnerability Assessment blade, select **Scan** on the toolbar.

   ![The Vulnerability assessment scan button is selected in the toolbar.](media/vulnerability-assessment-scan.png "Scan")

   > **Note**: If you encounter an error "Failed to execute Vulnerability Assessment scan for WideWorldlmporters<inject key="SUFFIX" enableCopy="false"/>. Error message: The configured storage account was not found in the subscriptions", perform the following steps.

   1. Move back to the **Microsoft Defender for Cloud** blade.

   2. Once you are in the **Microsoft Defender for Cloud** blade, click on **Configure** of the Enablement Status: Enabled at the subscription level.

      ![The Vulnerability assessment scan button is selected in the toolbar.](media/microsoft-defender-configure.png "microsoft-defender-configure")

   3. On the **Server Settings** blade, click on **Select Storage acount** under Storage account.

      ![The Vulnerability assessment scan button is selected in the toolbar.](media/server-setting-storage-account.png "server-setting-storage-account")

   4. On **Choose storage account** blade, select the storage account **sqlmistore<inject key="SUFFIX" enableCopy="false"/>**.

      ![The Vulnerability assessment scan button is selected in the toolbar.](media/choose-storage-account.png "choose-storage-account")
      
   5. On the **Server Settings** blade, click on **Save**.

      ![The Vulnerability assessment scan button is selected in the toolbar.](media/server-setting-save.png "server-setting-save")

   6. Re-perform the steps 2 and 3.
 
1. When the scan completes, a dashboard displaying the number of failing and passing checks, along with a breakdown of the risk summary by severity level is displayed.

   ![The Vulnerability Assessment dashboard is displayed.](media/sql-mi-vulnerability-assessment-dashboard1.png "Vulnerability Assessment dashboard")

1. In the scan results, take a few minutes to browse both the Failed and Passed checks, and review the types of checks that are performed. In the **Unhealthy** list, locate the security check for **Transparent data encryption**. This check has an ID of **VA1219**.

   ![The VA1219 finding for Transparent data encryption is highlighted.](media/sql-mi-vulnerability-assessment-failed-va1219.png "Vulnerability assessment")

1. Select the **VA1219** finding to view the detailed description.

   ![The details of the VA1219 - Transparent data encryption should be enabled finding are displayed with the description, impact, and remediation fields highlighted.](media/sql-mi-vulnerability-assessment-failed-va1219-details1.png "Vulnerability Assessment")

   > The details for each finding provide more insight into the reason for the finding. Of note are fields describing the finding, the impact of the recommended settings, and details on remediation for the finding.

1. You will now act on the recommended remediation steps for the finding and enable [Transparent Data Encryption](https://docs.microsoft.com/azure/azure-sql/database/transparent-data-encryption-tde-overview?tabs=azure-portal) for the `WideWorldImporters` database. To accomplish this, switch over to using SSMS on your JumpBox VM for the next few steps.

   > **Note**
   >
   > Transparent data encryption (TDE) needs to be manually enabled for Azure SQL Managed Instance. TDE helps protect Azure SQL Database, Azure SQL Managed Instance, and Azure Data Warehouse against the threat of malicious activity. It performs real-time encryption and decryption of the database, associated backups, and transaction log files at rest without requiring changes to the application.

1. On your JumpBox VM, open Microsoft SQL Server Management Studio 19 from the Start menu, enter the following information in the **Connect to Server** dialog and click on **Connect**.

   - **Server name**: Enter the fully qualified domain name of your SQL-managed instance, which you copied from the Azure Cloud Shell in a previous task.
   - **Authentication**: Select **SQL Server Authentication**.
   - **Login**: Enter `contosoadmin`
   - **Password**: Enter `IAE5fAijit0w^rDM`
   - Check the **Remember password** box.

      ![The SQL managed instance details specified above are entered into the Connect to Server dialog.](media/ssms-18-connect-to-server.png "Connect to Server")

1. In SSMS, select **New Query** from the toolbar and paste the following SQL script into the new query window.
   > **Note**: Make sure to replace the SUFFIX with value **<inject key="Suffix" />**.

   ```SQL
   USE WideWorldImportersSUFFIX;
   GO

   ALTER DATABASE [WideWorldImportersSUFFIX] SET ENCRYPTION ON
   ```

   > You turn transparent data encryption on and off on the database level. To enable transparent data encryption on a database in Azure SQL Managed Instance use must use T-SQL.

1. Select **Execute** from the SSMS toolbar. After a few seconds, you will see a message that **Commands completed successfully**.

10. You can verify the encryption state and view information on the associated encryption keys by using the [sys.dm_database_encryption_keys view](https://docs.microsoft.com/sql/relational-databases/system-dynamic-management-views/sys-dm-database-encryption-keys-transact-sql). Select **New Query** on the SSMS toolbar again, and paste the following query into the new query window:

    ```SQL
    SELECT * FROM sys.dm_database_encryption_keys
    ```

    ![The query above is pasted into a new query window in SSMS.](media/ssms-sql-mi-database-encryption-keys.png "New query")

1. Select **Execute** from the SSMS toolbar. You will see two records in the Results window, which provide information about the encryption state and keys used for encryption.

    ![The Execute button on the SSMS toolbar is highlighted, and in the Results pane the two records about the encryption state and keys for the WideWorldImporters database are highlighted.](media/ssms-sql-mi-database-encryption-keys-results.png "Results")

    > By default, service-managed transparent data encryption is used. A transparent data encryption certificate is automatically generated for the server that contains the database.

1. Return to the Azure portal and the Azure Defender for SQL's Vulnerability Assessment blade of the `WideWorldImportersSUFFIX` managed database. On the toolbar, select **Scan** to start a new assessment of the database.

    ![The Vulnerability assessment scan button is selected in the toolbar.](media/vulnerability-assessment-scan.png "Scan")

1. When the scan completes, select the **Findings** tab, enter **VA1219** into the search filter box, and observe that the previous failure is no longer in the findings list.

    ![The Findings tab is highlighted, and VA1219 is entered into the search filter. The list displays no results.](media/sql-mi-vulnerability-assessment-failed-filter-va1219-1.png "Scan Findings List")

1. Now, select the **Passed** tab, and observe the **VA1219** check is listed with a status of **PASS**.

    ![The Passed tab is highlighted, and VA1219 is entered into the search filter. VA1219 with a status of PASS is highlighted in the results.](media/sql-mi-vulnerability-assessment-passed-va1219-1.png "Passed")

    > Using the SQL Vulnerability Assessment, it is simple to identify and remediate potential database vulnerabilities, allowing you to improve your database security proactively.
