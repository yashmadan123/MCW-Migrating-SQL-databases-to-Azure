## Exercise 4: Integrate App Service with the virtual network

Duration: 15 minutes

In this exercise, you integrate the WWI App Service with the virtual network created during the Before the hands-on lab exercises. The ARM template created a Gateway subnet on the VNet, as well as a Virtual Network Gateway. Both resources are required to integrate App Service and connect to SQL MI.

### Task 1: Configure VNet integration with App Services

In this task, you add the networking configuration to your App Service to enable communication with resources in the VNet.

1. In the Azure portal `https://portal.azure.com`, select **Resource groups** from the left-hand menu, select the **<inject key="Resource Group Name" enableCopy="false"/>** resource group and then select the **wwi-web-<inject key="Suffix" />** App Service from the list of resources.

   ![The wwi-web-UNIQUEID App Service is highlighted in the list of resource group resources.](media/datamod9.png "Resource group")

2. On the App Service blade, select **Networking** from the left-hand menu.

   ![On the App Service blade, Networking is selected in the left-hand menu, and Click here to configure is highlighted under VNet Integration.](media/web-app-network.png "App Service")

3. On the **Networking** page, click on the **Not Configured** next to **Virtual network integration** under **Outbound Traffic**.

   ![Add VNet is highlighted on the VNet Configuration blade.](media/web-app-network-output.png "App Service")

4. Now click on **Add virtual network integration** under **Virtual Network Integration**.

   ![Add VNet is highlighted on the VNet Configuration blade.](media/datamod10.png "App Service")

5. On the Network Feature Status dialog, enter the following and click **Connect**.

   - **Virtual Network**: Select the `sqlmi-vnet`.
   - **Subnet**: Select any existing subnet from the drop-down menu.

      ![Add VNet is highlighted on the VNet Configuration blade.](media/vnet.png "Vnet")

6. Within a few minutes, the VNet is added, and your App Service is restarted to apply the changes. Select Refresh to confirm whether the Vnet is connected or not.

   ![The details of the VNet Configuration are displayed. The Certificate Status, Certificates in sync, is highlighted.](media/datamod11.png "App Service")

   > **Note**: If you receive a message adding the Virtual Network to the Web App fails, select **Disconnect** on the VNet Configuration blade, and repeat steps 3 - 5 above.

### Task 2: Open the web application

In this task, you verify your web application now loads, and you can see the home page of the web app.

1. Select **Overview** in the left-hand menu of your App Service and select the **URL** of your App service to launch the website. This link opens the URL in a browser window.

   ![The App service URL is highlighted.](media/app-service-url.png "App service URL")

2. Verify that the website and data are loaded correctly. The page should look similar to the following:

   ![Screenshot of the WideWorldImporters Operations Web App.](media/wwi-web-app.png "WideWorldImporters Web")

   > **Note**: It can often take several minutes for the network configuration to be reflected in the web app. If you get an error screen, try selecting Refresh a few times in the browser window. If that does not work, try selecting **Restart** on the Azure Web App's toolbar.

3. Congratulations, you successfully connected your application to the new SQL MI database.

4. Please note down the Managed database name **WideWorldImporters<inject key="Suffix" enableCopy="false"/>** as you need this database name for upcoming lab.

 
>**Congratulations** on completing the Task! Now, it's time to validate it. Here are the steps:
 > - Navigate to the Lab Validation tab, from the upper right corner in the lab guide section.
 > - Hit the Validate button for the corresponding task. If you receive a success message, you have successfully validated the lab. 
 > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
 > - If you need any assistance, please contact us at labs-support@spektrasystems.com.

   > **Importent**: Please make a note of the managed database named **WideWorldImporters<inject key="Suffix" enableCopy="false"/>** that was created in this lab, as you will require this specific database name for Lab 2, **Data Modernization: Implementing Data Discovery & Classification**.
