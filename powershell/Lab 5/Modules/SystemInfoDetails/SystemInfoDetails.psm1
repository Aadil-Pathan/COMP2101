function Get-ComputerSystemDetails {
	Write-Output "---------- Computer System Details ----------"
	Get-CimInstance -ClassName Win32_ComputerSystem | select Description | Format-List
}
function Get-OperatingSystemDetails {
	Write-Output "---------- Operating System Details ----------"
	Get-CimInstance -ClassName Win32_OperatingSystem | select Name,Version | Format-List
}
function Get-ProcessorDetails {
	Write-Output "---------- Processor Details ----------"
	Get-CimInstance -ClassName Win32_Processor | select Description,MaxClockSpeed,NumberOfCores,L2CacheSize,L3CacheSize | Format-List
}
function Get-PhysicalMemDetails {
	Write-Output "---------- Memory Details ----------"
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
	Write-Output "---------- Disks Details ----------"
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
	Write-Output "---------- Network Details ----------"
	Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"} | select Description,Index,IPAddress,IPSubnet,DNSDomain,DNSServerSearchOrder | Format-Table
}
function Get-VideoControllerDetails {
	Write-Output "---------- Video Controller Details ----------"
	$obj = Get-CimInstance -ClassName Win32_VideoController | select Caption,Description,CurrentHorizontalResolution,CurrentVerticalResolution
	$HorizontalResolution = $obj.CurrentHorizontalResolution
	$VerticalResolution = $obj.CurrentVerticalResolution
	$result = "$HorizontalResolution x $VerticalResolution"
	New-Object -Typename psobject -Property @{Vendor=$obj.Caption
						  Description=$obj.Description
						  "Current Screen Resolution"=$result
						}
}