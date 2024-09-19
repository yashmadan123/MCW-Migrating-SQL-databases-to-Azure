# Secure SQL with Microsoft defender

## Overall Estimated Duration: 4 hours

## Overview

In this hands-on lab, you will implement a proof of concept (PoC) for migrating an on-premises SQL Server 2008 R2 database to Azure SQL Managed Instance (SQL MI). You will conduct assessments to identify any feature parity or compatibility issues between the on-premises SQL Server 2008 R2 database and Azure's managed database offerings. Next, you will migrate the customer's on-premises gamer information web application and database to Azure with minimal downtime. Finally, you will enable advanced SQL MI features to enhance the security and performance of the customer's application.

## Objective

## Architecture

In this hands-on lab, you will follow a structured architecture that begins with provisioning an Azure SQL Managed Instance (SQL MI) for migrating an on-premises SQL Server 2008 R2 database. The process starts by performing a database assessment to identify compatibility issues, followed by an online data migration using the Azure Data Migration Service (DMS). You will then configure a secure virtual network, deploy the customer’s web application to Azure, and integrate it with the managed instance. The lab concludes with enabling advanced SQL MI features for optimizing performance and security, offering a complete solution for migrating and modernizing SQL Server workloads in Azure.

## Architecture Diagram:

## Explanation of Components

## Getting Started with the Lab
Once the environment is provisioned, a virtual machine (JumpVM) and lab guide will get loaded in your browser. Use this virtual machine throughout the workshop to perform the lab. You can see the number on the bottom of the Lab guide to switch to different exercises of the lab guide.

## Accessing Your Lab Environment
Once you're ready to dive in, your virtual machine and lab guide will be right at your fingertips within your web browser.

## Virtual Machine & Lab Guide
Your virtual machine is your workhorse throughout the workshop. The lab guide is your roadmap to success.

## Exploring Your Lab Resources
To get a better understanding of your lab resources and credentials, navigate to the Environment Details tab.

## Utilizing the Split Window Feature
For convenience, you can open the lab guide in a separate window by selecting the Split Window button from the Top right corner.

## Managing Your Virtual Machine
Feel free to start, stop, or restart your virtual machine as needed from the Resources tab. Your experience is in your hands!

## Login to Azure Portal
1. In the JumpVM, click on Azure portal shortcut of Microsoft Edge browser which is created on desktop.

   ![](../media/azureportal_icon1.png "Lab Environment")
   
1. On **Sign into Microsoft Azure** tab you will see login screen, in that enter following email/username and then click on **Next**. 
   * Email/Username: <inject key="AzureAdUserEmail"></inject>
   
     ![](../media/image7.png "Enter Email")
     
1. Now enter the following password and click on **Sign in**.
   * Password: <inject key="AzureAdUserPassword"></inject>
   
     ![](../media/image8.png "Enter Password")
     
1. If you see the pop-up **Action Required**, click **Ask Later**.

     ![](../media/asklater.png "Action required window")
     
    > If you are getting popup **save password**, then select **Save & Turn on** option.
       
1. If you see the pop-up **Stay Signed in?**, click **No**.

1. If you see the pop-up **You have free Azure Advisor recommendations!**, close the window to continue the lab.

1. If a **Welcome to Microsoft Azure** popup window appears, click **Maybe Later** to skip the tour.

1. Now you will see Azure Portal Dashboard, click on **Resource groups** from the Navigate panel to see the resource groups.

     ![](../media/select-rg.png "Resource groups")

1. Confirm you have a resource group **openai-<inject key="Deployment-id" enableCopy="false"/>** present as shown in the below screenshot. You need to use the **openai-<inject key="Deployment-id" enableCopy="false"/>** resource group throughout the entire process of lab execution.

     ![](../media/rg.png "Resource groups")
   
1. Use **Next** button from lower right corner to move on to the next page.

   ![](../media/next1.png "Resource groups")

In this hands-on-lab, you will learn how Azure OpenAI models can generate and refine code and use the DALL-E model to create images from text prompts, showcasing AI's versatility in coding and creativity.

## Support Contact
 
The CloudLabs support team is available 24/7, 365 days a year, via email and live chat to ensure seamless assistance at any time. We offer dedicated support channels tailored specifically for both learners and instructors, ensuring that all your needs are promptly and efficiently addressed.

Learner Support Contacts:

- Email Support: labs-support@spektrasystems.com
- Live Chat Support: https://cloudlabs.ai/labs-support

### Happy learning !
