# Exercise 3: Update the web application to use the new SQL MI database

Duration: 30 minutes

With the `WideWorldImporters` database now running on SQL MI in Azure, the next step is to make the required modifications to the WideWorldImporters gamer information web application.

> **Note**: Azure SQL Managed Instance has a private IP address in a dedicated VNet, so to connect an application, you must configure access to the VNet where the Managed Instance is deployed. To learn more, read Connect your application to Azure SQL Managed Instance `https://docs.microsoft.com/azure/azure-sql/managed-instance/connect-application-instance`.

## Task 1: Deploy the web app to Azure

In this task, you will use JumpBox VM and then, using Visual Studio on the JumpBox, deploy the `WideWorldImporters` web application into the App Service in Azure.

1. You have already logged in to JumpBox VM, use this VM to continue with the lab. 

1. In the File Explorer dialog, navigate to the `C:\hands-on-lab` folder and then drill down to `MCW-Migrating-SQL-databases-to-Azure-master\Hands-on lab\lab-files`. In the `lab-files` folder, double-click `WideWorldImporters.sln` to open the solution in Visual Studio.

   ![The folder at the path specified above is displayed, and WideWorldImporters.sln is highlighted.](media/windows-explorer-lab-files-web-solution.png "Windows Explorer")

1. If prompted about how you want to open the file, select **Visual Studio 2022**, and then select **OK**.

    ![In the Visual Studio version selector, Visual Studio 2019 is selected and highlighted.](media/datamod2.png "Visual Studio")

1. Select **Sign in** and click on Login through Work or education account and enter the following Azure account credentials when prompted:
   
   * Email/Username: <inject key="AzureAdUserEmail"></inject>

   * Password: <inject key="AzureAdUserPassword"></inject>

        ![On the Visual Studio welcome screen, the Sign in button is highlighted.](media/datamod3.png "Visual Studio")

1. If the "Stay signed in to all your apps" pop-up appears, click **OK**.

    ![](media/13125(10).png)    

1. Once you signed in, Click on **Start Visual Studio**.

    ![On the Visual Studio welcome screen, the Sign in button is highlighted.](media/datamod4.png "Visual Studio")

1. At the security warning prompt, uncheck **Ask me for every project in this solution**, and then select **OK**.

    ![A Visual Studio security warning is displayed, and the Ask me for every project in this solution checkbox is unchecked and highlighted.](media/visual-studio-security-warning.png "Visual Studio")

1. Once logged into Visual Studio, right-click the `WideWorldImporters.Web` project in the Solution Explorer, and then select **Publish**.

    ![In the Solution Explorer, the context menu for the WideWorldImporters.Web project is displayed, and Publish is highlighted.](media/visual-studio-project-publish.png "Visual Studio")

1. On the **Publish** dialog, select **Azure** in the Target box, and select **Next**.

    ![In the Publish dialog, Azure is selected and highlighted in the Target box. The Next button is highlighted.](media/updated15.png "Publish API App to Azure")

1. Next, in the **Specific target** box, select **Azure App Service (Windows)**.

    ![In the Publish dialog, Azure App Service (Windows) is selected and highlighted in the Specific Target box. The Next button is highlighted.](media/datamod6.png "Publish API App to Azure")

1. Finally, in the **App Service** box, select your subscription, expand the **hands-on-lab-<inject key="Suffix" enableCopy="false"/>** resource group, and select the **wwi-web-<inject key="Suffix" enableCopy="false"/>** Web App.

    ![On the Visual Studio welcome screen, the Sign in button is highlighted.](media/datamod7.png "Visual Studio")

1. Select **Close**.

    ![In the Publish dialog, The wwi-web-UNIQUEID Web App is selected and highlighted under the hands-on-lab- resource group.](media/close.png "Publish API App to Azure")

1. Back on the Visual Studio Publish page for the `WideWorldImporters.Web` project, select **Publish** to start the process of publishing your Web API to your Azure API App.

    ![The Publish button is highlighted on the Publish page in Visual Studio.](media/wwi-web-publish.png "Publish")

1. When the publish completes, you will see a message on the Visual Studio Output page that the publish succeeded.

    ![The Publish Succeeded message is displayed in the Visual Studio Output pane.](media/visual-studio-output-publish-succeeded.png "Visual Studio")

2. If you select the link of the published web app from the Visual Studio output window, an error page is returned because the database connection strings have not been updated to point to the SQL MI database. You address this in the next task.

    ![An error screen is displayed because the database connection string has not been updated to point to SQL MI in the web app's configuration.](media/web-app-error-screen.png "Web App error")

## Task 2: Update App Service configuration

In this task, you update the WWI gamer info web application to connect to and utilize the SQL MI database.

1. In the Azure portal `https://portal.azure.com`, select **Resource groups** from the Azure services list.

   ![Resource groups is highlighted in the Azure services list.](media/datamod13.png "Azure services")

2. Select the **hands-on-lab-<inject key="Suffix" enableCopy="false"/>** resource group from the list.

   ![Resource groups is selected in the Azure navigation pane, and the "hands-on-lab-< resource group is highlighted.](./media/resource-groups.png "Resource groups list")

3. In the list of resources for your resource group, select the **<inject key="Resource Group Name" enableCopy="false"/>** resource group and then select the **wwi-web-<inject key="Suffix" enableCopy="false"/>** App Service from the list of resources.

   ![The wwi-web-UNIQUEID App Service is highlighted in the list of resource group resources.](media/datamod9.png "Resource group")

4. On the App Service blade, select **Environment variables** **(1)** under Settings on the left-hand side, select **Connection strings** **(2)** and click on **Advanced edit** **(3)**.

   ![The Configuration item is selected under Settings.](media/app-service-configuration-menu.png "Configuration")

6. Replace the **value** of the connection string of `WwiContext` below and replace `your-sqlmi-host-fqdn-value` with the fully qualified domain name for your SQL MI that you copied to a text editor earlier from the Azure Cloud Shell and replace the suffix with value: <inject key="suffix" />.
    
    ``
    Server=tcp:your-sqlmi-host-fqdn-value,1433;Database=WideWorldImportersSuffix;User ID=contosoadmin;Password=IAE5fAijit0w^rDM;Trusted_Connection=False;Encrypt=True;TrustServerCertificate=True;
    ``

7. Repeat **steps 5**, this time for the `WwiReadOnlyContext` connection string.

    ![The save button on the Configuration blade is highlighted.](media/WwiReadOnlyContext1.png "Save")

8. Select **OK**.

9. Select **Apply** and **Confirm** at the top of the Environment variables blade.

    ![The save button on the Configuration blade is highlighted.](media/WwiReadOnlyContextapplay.png "Save")

10. Repeat the **step 5** and **step 6** for **App settings**, Click on **+ Add** from the App settings

11. Add the **Name** and **Value** for `WwiContext` and `WwiReadOnlyContext` and click on **Apply**

    ![The save button on the Configuration blade is highlighted.](media/app-string.png "Save")

    ![The save button on the Configuration blade is highlighted.](media/app-string-1.png "Save")

12. When prompted Your app may restart if you are updating connection strings. Are you sure you want to continue?, select **Confirm**.

    ![The prompt warning that the application will be restarted is displayed, and the Continue button is highlighted.](media/save_changes.png "Restart prompt")

13. Select **Overview** to the left of the Configuration blade to return to the overview blade of your App Service.

    ![Overview is highlighted on the left-hand menu for App Service](media/app-service-overview-menu-item.png "Overview menu item")

14. At this point, selecting the **URL** for the App Service on the Overview blade still results in an error being returned. The error occurs because the SQL Managed Instance has a private IP address in its VNet. To connect an application, you need to configure access to the VNet where the Managed Instance is deployed, which you handle in the next exercise.

    ![An error screen is displayed because the application cannot connect to SQL MI within its private virtual network.](media/web-app-error-screen.png "Web App error")

    > **Congratulations** on completing the Task! Now, it's time to validate it. Here are the steps:
    > - Navigate to the Lab Validation tab, from the upper right corner in the lab guide section.
    > - Hit the Validate button for the corresponding task. If you receive a success message, you have successfully validated the lab. 
    > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
    > - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com.

### **Summary:**

In this exercise, you successfully deployed the WideWorldImporters web application to an Azure App Service and updated the connection strings to point to the SQL Managed Instance (SQL MI) database. The next step involves configuring the App Service to connect to the SQL MI database by ensuring proper network access, as SQL MI uses a private IP address within its own VNet.
