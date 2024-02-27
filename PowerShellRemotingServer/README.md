# Azure VM Server configured with PowerShell Remoting Enabled

Okay, this is one of my favorites. It deploys a Windows server, then runs a script to enable PowerShell remoting. That lets you then connect to your VM from the command line and run... whatever. In my case, I'll often install chocolatey and then provision

## Word of Caution about modifying this

The azure_virtual_machine_extension, CustomScriptExtension we are using is very powerful, but doesn't have access to the computer in an end-user-y kind of way. For example, I couldn't find an easy way to access the file system from the perspective of the admin user. That's why I focus this script very narrowly on "How do we turn on command-line access to this computer." Then I handle all further provisioning once I authenticate from the command line as the administrator using either Enter-PSSession or Invoke-Command.

## Security
This sample also included IP-limited access, so random IPs on the internet cannot talk to your computer.

## Provisioning
```powershell
az login; #will prompt you to log into Azure Portal. Resources will be created in that account's selected subscription.
$myIP = '?.?.?.?' ; #Google: What is my IP, put the result there.
$cred = get-credential; #Specify your username and password in the popup
terraform apply -var-file="terraform.tfvars"  -var "vm_username=$($cred.UserName)" -var "vm_password=$($cred.GetNetworkCredential().Password)" -var "allowed_IP=$($myIP)" ;

#connect with this. In the popup, switch to other user and put in the username and password you specified:
mstsc.exe /v:$(terraform output --raw vmIP) /span;

#later...
terraform apply -var-file="terraform.tfvars"  -var "vm_username=$($cred.UserName)" -var "vm_password=$($cred.GetNetworkCredential().Password)" -var "allowed_IP=$($myIP)" --destroy;
```

## Connecting
To connect to the VM after terraform creates it, we use New-PSSession with a session option to skip the Certificate Authority Check (because we are self-signing it). We CANNOT connect without a certificate, but unless we don't check that certificate, the SSL connection fails. And we are using SSL because we don't like the idea of people snooping on our packets. In fact, we only allow the encrypted PS Remoting port, 5986, to be accessed; we don't expose the unencrypted port for PS remoting.

```powershell
# $cred you will have established to create the VM. As a reminder, you entered a username and password into the popup from:
# $cred = Get-Credential;
$sessOptions = New-PSSessionOption -SkipCACheck;
$sess = New-PSSession -ComputerName $(terraform output --raw vmIP) -Credential $cred -UseSSL -SessionOption $sessOptions;

Enter-PSSession $sess; # This will give you PowerShell access to the computer.
# OR, these two allow you to pass in an encrypted string.
# (YO! Cybersecurity folks - would be charming if someone could validate this?)
$securestring = "Your Key or token or whatever, here. Maybe like: terraform output --raw TerraformNameOfASecureAccessToken" | ConvertTo-SecureString -AsPlainText -Force;
Invoke-Command -Session $sess -ArgumentList $securestring -Command {echo $args[0]; echo [System.Management.Automation.PSCredential]::New('unusedUserNameField',$args[0]).GetNetworkCredential().Password ;}
# More likely, you have a script file that uses $args[0] to access that secure string.
Invoke-Command -Session $sess -ArgumentList $securestring -FilePath .\yourScriptHere.ps1;

```