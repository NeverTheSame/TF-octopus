output "vm_ip" {
  value = vsphere_virtual_machine.opensuse-15-6-vm.guest_ip_addresses[0]
  description = "The IP address of the VMware vSphere virtual machine."
}