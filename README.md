# terraform-an-azure-devbox

Creates all the Azure resources you need to stand up a VM in the cloud for development or demo purposes.

## What gets created

Per: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview

- Resource Group
- Virtual Network
- Subnet
- Public IP
- Network Interface
- Virtual Machine

## WARNING

This creates a VM in your azure subscription with a public IP. No guarantees are made about the security of any of this. Also there will likely be Azure charges associated with the resources this creates. Use at your own financial and security risk.

### Licensing

No effort has been made to prepare this solution for a production licensing scenario.

## Usage

- Deploy the Azure VM by running the following from within this cloned repository (it will prompt you for and admin username and password for the VM you are creating):

```powershell
az login; #will prompt you to log into Azure Portal. Resources will be created in that account's selected subscription.
terraform init;

terraform apply -var-file="terraform.tfvars"; #This is the SQL SERVER 2019 Developer Edition version. In fact, you don't even need to specify the default tfvars file, so this is equivalent: terraform apply;

#terraform apply -var-file="terraform_Alternate_Windows11.tfvars"; #Run this line instead for a plain windows 11 VM.
```

- Setting up the VM takes a few minutes, and terraform will keep you apprised of its progress.
- Then copy, paste, and run the mstsc.exe command in the output to connect. Switch user in the RDP window that pops up to enter the username and passwordyou specified earlier.
- Alternatively, go to portal.azure.com, find the newly created resource group and its VM, and on the VM overview there should be a spot to connect to the VM via RDP to its public IP. Supply the username and password you specified.
- When you are done, and you have transferred any files you need AWAY from the virtual machine, clean up!

```powershell
terraform destroy;
```

- Dropping resources should halt further Azure charges, and you can double check that in portal.azure.com > Resource Groups and portal.azure.com > Cost Management. 
- Remember it takes about 24-48 hours for charges to appear in cost management, though changes to resources are visible after refreshing your browser.

### Alternate usage with PowerShell Get-Credential popup

This version lets you specify the username and password in a popup.

```powershell
$cred = get-credential; #Specify your username and password in the popup
terraform apply -var-file="terraform.tfvars"  -var "vm_username=$($cred.UserName)" -var "vm_password=$($cred.GetNetworkCredential().Password)";
```

## Configuration

- You can mess with the variables:
  - In the file .\terraform.tfvars
  - Or at the command line, thus: ```-var "rg_name=ExampleRG"```
- By default, this is set up to use a fairly inexpensive server with 2 cores and 8 GB of RAM in the EastUS region of Azure. At time of writing, this whole setup runs about $0.10-$0.20 per hour (your rates may vary).
  - Comparing VM Size options: [https://azureprice.net/?sortField=windowsPrice&sortOrder=true](https://azureprice.net/?sortField=windowsPrice&sortOrder=true)
- By default, this is set up to use a Developer edition of SQL Server on Windows Server 2022.
  - To find this image in the Azure Marketplace: [https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoftsqlserver.sql2019-ws2022?tab=PlansAndPrice](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoftsqlserver.sql2019-ws2022?tab=PlansAndPrice)
  - Or on az-vm-image.info: [https://az-vm-image.info/?cmd=--all+--offer+sql2019-ws2022+--sku+sqldev-gen2](https://az-vm-image.info/?cmd=--all+--offer+sql2019-ws2022+--sku+sqldev-gen2)

## Prerequisites

You will need an administrator account in Azure (go to portal.azure.com to confirm that you have one or to create one), and install the terraform and Azure CLI utilities. I like getting them from chocolatey.org: 

```powershell
choco install terraform -y;
choco install azure-cli -y;
```

## Links
Inspired in part by:
https://adamtheautomator.com/terraform-azure-vm/
