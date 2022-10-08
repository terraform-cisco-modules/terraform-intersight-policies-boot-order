<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)
[![Tests](https://github.com/terraform-cisco-modules/terraform-intersight-policies-boot-order/actions/workflows/terratest.yml/badge.svg)](https://github.com/terraform-cisco-modules/terraform-intersight-policies-boot-order/actions/workflows/terratest.yml)

# Terraform Intersight Policies - Boot Order
Manages Intersight Boot Order Policies

Location in GUI:
`Policies` » `Create Policy` » `Boot Order`

## Easy IMM

[*Easy IMM - Comprehensive Example*](https://github.com/terraform-cisco-modules/easy-imm-comprehensive-example) - A comprehensive example for policies, pools, and profiles.

## Example

### main.tf
```hcl
module "boot_order" {
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

### provider.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
  required_version = ">=1.3.0"
}

provider "intersight" {
  apikey    = var.apikey
  endpoint  = var.endpoint
  secretkey = fileexists(var.secretkeyfile) ? file(var.secretkeyfile) : var.secretkey
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
  default     = ""
  description = "Intersight Secret Key Content."
  sensitive   = true
  type        = string
}

variable "secretkeyfile" {
  default     = "blah.txt"
  description = "Intersight Secret Key File Location."
  sensitive   = true
  type        = string
}
```

## Environment Variables

### Terraform Cloud/Enterprise - Workspace Variables
- Add variable apikey with the value of [your-api-key]
- Add variable secretkey with the value of [your-secret-file-content]

### Linux and Windows
```bash
export TF_VAR_apikey="<your-api-key>"
export TF_VAR_secretkeyfile="<secret-key-file-location>"
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.32 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.32 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apikey"></a> [apikey](#input\_apikey) | Intersight API Key. | `string` | n/a | yes |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | Intersight URL. | `string` | `"https://intersight.com"` | no |
| <a name="input_secretkey"></a> [secretkey](#input\_secretkey) | Intersight Secret Key. | `string` | n/a | yes |
| <a name="input_boot_devices"></a> [boot\_devices](#input\_boot\_devices) | List of Boot Devices and their Attributes to Assign to the Boot Policy.<br>* Bootloader Variables - These will be used when the system is running in Uefi Boot Mode.<br>  - bootloader\_description - Description to Assign to Bootloader when running in Uefi Boot Mode.<br>  - bootloader\_name - Typically this should be "BOOTX64.EFI".<br>  - bootloader\_path - Typically this should be "\\EFI\\BOOT\\".<br>    * The Following Boot Order Types utilize Bootloader Configuration:<br>      - boot.Iscsi<br>      - boot.LocalDisk<br>      - boot.Nvme<br>      - boot.PchStorage<br>      - boot.San<br>      - boot.SdCard<br>* enabled: (default is true) - Specifies if the boot device is enabled or disabled.<br>* interface\_name - The name of the underlying virtual ethernet interface used by the Boot Device.<br>  - The Following Boot Order Types utilize the InterfaceName Attribute:<br>    * boot.Iscsi<br>    * boot.Pxe<br>    * boot.San<br>* interface\_source: (optional) - Used only by boot.Pxe.  Lists the supported Interface Source for PXE device.<br>  - name: (default) - Use interface name to select virtual ethernet interface.<br>  - mac - Use MAC address to select virtual ethernet interface.<br>  - port - Use port to select virtual ethernet interface.<br>* ip\_type - Used only by boot.Pxe.  The IP Address family type to use during the PXE Boot process.<br>  - None - Default value if ip\_type is not specified.<br>  - IPv4 - The IPv4 address family type.<br>  - IPv6 - The IPv6 address family type.<br>* Lun - Default is 0.  The Logical Unit Number (LUN) of the device.<br>  - The Following Boot Order Types utilize the Lun Attribute:<br>    * boot.PchStorage<br>    * boot.San<br>    * boot.SdCard<br>* mac\_address - Used only by boot.Pxe.  The MAC Address of the underlying virtual ethernet interface used by the PXE boot device.<br>* name: (required) - Name to Assign to the boot\_device.<br>* object\_type: (required) - The Boot Order Type to Assign to the Boot Device.  Allowed Values are:<br>  - boot.Iscsi<br>  - boot.LocalCdd<br>  - boot.LocalDisk<br>  - boot.Nvme<br>  - boot.PchStorage<br>  - boot.Pxe<br>  - boot.San<br>  - boot.SdCard<br>  - boot.UefiShell<br>  - boot.Usb<br>  - boot.VirtualMedia<br>* Port -  Used by iSCSI and PXE.<br>    * boot.Iscsi - Default is 0.  Port ID of the ISCSI boot device.  Supported values are (0-255).<br>    * boot.Pxe - Default is -1.  The Port ID of the adapter on which the underlying virtual ethernet interface is present. If no port is specified, the default value is -1. Supported values are -1 to 255.<br>* slot - The PCIe slot ID of the adapter on which the underlying virtual ethernet interface is present.<br>  - The Following Boot Order Types utilize the slot Attribute:<br>    * boot.Iscsi - Supported values are (1-255, MLOM, L, L1, L2, OCP).<br>    * boot.LocalDisk - Supported values are (1-205, M, HBA, SAS, RAID, MRAID, MRAID1, MRAID2, MSTOR-RAID).  Supported values for FI-attached servers are (1-205, MRAID, FMEZZ1-SAS, MRAID1 , MRAID2, MSTOR-RAID, MSTOR-RAID-1, MSTOR-RAID-2).<br>    * boot.Pxe - Supported values are (1-255, MLOM , L, L1, L2, OCP).<br>    * boot.San - Supported values are (1-255, MLOM, L1, L2).<br>* sub\_type - The sub\_type for the selected device type.<br>  - The Following Boot Order Types utilize the sub\_type Attribute:<br>    * boot.SdCard - Below are the Supported sub\_type Values:<br>      - None - No sub type for SD card boot device.<br>      - flex-util - Use of FlexUtil (microSD) card as sub type for SD card boot device.<br>      - flex-flash - Use of FlexFlash (SD) card as sub type for SD card boot device.<br>      - SDCARD - Use of SD card as sub type for the SD Card boot device.<br>    * boot.Usb - Below are the Supported sub\_type Values:<br>      - None - No sub type for USB boot device.<br>      - usb-cd - Use of Compact Disk (CD) as sub-type for the USB boot device.<br>      - usb-fdd - Use of Floppy Disk Drive (FDD) as sub-type for the USB boot device.<br>      - usb-hdd - Use of Hard Disk Drive (HDD) as sub-type for the USB boot device.<br>    * boot.VirtualMedia - Below are the Supported sub\_type Values:<br>      - None - No sub type for virtual media.<br>      - cimc-mapped-dvd - The virtual media device is mapped to a virtual DVD device.<br>      - cimc-mapped-hdd - The virtual media device is mapped to a virtual HDD device.<br>      - kvm-mapped-dvd - A KVM mapped DVD virtual media device.<br>      - kvm-mapped-hdd - A KVM mapped HDD virtual media device.<br>      - kvm-mapped-fdd - A KVM mapped FDD virtual media device.<br>* wwpn - The WWPN Address of the underlying fiber channel interface used by the SAN boot device. Value must be in hexadecimal format xx:xx:xx:xx:xx:xx:xx:xx. | <pre>list(object(<br>    {<br>      bootloader_description = optional(string, null)<br>      bootloader_name        = optional(string, null)<br>      bootloader_path        = optional(string, null)<br>      enabled                = optional(bool, true)<br>      interface_name         = optional(string, null)<br>      interface_source       = optional(string, "name")<br>      ip_type                = optional(string, "IPv4")<br>      lun                    = optional(number, 0)<br>      mac_ddress             = optional(string, "")<br>      name                   = string<br>      object_type            = string<br>      port                   = optional(number, null)<br>      slot                   = optional(string, "MLOM")<br>      sub_type               = optional(string, "")<br>      wwpn                   = optional(string, null)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_boot_mode"></a> [boot\_mode](#input\_boot\_mode) | Sets the BIOS boot mode. UEFI uses the GUID Partition Table (GPT) whereas Legacy mode uses the Master Boot Record (MBR) partitioning scheme. To apply this setting, Please reboot the server.<br>* Legacy - Legacy mode refers to the traditional process of booting from BIOS. Legacy mode uses the Master Boot Record (MBR) to locate the bootloader.<br>* Uefi - UEFI mode uses the GUID Partition Table (GPT) to locate EFI Service Partitions to boot from. | `string` | `"Uefi"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the Policy. | `string` | `""` | no |
| <a name="input_enable_secure_boot"></a> [enable\_secure\_boot](#input\_enable\_secure\_boot) | If UEFI secure boot is enabled, the boot mode is set to UEFI by default. Secure boot enforces that device boots using only software that is trusted by the Original Equipment Manufacturer (OEM). | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the Policy. | `string` | `"default"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/. | `string` | `"default"` | no |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | List of Profiles to Assign to the Policy.<br>* name - Name of the Profile to Assign.<br>* object\_type - Object Type to Assign in the Profile Configuration.<br>  - server.Profile - For UCS Server Profiles.<br>  - server.ProfileTemplate - For UCS Server Profile Templates. | <pre>list(object(<br>    {<br>      name        = string<br>      object_type = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Tag Attributes to Assign to the Policy. | `list(map(string))` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_moid"></a> [moid](#output\_moid) | Boot Policy Managed Object ID (moid). |
## Resources

| Name | Type |
|------|------|
| [intersight_boot_precision_policy.boot_order](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/boot_precision_policy) | resource |
| [intersight_organization_organization.org_moid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/organization_organization) | data source |
| [intersight_server_profile.profiles](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/server_profile) | data source |
| [intersight_server_profile_template.templates](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/server_profile_template) | data source |
<!-- END_TF_DOCS -->