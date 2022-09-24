#____________________________________________________________
#
# Boot Order Policy Variables Section.
#____________________________________________________________

variable "boot_devices" {
  default     = []
  description = <<-EOT
    List of Boot Devices and their Attributes to Assign to the Boot Policy.
    * Bootloader Variables - These will be used when the system is running in Uefi Boot Mode.
      - bootloader_description - Description to Assign to Bootloader when running in Uefi Boot Mode.
      - bootloader_name - Typically this should be "BOOTX64.EFI".
      - bootloader_path - Typically this should be "\\EFI\\BOOT\\".
        * The Following Boot Order Types utilize Bootloader Configuration:
          - boot.Iscsi
          - boot.LocalDisk
          - boot.Nvme
          - boot.PchStorage
          - boot.San
          - boot.SdCard
    * enabled: (default is true) - Specifies if the boot device is enabled or disabled.
    * interface_name - The name of the underlying virtual ethernet interface used by the Boot Device.
      - The Following Boot Order Types utilize the InterfaceName Attribute:
        * boot.Iscsi
        * boot.Pxe
        * boot.San
    * interface_source: (optional) - Used only by boot.Pxe.  Lists the supported Interface Source for PXE device.
      - name: (default) - Use interface name to select virtual ethernet interface.
      - mac - Use MAC address to select virtual ethernet interface.
      - port - Use port to select virtual ethernet interface.
    * ip_type - Used only by boot.Pxe.  The IP Address family type to use during the PXE Boot process.
      - None - Default value if ip_type is not specified.
      - IPv4 - The IPv4 address family type.
      - IPv6 - The IPv6 address family type.
    * Lun - Default is 0.  The Logical Unit Number (LUN) of the device.
      - The Following Boot Order Types utilize the Lun Attribute:
        * boot.PchStorage
        * boot.San
        * boot.SdCard
    * mac_address - Used only by boot.Pxe.  The MAC Address of the underlying virtual ethernet interface used by the PXE boot device.
    * name: (required) - Name to Assign to the boot_device.
    * object_type: (required) - The Boot Order Type to Assign to the Boot Device.  Allowed Values are:
      - boot.Iscsi
      - boot.LocalCdd
      - boot.LocalDisk
      - boot.Nvme
      - boot.PchStorage
      - boot.Pxe
      - boot.San
      - boot.SdCard
      - boot.UefiShell
      - boot.Usb
      - boot.VirtualMedia
    * Port -  Used by iSCSI and PXE.
        * boot.Iscsi - Default is 0.  Port ID of the ISCSI boot device.  Supported values are (0-255).
        * boot.Pxe - Default is -1.  The Port ID of the adapter on which the underlying virtual ethernet interface is present. If no port is specified, the default value is -1. Supported values are -1 to 255.
    * slot - The PCIe slot ID of the adapter on which the underlying virtual ethernet interface is present.
      - The Following Boot Order Types utilize the slot Attribute:
        * boot.Iscsi - Supported values are (1-255, MLOM, L, L1, L2, OCP).
        * boot.LocalDisk - Supported values are (1-205, M, HBA, SAS, RAID, MRAID, MRAID1, MRAID2, MSTOR-RAID).  Supported values for FI-attached servers are (1-205, MRAID, FMEZZ1-SAS, MRAID1 , MRAID2, MSTOR-RAID, MSTOR-RAID-1, MSTOR-RAID-2).
        * boot.Pxe - Supported values are (1-255, MLOM , L, L1, L2, OCP).
        * boot.San - Supported values are (1-255, MLOM, L1, L2).
    * sub_type - The sub_type for the selected device type.
      - The Following Boot Order Types utilize the sub_type Attribute:
        * boot.SdCard - Below are the Supported sub_type Values:
          - None - No sub type for SD card boot device.
          - flex-util - Use of FlexUtil (microSD) card as sub type for SD card boot device.
          - flex-flash - Use of FlexFlash (SD) card as sub type for SD card boot device.
          - SDCARD - Use of SD card as sub type for the SD Card boot device.
        * boot.Usb - Below are the Supported sub_type Values:
          - None - No sub type for USB boot device.
          - usb-cd - Use of Compact Disk (CD) as sub-type for the USB boot device.
          - usb-fdd - Use of Floppy Disk Drive (FDD) as sub-type for the USB boot device.
          - usb-hdd - Use of Hard Disk Drive (HDD) as sub-type for the USB boot device.
        * boot.VirtualMedia - Below are the Supported sub_type Values:
          - None - No sub type for virtual media.
          - cimc-mapped-dvd - The virtual media device is mapped to a virtual DVD device.
          - cimc-mapped-hdd - The virtual media device is mapped to a virtual HDD device.
          - kvm-mapped-dvd - A KVM mapped DVD virtual media device.
          - kvm-mapped-hdd - A KVM mapped HDD virtual media device.
          - kvm-mapped-fdd - A KVM mapped FDD virtual media device.
    * wwpn - The WWPN Address of the underlying fiber channel interface used by the SAN boot device. Value must be in hexadecimal format xx:xx:xx:xx:xx:xx:xx:xx.
  EOT
  type = list(object(
    {
      bootloader_description = optional(string, null)
      bootloader_name        = optional(string, null)
      bootloader_path        = optional(string, null)
      enabled                = optional(bool, true)
      interface_name         = optional(string, null)
      interface_source       = optional(string, "name")
      ip_type                = optional(string, "IPv4")
      Lun                    = optional(number, 0)
      mac_ddress             = optional(string, "")
      name                   = string
      object_type            = string
      port                   = optional(number, null)
      slot                   = optional(string, "MLOM")
      sub_type               = optional(string, "")
      wwpn                   = optional(string, null)
    }
  ))
}

variable "boot_mode" {
  default     = "Uefi"
  description = <<-EOT
    Sets the BIOS boot mode. UEFI uses the GUID Partition Table (GPT) whereas Legacy mode uses the Master Boot Record (MBR) partitioning scheme. To apply this setting, Please reboot the server.
    * Legacy - Legacy mode refers to the traditional process of booting from BIOS. Legacy mode uses the Master Boot Record (MBR) to locate the bootloader.
    * Uefi - UEFI mode uses the GUID Partition Table (GPT) to locate EFI Service Partitions to boot from.
  EOT
  type        = string
}

variable "description" {
  default     = ""
  description = "Description for the Policy."
  type        = string
}

variable "enable_secure_boot" {
  default     = false
  description = "If UEFI secure boot is enabled, the boot mode is set to UEFI by default. Secure boot enforces that device boots using only software that is trusted by the Original Equipment Manufacturer (OEM)."
  type        = bool
}

variable "name" {
  default     = "boot_order"
  description = "Name for the Policy."
  type        = string
}

variable "organization" {
  default     = "default"
  description = "Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/."
  type        = string
}

variable "profiles" {
  default     = []
  description = <<-EOT
    List of Profiles to Assign to the Policy.
    * name - Name of the Profile to Assign.
    * object_type - Object Type to Assign in the Profile Configuration.
      - server.Profile - For UCS Server Profiles.
      - server.ProfileTemplate - For UCS Server Profile Templates.
  EOT
  type = list(object(
    {
      name        = string
      object_type = string
    }
  ))
}

variable "tags" {
  default     = []
  description = "List of Tag Attributes to Assign to the Policy."
  type        = list(map(string))
}
