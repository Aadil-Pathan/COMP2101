# Below script is used to fetch some specific network adapter configuration.

Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"} | select Description,Index,IPAddress,IPSubnet,DNSDomain,DNSServerSearchOrder | Format-Table