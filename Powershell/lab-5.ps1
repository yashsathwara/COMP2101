param (
    [switch]$Disks, [switch]$Network , [switch]$System
)
if ($Disks -ne $true -and $Disks -ne $true -and $Network -ne $true) {
    computersystem
    operatingsystem
    processor
    ram
    diskdrive
    networkadapter
    video
}
if ($Disks -eq $true) {
    diskdrive
}
if ($Network -eq $true) {
    networkadapter
}
if ($System -eq $true) {
    computersystem
    operatingsystem
    processor
    ram
    video
}