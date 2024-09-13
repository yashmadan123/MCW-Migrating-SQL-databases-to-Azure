## Abstract and learning objectives

In this hands-on lab, you implement a proof-of-concept (PoC) for migrating an on-premises SQL Server 2008 R2 database into Azure SQL Managed Instance (SQL MI). You perform assessments to reveal any feature parity and compatibility issues between the on-premises SQL Server 2008 R2 database and Azure's managed database offerings. You then migrate the customer's on-premises gamer information web application and database into Azure, with minimal down-time. Finally, you enable some of the advanced SQL features in SQL MI to improve security and performance in the customer's application.

At the end of this hands-on lab, you will be better able to implement a cloud migration solution for business-critical applications and databases.

## Overview

Wide World Importers (WWI) is the developer of the popular Tailspin Toys brand of online video games. Founded in 2010, the company has experienced exponential growth since releasing the first installment of their most popular game franchise to include online multiplayer gameplay. They have since built upon this success by adding online capabilities to the majority of their game portfolio.

Adding online gameplay has dramatically increased their games' popularity, but the rapid increase in demand for their services has made supporting the current setup problematic. To facilitate online gameplay, they host gaming services on-premises using rented hardware. For each game, their gaming services setup consists of three virtual machines running the gaming software and five game databases hosted on a single SQL Server 2008 R2 instance. In addition to the dedicated gaming VMs and databases, they also host shared authentication and gateway VMs and databases. At its foundation, WWI is a game development company made up primarily of software developers. The few dedicated database and infrastructure resources they do have are struggling to keep up with their ever-increasing workload.

WWI is excited to learn more about how migrating to the cloud can improve its overall processes and address the concerns and issues with its on-premises setup. They are looking for a proof-of-concept (PoC) for migrating their gaming VMs and databases into the cloud. With an end goal of migrating their entire service to Azure, the WWI engineering team is also interested in understanding better what their overall architecture will look like in the cloud. They maintain their gamer information database, `WideWorldImporters`, on an on-premises SQL Server 2008 R2 database. This system is used by gamers to update their profiles, view leader boards, purchase game add-ons, and more. Since this system helps drive revenue, it is considered a business-critical application and needs to be highly available. They are aware that SQL Server 2008 R2 is beyond the end of support and are looking at options for migrating this database into Azure. They have read about some of the advanced security and performance tuning options that are available only in Azure and would prefer to migrate the database into a platform-as-a-service (PaaS) offering, if possible. WWI uses the Service Broker feature of SQL Server for messaging within its `WideWorldImporters` database. This functionality enables several critical processes, and they cannot afford to lose these capabilities when migrating their operations database to the cloud. They have also stated that, at this time, they do not have the resources to rearchitect the solution to use an alternative message broker.

## Solution architecture

Below is a diagram of the solution architecture you implement in this lab. Please study this carefully to understand the whole of the solution as you are working on the various components.

![This solution diagram includes a virtual network containing SQL MI in an isolated subnet, along with a JumpBox VM and Database Migration Service in a management subnet. The MI Subnet displays both the primary managed instance and a read-only replica, which is accessed by reports from the web app. The web app connects to SQL MI via a subnet gateway and point-to-site VPN. The web app is published to App Services using Visual Studio 2019. Online data migration is conducted from the on-premises SQL Server to SQL MI using the Azure Database Migration Service, which reads backup files from an SMB network share.](./media/preferred-solution-architecture.png "Preferred Solution diagram")

The solution begins with using the Microsoft Data Migration Assistant (DMA) to perform assessments of feature parity and compatibility of the on-premises SQL Server 2008 R2 database. DMA assessments are performed against Azure SQL Database (Azure SQL DB) and Azure SQL Managed Instance (SQL MI). The goal is to migrate the `WideWorldImporters` database into an Azure PaaS offering with minimal or no application changes. After completing the assessments and reviewing the findings, the SQL Server 2008 R2 database is migrated into SQL MI using the Azure Database Migration Service's online data migration option. The online data migration feature of DMS allows the database migration to happen with minimal downtime, using a backup and transaction logs stored in an SMB network share.

The web app is deployed to an Azure App Service Web App using Visual Studio 2019. Once the migrated database's cutover is complete, VNet integration for the `WideWorldImporters` web application is configured. This integration allows the web app to connect to the SQL MI VNet through a virtual network gateway using a point-to-site VPN. The web app's connection strings are updated to point to the new SQL MI database.

In SQL MI, several features of Azure SQL are examined. Azure Defender for SQL is enabled, and Data Discovery and Classification is used to understand better the data and potential compliance issues with data in the database. The Azure Defender for SQL Vulnerability Assessment tool is used to identify potential security vulnerabilities and problems in the database. Those issues listed in the assessment report are used to mitigate one finding by enabling Transparent Data Encryption in the database. Dynamic Data Masking (DDM) is used to prevent sensitive data from appearing when querying the database. Finally, Read Scale-out is used to point reports on WWI's web app to a read-only secondary, allowing reporting to occur without impacting the primary database's performance.

# **Getting Started with Your MCW-Migrating-SQL-databases-to-Azure Workshop**
 
Welcome to your MCW-Migrating-SQL-databases-to-Azure workshop! We've prepared a seamless environment for you to explore and learn about Azure services. Let's begin by making the most of this experience:
 
## **Accessing Your Lab Environment**
 
Once you're ready to dive in, your virtual machine and **Lab Guide** will be right at your fingertips within your web browser.

   ![](./media/GS6.png)

### **Virtual Machine & Lab Guide**
 
Your virtual machine is your workhorse throughout the workshop. The lab guide is your roadmap to success.
 
## **Exploring Your Lab Resources**
 
To get a better understanding of your lab resources and credentials, navigate to the **Environment Details** tab.

   ![](./media/GS7.png)
 
## **Utilizing the Split Window Feature**
 
For convenience, you can open the lab guide in a separate window by selecting the **Split Window** button from the Top right corner.
 
   ![](./media/GS8.png)
 
## **Managing Your Virtual Machine**
 
Feel free to start, stop, or restart your virtual machine as needed from the **Resources** tab. Your experience is in your hands!
 
  ![](./media/GS5.png)
 
## **Let's Get Started with Azure Portal**
 
1. On your virtual machine, click on the Azure Portal icon as shown below:
 
    ![](./media/GS1.png)
 
2. You'll see the **Sign into Microsoft Azure** tab. Here, enter your credentials:
 
   - **Email/Username:** <inject key="AzureAdUserEmail"></inject>
 
      ![](./media/GS2.png "Enter Email")
 
3. Next, provide your password:
 
   - **Password:** <inject key="AzureAdUserPassword"></inject>
 
      ![](./media/GS3.png "Enter Password")
 
4. If you see the pop-up **Stay Signed in?**, click **No**.

   ![](./media/GS9.png)

5. If you see the pop-up **You have free Azure Advisor recommendations!**, close the window to continue the lab.

6. If a **Welcome to Microsoft Azure** popup window appears, click **Maybe Later** to skip the tour.
   
7. Now, click on the **Next** from the lower right corner to move to the next page.

   ![](./media/GS4.png)
 
Now you're all set to explore the powerful world of technology. Feel free to reach out if you have any questions along the way. Enjoy your workshop!
