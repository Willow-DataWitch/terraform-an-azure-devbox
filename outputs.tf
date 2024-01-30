
output "vmIP" {
  description = "run this to RDP into server:  mstsc.exe /v:'ip.address.goes.here' /span"
  value       = "${azurerm_windows_virtual_machine.example.public_ip_address}"
}
