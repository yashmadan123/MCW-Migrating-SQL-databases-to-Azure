## Exercise 4: Integrate App Service with the virtual network

Duration: 15 minutes

In this exercise, you integrate the WWI App Service with the virtual network created during the Before the hands-on lab exercises. The ARM template created a Gateway subnet on the VNet, as well as a Virtual Network Gateway. Both of these resources are required to integrate App Service and connect to SQL MI.

### Task 1: Configure VNet integration with App Services

In this task, you add the networking configuration to your App Service to enable communication with resources in the VNet.

1. In the Azure portal `https://portal.azure.com`, select **Resource groups** from the left-hand menu, select the **hands-on-lab-SUFFIX** resource group, and then select the **wwi-web-UNIQUEID** App Service from the list of resources.

   ![The wwi-web-UNIQUEID App Service is highlighted in the list of resource group resources.](media/rg-app-service.png "Resource group")

2. On the App Service blade, select **Networking** from the left-hand menu and then select **Click here to configure** under **VNet Integration**.

   ![On the App Service blade, Networking is selected in the left-hand menu, and Click here to configure is highlighted under VNet Integration.](media/app-service-networking.png "App Service")

3. Select **Add VNet** on the VNet Configuration blade.

   ![Add VNet is highlighted on the VNet Configuration blade.](media/app-service-vnet-configuration.png "App Service")

4. On the Network Feature Status dialog, enter the following:

   - **Virtual Network**: Select the vnet-sqlmi--cus.
   - **Subnet**: Select any existing subnet.
  > **Note**: If you are not able to select any existing subnet then follow the below steps.
   - Select the create new subnet option and enter name as WebappsubnetSUFFIX. Select Virtual Network address block from the drop down list. In the subnet address block enter new address block 10.0.xx.0/23 for the subnet, Make sure it is not overlapping other subnet's address.
  > **Note**: If the address space is overlapping with other subnets you may need to changes the address space.

   ![The values specified above are entered into the Network Feature Status dialog.](https://raw.githubusercontent.com/CloudLabs-MCW/MCW-Migrating-SQL-databases-to-Azure/fix/Hands-on%20lab/media/newvnet.png "Network Feature Status configuration")

5. Within a few minutes, the VNet is added, and your App Service is restarted to apply the changes. Select refresh to confirm that the Vnet is connected or not.

   ![The details of the VNet Configuration are displayed. The Certificate Status, Certificates in sync, is highlighted.](media/app-service-vnet-details.png "App Service")

   > **Note**
   >
   > If you receive a message adding the Virtual Network to Web App failed, select **Disconnect** on the VNet Configuration blade, and repeat steps 3 - 5 above.

### Task 2: Open the web application

In this task, you verify your web application now loads, and you can see the home page of the web app.

1. Select **Overview** in the left-hand menu of your App Service, and select the **URL** of your App service to launch the website. This link opens the URL in a browser window.

   ![The App service URL is highlighted.](media/app-service-url.png "App service URL")

2. Verify that the web site and data are loaded correctly. The page should look similar to the following:

   ![Screenshot of the WideWorldImporters Operations Web App.](media/wwi-web-app.png "WideWorldImporters Web")

   > **Note**
   >
   > It can often take several minutes for the network configuration to be reflected in the web app. If you get an error screen, try selecting Refresh a few times in the browser window. If that does not work, try selecting **Restart** on the Azure Web App's toolbar.

3. Congratulations, you successfully connected your application to the new SQL MI database.
