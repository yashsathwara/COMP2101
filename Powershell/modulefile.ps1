function welcome {
Write-output "Welcome to planet $env:computername Overlord $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It is $now."
}
welcome
function get-cpuinfo {
Get-Ciminstance cim_processor | Format-list Name , Manufacturer, MaxClockSpeed, NumberOfCores
}
get-cpuinfo
function get-mydisks {
Get-Ciminstance Win32_DiskDrive | Format-list Name , Model, Size, Manufacturer, FirmwareRevision, SerialNumber
}
get-mydisks
function computersystem {
Write Output "=====Hardware Info====="
Get-WmiObject win32_computersystem
}
computersystem
function operatingsystem {
Write Output "=====OperatingSystem Info====="
Get-WmiObject win32_operatingsystem | Format-Table Name, Version
}
operatingsystem
function processor {
Write Output "=====Processor Info====="
Get-WmiObject win32_processor | Format-Table MaxClockSpeed, NumberofCores, Sizes
}
processor
function ram {
$totalcapacity = 0
Write Output "=====Ram Info====="
Get-WmiObject win32_physicalmemory | 
ForEach-Object {
$currentRam = $_ ;
new-object -TypeName psobject -Property @{
Manufacturer = $currentRam.manufacturer
Description = $currentRam.Description
"Size(GB)" = $currentRam.capacity/1gb
Bank = $currentRam.banklabel
Slot = $currentRam.devicelocator
}
$totalcapacity += $currentRam.capacity
}|
Format-Table Manufacturer, Description, "Size(GB)", Bank, Slot -AutoSize
Write Output "Total RAM Capacity = $($totalcapacity/1gb) GB"
}
ram
function diskdrive {
Write Output "=====DiskDrive Info====="
$diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }
  }
diskdrive
function networkadapter {
Write Output "=====Network Adapter Info====="
Get-WmiObject win32_networkadapterconfiguration | Where-Object ipenabled -eq $True | Format-Table description, index, ipaddress, ipsubnet, dnsdomain, dnsserversearchorder
}
networkadapter
function video {
Write Output "=====Video Info====="
$cardObject = Get-WmiObject win32_videocontroller
$cardObject = New-Object -TypeName psObject -Property @{
Name             = $cardObject.Name
Description      = $cardObject.Description
ScreenResolution = [string]($cardObject.CurrentHorizontalResolution) + 'px X' + [string]($cardObject.CurrentVerticalResolution) + 'px'
} | Format-List Name, Description, ScreenResolution
$cardObject
}
video