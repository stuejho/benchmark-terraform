resource "proxmox_vm_qemu" "virtual_machines" {
  count = 1
  name = "benchmark-${count.index + 1}"
  desc = "Storage benchmarking VM"
  target_node = var.proxmox_host
  
  clone = var.vm_template_name
  
  # VM System Settings
  agent = 1
  
  # VM Basic Settings
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  bootdisk = "scsi0"
  
  # VM Network Settings
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }
  
  disk {
    storage = "local-lvm"
    type = "virtio"
    size = "10G"
  }
  
  # VM Cloud-Init Settings
  os_type = "cloud-init"
}