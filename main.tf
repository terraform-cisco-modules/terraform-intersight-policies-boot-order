#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  name = var.organization
}

#____________________________________________________________
#
# Intersight UCS Server Profile(s) Data Source
# GUI Location: Profiles > UCS Server Profiles > {Name}
#____________________________________________________________

data "intersight_server_profile" "profiles" {
  for_each = { for v in local.profiles : v.name => v if v.object_type == "server.Profile" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight UCS Server Profile Template(s) Data Source
# GUI Location: Templates > UCS Server Profile Templates > {Name}
#__________________________________________________________________

data "intersight_server_profile_template" "templates" {
  for_each = { for v in local.profiles : v.name => v if v.object_type == "server.ProfileTemplate" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight Boot Order Policy
# GUI Location: Policies > Create Policy > Boot Order
#__________________________________________________________________

locals {
  boot_devices = [
    for v in var.boot_devices : {
      additional_properties = length(regexall("Uefi", var.boot_mode)) > 0 && length(
        regexall("boot.Iscsi", v.object_type)) > 0 ? jsonencode(
        {
          Bootloader = {
            ClassId     = "boot.Bootloader",
            Description = v.bootloader_description != null ? v.bootloader_description : "",
            Name        = v.bootloader_name != null ? v.bootloader_name : "BOOTx64.EFI",
            ObjectType  = "boot.Bootloader",
            Path        = v.bootloader_path != null ? v.bootloader_path : "\\EFI\\BOOT\\"
          },
          InterfaceName = v.interface_name,
          Port          = v.port != null ? v.port : 0,
          Slot          = v.slot
        }
        ) : v.object_type == "boot.Iscsi" ? jsonencode(
        {
          InterfaceName = v.interface_name,
          Port          = v.port != null ? v.port : 0,
          Slot          = v.slot
        }
        ) : length(regexall("Uefi", var.boot_mode)) > 0 && length(
        regexall("boot.LocalDisk", v.object_type)) > 0 ? jsonencode(
        {
          Bootloader = {
            ClassId     = "boot.Bootloader",
            Description = v.bootloader_description != null ? v.bootloader_description : "",
            Name        = v.bootloader_name != null ? v.bootloader_name : "BOOTx64.EFI",
            ObjectType  = "boot.Bootloader",
            Path        = v.bootloader_path != null ? v.bootloader_path : "\\EFI\\BOOT\\"
          },
          Slot = v.slot
        }
        ) : v.object_type == "boot.LocalDisk" ? jsonencode(
        {
          Slot = v.slot
        }
        ) : length(regexall("Uefi", var.boot_mode)) > 0 && length(
        regexall("boot.Nvme", v.object_type)) > 0 ? jsonencode(
        {
          Bootloader = {
            ClassId     = "boot.Bootloader",
            Description = v.bootloader_description != null ? v.bootloader_description : "",
            Name        = v.bootloader_name != null ? v.bootloader_name : "BOOTx64.EFI",
            ObjectType  = "boot.Bootloader",
            Path        = v.bootloader_path != null ? v.bootloader_path : "\\EFI\\BOOT\\"
          },
        }
        ) : length(regexall("Uefi", var.boot_mode)) > 0 && length(
        regexall("boot.PchStorage", v.object_type)) > 0 ? jsonencode(
        {
          Bootloader = {
            ClassId     = "boot.Bootloader",
            Description = v.bootloader_description != null ? v.bootloader_description : "",
            Name        = v.bootloader_name != null ? v.bootloader_name : "BOOTx64.EFI",
            ObjectType  = "boot.Bootloader",
            Path        = v.bootloader_path != null ? v.bootloader_path : "\\EFI\\BOOT\\"
          },
          Lun = v.lun
        }
        ) : v.object_type == "boot.PchStorage" ? jsonencode(
        {
          Lun = v.lun
        }
        ) : v.object_type == "boot.Pxe" ? jsonencode(
        {
          InterfaceName = v.interface_name,
          InterfaceSource = length(compact([v.interface_source])
          ) > 0 ? v.interface_source : "name"
          IpType     = v.ip_type != null && v.ip_type != "" ? v.IpType : "IPv4",
          MacAddress = v.mac_ddress != null ? v.mac_ddress : "",
          Port       = v.port != null ? v.port : -1,
          Slot       = v.slot != "" ? v.slot : "MLOM"
        }
        ) : length(regexall("Uefi", var.boot_mode)) > 0 && length(
        regexall("boot.San", v.object_type)) > 0 ? jsonencode(
        {
          Bootloader = {
            ClassId     = "boot.Bootloader",
            Description = v.bootloader_description != null ? v.bootloader_description : "",
            Name        = v.bootloader_name != null ? v.bootloader_name : "BOOTx64.EFI",
            ObjectType  = "boot.Bootloader",
            Path        = v.bootloader_path != null ? v.bootloader_path : "\\EFI\\BOOT\\"
          },
          InterfaceName = v.interface_name,
          Lun           = v.lun,
          Slot          = v.slot
          Wwpn          = v.wwpn
        }
        ) : v.object_type == "boot.San" ? jsonencode(
        {
          InterfaceName = v.interface_name,
          Lun           = v.lun,
          Slot          = v.slot
          Wwpn          = v.wwpn
        }
        ) : length(regexall("Uefi", var.boot_mode)) > 0 && length(
        regexall("boot.SdCard", v.object_type)) > 0 ? jsonencode(
        {
          Bootloader = {
            ClassId     = "boot.Bootloader",
            Description = v.bootloader_description != null ? v.bootloader_description : "",
            Name        = v.bootloader_name != null ? v.bootloader_name : "BOOTx64.EFI",
            ObjectType  = "boot.Bootloader",
            Path        = v.bootloader_path != null ? v.bootloader_path : "\\EFI\\BOOT\\"
          },
          Lun     = v.lun,
          Subtype = v.sub_type != "" ? v.sub_type : "None"
        }
        ) : v.object_type == "boot.SdCard" ? jsonencode(
        {
          Lun     = v.lun,
          Subtype = v.sub_type != "" ? v.sub_type : "None"
        }
        ) : v.object_type == "boot.Usb" ? jsonencode(
        {
          Subtype = v.sub_type != "" ? v.sub_type : "None"
        }
        ) : v.object_type == "boot.VirtualMedia" ? jsonencode(
        {
          Subtype = v.sub_type != "" ? v.sub_type : "None"
        }
      ) : ""
      enabled     = v.enabled != null ? v.enabled : true
      name        = v.name
      object_type = v.object_type
    }
  ]

  profiles = {
    for v in var.profiles : v.name => {
      name        = v.name
      object_type = v.object_type != null ? v.object_type : "server.Profile"
    }
  }
}

resource "intersight_boot_precision_policy" "boot_order" {
  depends_on = [
    data.intersight_server_profile.profiles,
    data.intersight_server_profile_template.templates,
    data.intersight_organization_organization.org_moid
  ]
  configured_boot_mode     = var.boot_mode
  description              = var.description != "" ? var.description : "${var.name} BIOS Policy."
  enforce_uefi_secure_boot = var.enable_secure_boot
  name                     = var.name
  organization {
    moid        = data.intersight_organization_organization.org_moid.results[0].moid
    object_type = "organization.Organization"
  }
  dynamic "boot_devices" {
    for_each = { for v in local.boot_devices : v.name => v }
    content {
      additional_properties = boot_devices.value.additional_properties != "" ? boot_devices.value.additional_properties : ""
      enabled               = boot_devices.value.enabled
      object_type           = boot_devices.value.object_type
      name                  = boot_devices.value.name
    }
  }
  dynamic "profiles" {
    for_each = local.profiles
    content {
      moid = length(regexall("server.ProfileTemplate", profiles.value.object_type)
        ) > 0 ? data.intersight_server_profile_template.templates[profiles.value.name].results[0
      ].moid : data.intersight_server_profile.profiles[profiles.value.name].results[0].moid
      object_type = profiles.value.object_type
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
