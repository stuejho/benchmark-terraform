variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
}

variable "proxmox_host" {
  description = "Proxmox host to deploy VMs to"
  type        = string
}

variable "vm_template_name" {
  description = "Name of the VM template to clone"
  type        = string
}

variable "ci_user" {
  description = "Username for the cloud-init user"
  type        = string
}

variable "ci_password" {
  description = "Password for the cloud-init user"
  type        = string
}

variable "physical_disks" {
  description = "Map of physical disks to device IDs"
  type        = map(string)
}
