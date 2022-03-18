function Get-ComputerSystemDetails {
	Write-Output "---------- Section 1 ----------"
	Get-CimInstance -ClassName Win32_ComputerSystem | select Description | Format-List
}
function Get-OperatingSystemDetails {
	Write-Output "---------- Section 2 ----------"
	Get-CimInstance -ClassName Win32_OperatingSystem | select Name,Version | Format-List
}
function Get-ProcessorDetails {
	Write-Output "---------- Section 3 ----------"
	Get-CimInstance -ClassName Win32_Processor | select Description,MaxClockSpeed,NumberOfCores,L2CacheSize,L3CacheSize | Format-List
}
function Get-PhysicalMemDetails {
	Write-Output "---------- Section 4 ----------"
	$physicalmemories = Get-CimInstance -ClassName Win32_PhysicalMemory | select Manufacturer,Description,Capacity,BankLabel,DeviceLocator
	$physicalmemories | Format-Table
	$totalRam = 0
	foreach($physicalMemory in $physicalmemories) {
		$totalRam += $physicalMemory.Capacity
	}
	$total = $totalRam / 1gb
	Write-Output "Total RAM installed in computer is : $total GB"
}
function Get-SystemDiskDetails {
	Write-Output "---------- Section 5 ----------"
	$diskdrives = Get-CimInstance CIM_DiskDrive
	foreach($disk in $diskdrives) {
		$partitions = $disk | Get-CimAssociatedInstance -ResultClassName CIM_diskpartition
		foreach($partition in $partitions) {
			$logicaldisks = $partition | Get-CimAssociatedInstance -ResultClassName CIM_logicaldisk
			foreach($logicaldisk in $logicaldisks) {
				New-Object -TypeName psobject -Property @{Vendor=$disk.Manufacturer
									  Model=$disk.Model
									  "Logical Disk Size(GB)"=$logicaldisk.Size / 1gb -as [int]
									  "Free Space(GB)"=$logicaldisk.FreeSpace / 1gb -as [int]
									  "Percentage Free(GB)"=( $logicaldisk.FreeSpace / $logicaldisk.Size ) * 100 -as [float]
									}
			}
		}
	}
}
function Get-NetworkAdapterDetails {
	Write-Output "---------- Section 6 ----------"
	Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"} | select Description,Index,IPAddress,IPSubnet,DNSDomain,DNSServerSearchOrder | Format-Table
}
function Get-VideoControllerDetails {
	Write-Output "---------- Section 7 ----------"
	$obj = Get-CimInstance -ClassName Win32_VideoController | select Caption,Description,CurrentHorizontalResolution,CurrentVerticalResolution
	$HorizontalResolution = $obj.CurrentHorizontalResolution
	$VerticalResolution = $obj.CurrentVerticalResolution
	$result = "$HorizontalResolution x $VerticalResolution"
	New-Object -Typename psobject -Property @{Vendor=$obj.Caption
						  Description=$obj.Description
						  "Current Screen Resolution"=$result
						}
}


Get-ComputerSystemDetails
Get-OperatingSystemDetails
Get-ProcessorDetails
Get-PhysicalMemDetails
$result = Get-SystemDiskDetails
$result | Format-Table
Get-NetworkAdapterDetails
$result = Get-VideoControllerDetails
$result | Format-List