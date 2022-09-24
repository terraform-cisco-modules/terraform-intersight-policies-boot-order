<!-- BEGIN_TF_DOCS -->
# Boot Order Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

### main.tf
```hcl
module "boot_policy" {
  source  = "terraform-cisco-modules/policies-boot-order/intersight"
  version = ">= 1.0.1"

  boot_devices = [
    {
      name        = "KVM-DVD"
      object_type = "boot.VirtualMedia"
      sub_type    = "kvm-mapped-dvd"
    },
    {
      name        = "CIMC-DVD"
      object_type = "boot.VirtualMedia"
      sub_type    = "cimc-mapped-dvd"
    },
    {
      name        = "M2"
      object_type = "boot.LocalDisk"
      slot        = "MSTOR-RAID"
    },
    {
      interface_name = "MGMT-A"
      name           = "PXE"
      object_type    = "boot.Pxe"
      slot           = "MLOM"
    },
    {
      interface_name = "iSCSI-A"
      name           = "iSCSI"
      object_type    = "boot.Iscsi"
      slot           = "MLOM"
    },
    {
      interface_name = "vHBA-A"
      lun            = 0
      name           = "Primary-A"
      object_type    = "boot.San"
      slot           = "MLOM"
      wwpn           = "50:00:00:25:B5:0A:00:01"
    },
    {
      interface_name = "vHBA-B"
      lun            = 0
      name           = "Primary-B"
      object_type    = "boot.San"
      slot           = "MLOM"
      wwpn           = "50:00:00:25:B5:0B:00:01"
    },
    {
      interface_name = "vHBA-A"
      lun            = 0
      name           = "Secondary-A"
      object_type    = "boot.San"
      slot           = "MLOM"
      wwpn           = "50:00:00:25:B5:0A:00:02"
    },
    {
      interface_name = "vHBA-B"
      lun            = 0
      name           = "Secondary-B"
      object_type    = "boot.San"
      slot           = "MLOM"
      wwpn           = "50:00:00:25:B5:0B:00:02"
    },
  ]
  boot_mode          = "Uefi"
  description        = "default Boot Policy."
  enable_secure_boot = false
  name               = "default"
  organization       = "default"
}
```

### variables.tf
```hcl
variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "endpoint" {
  default     = "https://intersight.com"
  description = "Intersight URL."
  type        = string
}

variable "secretkey" {
  description = "Intersight Secret Key."
  sensitive   = true
  type        = string
}
```

### versions.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
}

provider "intersight" {
  apikey    = var.apikey
  endpoint  = var.endpoint
  secretkey = var.secretkey
}
```
<!-- END_TF_DOCS -->