output "public_ip_address" {
  value = azurerm_linux_virtual_machine.cc_tf_vm.public_ip_address
}

output "rg_name" {
  value = azurerm_resource_group.cc_tf_rg.name
}
