terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  # Specify path to /api2/json
  pm_api_url = var.proxmox_api_url

  # Generate the following in Proxmox and set them in credentials.tfvars
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret

  # Leave insecure unless SSL is sorted out
  pm_tls_insecure = true
  
  pm_debug = true
}