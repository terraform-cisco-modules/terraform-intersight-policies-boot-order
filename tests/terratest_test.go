package test

import (
	"fmt"
	"os"
	"testing"

	iassert "github.com/cgascoig/intersight-simple-go/assert"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestFull(t *testing.T) {
	//========================================================================
	// Setup Terraform options
	//========================================================================

	// Generate a unique name for objects created in this test to ensure we don't
	// have collisions with stale objects
	uniqueId := random.UniqueId()
	instanceName := fmt.Sprintf("test-policies-boot-%s", uniqueId)

	// Input variables for the TF module
	vars := map[string]interface{}{
		"intersight_keyid":         os.Getenv("IS_KEYID"),
		"intersight_secretkeyfile": os.Getenv("IS_KEYFILE"),
		"name":                     instanceName,
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./full",
		Vars:         vars,
	})

	//========================================================================
	// Init and apply terraform module
	//========================================================================
	defer terraform.Destroy(t, terraformOptions) // defer to ensure that TF destroy happens automatically after tests are completed
	terraform.InitAndApply(t, terraformOptions)
	moid := terraform.Output(t, terraformOptions, "moid")
	assert.NotEmpty(t, moid, "TF module moid output should not be empty")

	//========================================================================
	// Make Intersight API call(s) to validate module worked
	//========================================================================

	// Setup the expected values of the returned MO.
	// This is a Go template for the JSON object, so template variables can be used
	expectedJSONTemplate := `
{
	"Name":        "{{ .name }}",
	"Description": "{{ .name }} Boot Order Policy.",

	"BootDevices": [
        {
          "ClassId": "boot.VirtualMedia",
          "Enabled": true,
          "Name": "CIMC-DVD",
          "ObjectType": "boot.VirtualMedia",
          "Subtype": "cimc-mapped-dvd"
        },
        {
          "ClassId": "boot.VirtualMedia",
          "Enabled": true,
          "Name": "KVM-DVD",
          "ObjectType": "boot.VirtualMedia",
          "Subtype": "kvm-mapped-dvd"
        },
        {
          "Bootloader": {
            "ClassId": "boot.Bootloader",
            "Description": "",
            "Name": "BOOTx64.EFI",
            "ObjectType": "boot.Bootloader",
            "Path": "\\EFI\\BOOT\"
          },
          "ClassId": "boot.LocalDisk",
          "Enabled": true,
          "Name": "M2",
          "ObjectType": "boot.LocalDisk",
          "Slot": "MSTOR-RAID"
        },
        {
          "ClassId": "boot.Pxe",
          "Enabled": true,
          "InterfaceName": "MGMT-A",
          "InterfaceSource": "name",
          "IpType": "IPv4",
          "MacAddress": "",
          "Name": "PXE",
          "ObjectType": "boot.Pxe",
          "Port": -1,
          "Slot": "MLOM"
        },
        {
          "Bootloader": {
            "ClassId": "boot.Bootloader",
            "Description": "",
            "Name": "BOOTx64.EFI",
            "ObjectType": "boot.Bootloader",
            "Path": "\\EFI\\BOOT\"
          },
          "ClassId": "boot.San",
          "Enabled": true,
          "InterfaceName": "vHBA-A",
          "Lun": 0,
          "Name": "Primary-A",
          "ObjectType": "boot.San",
          "Slot": "MLOM",
          "Wwpn": "50:00:00:25:B5:0A:00:01"
        },
        {
          "Bootloader": {
            "ClassId": "boot.Bootloader",
            "Description": "",
            "Name": "BOOTx64.EFI",
            "ObjectType": "boot.Bootloader",
            "Path": "\\EFI\\BOOT\"
          },
          "ClassId": "boot.San",
          "Enabled": true,
          "InterfaceName": "vHBA-B",
          "Lun": 0,
          "Name": "Primary-B",
          "ObjectType": "boot.San",
          "Slot": "MLOM",
          "Wwpn": "50:00:00:25:B5:0B:00:01"
        },
        {
          "Bootloader": {
            "ClassId": "boot.Bootloader",
            "Description": "",
            "Name": "BOOTx64.EFI",
            "ObjectType": "boot.Bootloader",
            "Path": "\\EFI\\BOOT\"
          },
          "ClassId": "boot.LocalDisk",
          "Enabled": true,
          "Name": "Raid",
          "ObjectType": "boot.LocalDisk",
          "Slot": "MRAID"
        },
        {
          "Bootloader": {
            "ClassId": "boot.Bootloader",
            "Description": "",
            "Name": "BOOTx64.EFI",
            "ObjectType": "boot.Bootloader",
            "Path": "\\EFI\\BOOT\"
          },
          "ClassId": "boot.Iscsi",
          "Enabled": true,
          "InterfaceName": "iSCSI-A",
          "Name": "iSCSI",
          "ObjectType": "boot.Iscsi",
          "Port": 0,
          "Slot": "MLOM"
        }
	],
	"ConfiguredBootMode": "Uefi",
	"EnforceUefiSecureBoot": false
}
`
	// Validate that what is in the Intersight API matches the expected
	// The AssertMOComply function only checks that what is expected is in the result. Extra fields in the
	// result are ignored. This means we don't have to worry about things that aren't known in advance (e.g.
	// Moids, timestamps, etc)
	iassert.AssertMOComply(t, fmt.Sprintf("/api/v1/boot/PrecisionPolicies/%s", moid), expectedJSONTemplate, vars)
}
