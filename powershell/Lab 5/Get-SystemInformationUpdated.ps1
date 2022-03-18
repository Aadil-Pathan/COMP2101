# Lab 5 - updated from Lab 4

Param ([string]$Name = $(throw "A Parameter must be specified as (System/Disks/Network) only.")) 	# In this line I am accepting parameter. If it is not given then it will throw specified error.

Switch($Name) {												# I am using switch case to run only those function which is based on parameter.
	"System" {
		Get-ProcessorDetails
		Get-OperatingSystemDetails
		Get-PhysicalMemDetails
		Get-VideoControllerDetails
	}
	"Disks" {
		Get-SystemDiskDetails
	}
	"Network" {
		Get-NetworkAdapterDetails
	}
}