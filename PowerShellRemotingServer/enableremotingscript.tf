# run a script to enable PS Remoting and open necessary ports in the windows vm. It's long and ugly, but as short as I could make it.
# I have it here as one big string because we need to tell the VM what its public IP is so it can self-sign a certificate.
# 
resource "azurerm_virtual_machine_extension" "run_enable_ps_remoting" {
    name                    = "vm_ext_enablepsremote"
    virtual_machine_id      = azurerm_windows_virtual_machine.example.id
    publisher               = "Microsoft.Compute"
    type                    = "CustomScriptExtension"
    type_handler_version    = "1.9"

    protected_settings = <<SETTINGS
        {
            "commandToExecute": "powershell -Command \"Start-Transcript; Enable-PSRemoting -Force; $DNSName = '${azurerm_windows_virtual_machine.example.public_ip_address}'; echo $DNSName; $cert = New-SelfSignedCertificate -DNSName $DNSName -CertStoreLocation Cert:\\LocalMachine\\My; $thumbprint = $cert.Thumbprint; echo $thumbprint; $cmd = 'winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=' + [char]34 + $DNSName + [char]34 + '; CertificateThumbprint=' + [char]34 + $thumbprint + [char]34 + '}'; echo $cmd; cmd.exe \/C $cmd | Write-Output ; Set-NetFirewallRule -Name \"WINRM-HTTP-In-TCP-PUBLIC\" -RemoteAddress Any; Stop-Transcript;\""
        }
    SETTINGS
}