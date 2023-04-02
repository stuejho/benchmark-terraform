# Terraform Benchmark Infrastructure

## Template VM Setup

Ideally, all of these steps will be performed on the Proxmox cluster. However,
if necessary, perform steps up to installing the `qemu-guest-agent`, then upload
the image to Proxmox (e.g., as an ISO/IMG). Then, make note of the path to the ISO/
IMG (e.g., `/var/lib/vz/template/iso/focal-server-cloudimg-amd64-qemu-guest-agent.img`
for later steps.

1. Download a base image.
  ```
  wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
  ```
1. Install `qemu-guest-agent` into the downloaded image.
  ```
  sudo apt update -y
  sudo apt install libguestfs-tools -y
  sudo virt-customize -a focal-server-cloudimg-amd64.img --install qemu-guest-agent
  ```
  NOTE: On WSL, you may need to execute `sudo apt install linux-image-generic` if
  there is not a kernel.
1. Create a Proxmox virtual machine template
  ```
  # Create the VM
  qm create 9000 --name "ubuntu-2004-cloudinit-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0

  # Import disk for VM
  qm importdisk 9000 /var/lib/vz/template/iso/focal-server-cloudimg-amd64-qemu-guest-agent.img local-lvm

  # Attach disk
  qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0

  # Create virtual CD rom and attach to VM
  qm set 9000 --ide2 local-lvm:cloudinit

  # Allow us to boot from cloud-init drive directly
  qm set 9000 --boot c --bootdisk scsi0

  # Enable serial console (to make sure we can see the terminal)
  qm set 9000 --serial0 socket --vga serial0

  # Enable communication with the QEMU Guest Agent
  qm set 9000 --agent enabled=1

  # Turn the VM into a template
 qm template 9000
  ```

## Terraform Setup

1. Set up a Proxmox cluster.
1. Install Terraform on your machine.
1. Log in to the Proxmox cluster/host and launch a shell.
  1. Create a new role for the future Terraform user.
  1. Create the user `terraform-prov@pve`
  1. Add the TERRAFORM-PROV role to the terraform-prov user
  1. Generate an API key
  ```
  pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"
  pveum user add terraform-prov@pve --password <password>
  pveum aclmod / -user terraform-prov@pve -role TerraformProv
  pveum user token add terraform-prov@pve tf_api_token –privsep=0
  ```
1. Set up your Terraform configuration files.
  1. `main.tf` - defines resource configuration (e.g., VM setup)
  1. `providers.tf` - defines provider(s)
  1. `variables.tf` - defines variables used throughout the Terraform configuration
  1. `terraform.tfvars` - should be modified to specify values for variables; secrets should NOT be committed
1. Run `terraform init` to make sure provider plugins are installed.
1. Run `terraform plan` to see if your configuration is valid/things are ready to go.
1. Run `terraform apply` to execute the plan.
