# Define Variables
$VMName = "WinServer2019"
$VMPath = "C:\VMs"
$VMSizeGB = 50
$MemoryGB = 2
$SwitchName = "Internal Network" # Name of the virtual switch

# Start the virtual machine
Start-VM -Name "WinServer2019"

# Set DNS server addresses
$DNSServers = "192.168.1.100"

# Get the network adapter interface
$NetAdapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}

# Set DNS server addresses for IPv4
Set-DnsClientServerAddress -InterfaceIndex $NetAdapter.InterfaceIndex -ServerAddresses $DNSServers -Validate -Verbose

# Install Active Directory Domain Services feature
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Promote the server to a domain controller and create a new forest
Install-ADDSForest 	-DomainName "corp.cinetech.com" 	-SafeModeAdministratorPassword (ConvertTo-SecureString "solarwind1*" -AsPlainText -Force)
-DomainMode "WinThreshold" 	-ForestMode "WinThreshold"
-DatabasePath "C:\Windows\NTDS" 	-LogPath "C:\\Windows\\NTDS"
-SysvolPath "C:\Windows\SYSVOL" `
-Force

# Create Organizational Units (OUs)
New-ADOrganizationalUnit -Name "Sales" -Path "DC=corp.cinetech,DC=com"
New-ADOrganizationalUnit -Name "IT" -Path "DC=corp.cinetech,DC=com"

# Create users
New-ADUser -Name "Ethan Pham" -GivenName "Ethan" -Surname "Pham" -SamAccountName "Ethan" -UserPrincipalName "ethanlepham@gmail.com" -Path "OU=Sales,DC=corp.cinetech,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Cody Blahnik" -GivenName "Cody" -Surname "Blahnik" -SamAccountName "Cody" -UserPrincipalName "cody.blahnik@gmail.com" -Path "OU=IT,DC=corp.cinetech,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword" -AsPlainText -Force) -Enabled $true
