terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
}

# Setup provider, variables and outputs
provider "intersight" {
  apikey    = var.intersight_keyid
  secretkey = file(var.intersight_secretkeyfile)
  endpoint  = var.intersight_endpoint
}

variable "intersight_keyid" {}
variable "intersight_secretkeyfile" {}
variable "intersight_endpoint" {
  default = "intersight.com"
}
variable "name" {}

output "moid" {
  value = module.main.moid
}

# This is the module under test
module "main" {
  source = "../.."
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
      name        = "Raid"
      object_type = "boot.LocalDisk"
      slot        = "MRAID"
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
    }
  ]
  boot_mode          = "Uefi"
  description        = "${var.name} Boot Order Policy."
  enable_secure_boot = false
  name               = var.name
  organization       = "terratest"
}
