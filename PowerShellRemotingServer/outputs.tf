
output "vmIP" {
  description = "run this to RDP into server:  mstsc.exe /v:$(terraform output --raw vmIP) /span"
  value       = "${azurerm_windows_virtual_machine.example.public_ip_address}"
}
