# Migrating SQL databases to Azure

Tailspin Toys is the developer of several popular online video games. Founded in 2010, the company has experienced exponential growth since releasing the first installment of their most popular game franchise to include online multiplayer gameplay. They have since built upon this success by adding online capabilities to the majority of their game portfolio.

To facilitate online gameplay, they host gaming services on-premises using rented hardware. For each game, their gaming services setup consists of three virtual machines running the gaming software and five game databases hosted on a single SQL Server 2008 R2 instance. In addition to the dedicated gaming VMs and databases, they also host authentication and gateway VMs and databases, which are shared by all their games.

Adding online gameplay has greatly increased popularity of their games, but the rapid increase in demand for their services has made supporting the current setup problematic. Compounding this problem is the release schedule for new versions of their most popular games. They have a target schedule of releasing a new version every 12 - 18 months, which means adding three new VMs and a database server for each new version they release, while also maintaining the services for all previous game versions. This has resulted in rising rental equipment costs, as well as a steadily increasing workload on their already overburdened staff. At its foundation, Tailspin Toys is a game development company, made up primarily of software developers. The few dedicated database and infrastructure resources they do have are struggling to keep up with their ever-increasing workload.

Tailspin Toys is hoping that migrating their services from on-premises to the cloud can help to alleviate some of their infrastructure management issues, while simultaneously helping them to refocus their efforts on delivering business value by releasing new and improved games. They are excited to learn more about how migrating to the cloud can help them improve their overall process, as well as address the concerns and issues they have with their on-premises setup. They are looking for a proof-of-concept (PoC) for migrating the VMs and databases of a single game into the cloud. Their end goal is to migrate their whole service to Azure, so they would also like to better understand what their overall architecture might look after migrating to the cloud.

## Target audience

- Database administrators
- SQL/Database developers
- Application developers

## Abstract

### Workshop

In this workshop, you will learn how to develop a plan for migrating on-premises VMs and SQL Server 2008 R2 databases into a combination of IaaS and PaaS services in Azure. You will perform assessments to reveal any feature parity and compatibility issues between the customer's SQL Server 2008 R2 databases and the managed database offerings in Azure. You will then design a solution for migrating their existing on-premises services, including VMs and databases, into Azure, with minimal or no down-time. Finally, you will demonstrate some of the advanced SQL features available in Azure to improve security and performance in the customer's applications.

At the end of this workshop, you will be better able to design and implement a cloud migration solution for business-critical applications and databases.

### Whiteboard design session

In this whiteboard design session, you will work in a group to develop a plan for migrating on-premises VMs and SQL Server 2008 R2 databases into a combination of IaaS and PaaS services in Azure. You will provide guidance on performing assessments to reveal any feature parity and compatibility issues between the customer's SQL Server 2008 R2 databases and the managed database offerings in Azure. You will then design a solution for migrating their on-premises services, including VMs and databases, into Azure, with minimal or no down-time. Finally, you will provide guidance on how to enable some of the advanced SQL features available in Azure to improve security and performance in the customer's applications.

At the end of this whiteboard design session, you will be better able to design a cloud migration solution for business-critical applications and databases.

### Hands-on lab

In this hands-on lab, you will implement a proof-of-concept (PoC) for migrating an on-premises SQL Server 2008 R2 database into Azure SQL Database Managed Instance (SQL MI). You will perform assessments to reveal any feature parity and compatibility issues between the on-premises SQL Server 2008 R2 database and the managed database offerings in Azure. You will then migrate the customer's on-premises gamer information web application and database into Azure, with minimal to no down-time. Finally, you will enable some of the advanced SQL features available in SQL MI to improve security and performance in the customer's application.

At the end of this hands-on lab, you will be better able to implement a cloud migration solution for business-critical applications and databases.

## Azure services and related products

- Azure SQL Database Managed Instance (SQL MI)
- Azure SQL Database (SQL DB)
- Azure Database Migration Service (DMS)
- Microsoft Data Migration Assistant (DMA)
- Azure App Service
- SQL Server
- SQL Server on VM
- SQL Server Management Studio (SSMS)
- Azure virtual machines
- Visual Studio 2019
- Azure virtual network
- Azure virtual network gateway
- Azure Blob Storage account

## Azure solutions

Data Modernization to Azure

## Related references

- [MCW](https://github.com/Microsoft/MCW)
