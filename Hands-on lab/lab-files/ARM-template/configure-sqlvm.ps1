# Disable Internet Explorer Enhanced Security Configuration
function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
    Stop-Process -Name Explorer -Force
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}

# Disable IE ESC
Disable-InternetExplorerESC

# Enable SQL Server ports on the Windows firewall
function Add-SqlFirewallRule {
    $fwPolicy = $null
    $fwPolicy = New-Object -ComObject HNetCfg.FWPolicy2

    $NewRule = $null
    $NewRule = New-Object -ComObject HNetCfg.FWRule

    $NewRule.Name = "SqlServer"
    # TCP
    $NewRule.Protocol = 6
    $NewRule.LocalPorts = 1433
    $NewRule.Enabled = $True
    $NewRule.Grouping = "SQL Server"
    # ALL
    $NewRule.Profiles = 7
    # ALLOW
    $NewRule.Action = 1
    # Add the new rule
    $fwPolicy.Rules.Add($NewRule)
}

Add-SqlFirewallRule

# Download the database backup file from the GitHub repo
Invoke-WebRequest 'https://raw.githubusercontent.com/microsoft/MCW-Migrating-SQL-databases-to-Azure/master/Hands-on%20lab/lab-files/Database/WideWorldImporters.bak' -OutFile 'C:\WideWorldImporters.bak'

# Download and install Data Mirgation Assistant
Invoke-WebRequest 'https://download.microsoft.com/download/C/6/3/C63D8695-CEF2-43C3-AF0A-4989507E429B/DataMigrationAssistant.msi' -OutFile 'C:\DataMigrationAssistant.msi'
Start-Process -file 'C:\DataMigrationAssistant.msi' -arg '/qn /l*v C:\dma_install.txt' -passthru | wait-process

#Add snapins
Add-PSSnapin SqlServerProviderSnapin100 -ErrorAction SilentlyContinue
Add-PSSnapin SqlServerCmdletSnapin100 -ErrorAction SilentlyContinue

# Define database variables
$ServerName = 'SQLSERVER2008'
$DatabaseName = 'WideWorldImporters'

# Restore the WideWorldImporters database using the downloaded backup file
function Restore-SqlDatabase {
    $FilePath = 'C:\'
    $bakFileName = $FilePath + $DatabaseName +'.bak'

    $UseMasterCmd = "USE [master];"
    Invoke-Sqlcmd $UseMasterCmd -QueryTimeout 3600 -ServerInstance $ServerName

    $RestoreCmd = "RESTORE DATABASE [$DatabaseName] FROM DISK ='$bakFileName';"
    Invoke-Sqlcmd $RestoreCmd -QueryTimeout 3600 -ServerInstance $ServerName
}

function Enable-ServiceBroker {
    $UseMasterCmd = "USE [master];"
    Invoke-Sqlcmd $UseMasterCmd -QueryTimeout 3600 -ServerInstance $ServerName

    $SetBrokerCmd = "ALTER DATABASE ['$DatabaseName'] SET ENABLE_BROKER WITH ROLLBACK immediate;"
    Invoke-Sqlcmd $SetBrokerCmd -QueryTimeout 3600 -ServerInstance $ServerName
}

function Config-SqlDatabaseLogin {
    $UserName = 'WorkshopUser'
    $Password = 'Password.1234567890'

    $CreateLoginCmd = "CREATE LOGIN $UserName WITH PASSWORD = N'$Password';"
    Invoke-Sqlcmd $CreateLoginCmd -QueryTimeout 3600 -ServerInstance $ServerName

    $AddRoleCmd = "EXEC sp_addsrvrolemember @loginame = N'$UserName', @rolename = N'sysadmin';"      
    Invoke-Sqlcmd $AddRoleCmd -QueryTimeout 3600 -ServerInstance $ServerName

    $UseDatabaseCmd = "USE [$DatabaseName];"
    Invoke-Sqlcmd $UseDatabaseCmd -QueryTimeout 3600 -ServerInstance $ServerName

    $AssignUserCmd = "IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = '$UserName')
                        BEGIN
                            CREATE USER [$UserName] FOR LOGIN [$UserName]
                            EXEC sp_addrolemember N'db_datareader', N'$UserName'
                        END;
                      GO"
    Invoke-Sqlcmd $AssignUserCmd -QueryTimeout 3600 -ServerInstance $ServerName
}

Restore-SqlDatabase
Start-Sleep -m 30000
Enable-ServiceBroker
Config-SqlDatabaseLogin
