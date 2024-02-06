# connect vS
# https://vcenter60.kispi.int
# https://developer.vmware.com/powercli/installation-guide
#
# Install-Module VMware.PowerCLI # run as Administrator
# find-module -name VMware.PowerCLI
# Get-Module -Name VMware.PowerCLI -ListAvailable
# Update-Module -Name VMware.PowerCLI

# 104fa310bb3988f7b5fea17e3a53eedea50e6bbe

$cred = Get-Credential 'root'
connect-VIServer -Server 192.168.0.21 -Protocol http -Credential $cred

Get-VM -Name Seca*
Get-VM -Name Iqvia*
Get-VM -Name *ucc*  # ucc
Get-VM -Name *alarm* # ucc
Get-VM -Name Si* # siemens
Get-VM -Name Sb* # sb

Get-VM -Name dczh* | select @{N="IP Address";E={@($_.guest.IPAddress[0])}}
Get-VM -Name dczh* | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}
Get-VM -Name iqvia* | fl name, NumCpu, coresPerSocket, MemoryGB
Get-HardDisk -VM iqvia* | ft -AutoSize
Get-VM dczh* | Get-NetworkAdapter | fl  name,networkname, ExtensionData, type
Get-VM dczh* | fl name
#$vm = Get-vm -name iqvia1-t | Get-NetworkAdapter | select @{n='Name';e={$_.name}}, @{n='VLAN';e={$_.Networkname}}

$vm_object = @()  # array
$servers = @('dczh1','dczh2','dczh3') # anzahl server
# $servers = @('pki-p') # anzahl server
# $servers = (get-vm).name
#$servers | Measure-Object
foreach ($n1 in $servers) {
$net = @(Get-vm -name $n1 | Get-NetworkAdapter )
$item = New-Object PSObject
$item | Add-Member -type NoteProperty -Name 'Name' -Value (Get-vm -name $n1).name
$item | Add-Member -type NoteProperty -Name 'EXS-Host' -Value (Get-vm -name $n1).VMHost
$item | Add-Member -type NoteProperty -Name 'OS' -Value (Get-vm -name $n1).Guest
$item | Add-Member -type NoteProperty -Name 'OS-ID' -Value (Get-vm -name $n1).GuestID
$item | Add-Member -type NoteProperty -Name 'Disk' -Value (Get-HardDisk -VM $n1).CapacityGB
$item | Add-Member -type NoteProperty -Name 'CPU' -Value (Get-vm -name $n1).NumCpu
$item | Add-Member -type NoteProperty -Name 'Cores' -Value (Get-vm -name $n1).coresPerSocket
$item | Add-Member -type NoteProperty -Name 'Mem' -Value (Get-vm -name $n1).MemoryGB
$item | Add-Member -type NoteProperty -Name 'VLAN' -Value $net.NetworkName
$item | Add-Member -type NoteProperty -Name 'ExtensionData' -Value $net.ExtensionData
$item | Add-Member -type NoteProperty -Name 'Mac' -Value $net.MacAddress
$item | Add-Member -type NoteProperty -Name 'IP' -Value (Get-VM -Name $n1).guest.IPAddress[0]
$item | Add-Member -type NoteProperty -Name 'ID' -Value $net.id
$item | Add-Member -type NoteProperty -Name 'Type' -Value $net.Type
#$item | Add-Member -type NoteProperty -Name 'IP' -Value (Get-VM -Name $n1 | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}})
#$item | Add-Member -type NoteProperty -Name 'Description' -Value (Get-vm -name $n1 | Get-NetworkAdapter).NetworkName
$vm_object += $item
}
$vm_object | Export-Csv -Path C:\data\Logs\vmware_all_systems.csv -Encoding UTF8 -Delimiter ";" -NoClobber -NoTypeInformation
$vm_object.vlan
$vm_object | Export-Clixml -Path C:\data\Logs\vmware_all_systems_08.12.2023.xml
$vmtest = Import-Clixml -Path C:\data\Logs\vmware_all_systems_08.12.2023.xml
$vmtest.count

$vm_object | ogv
$vm_object | ft name, exs-host,os,disk,cpu,cores, mem, vlan,ip 


$net | fl *
$vmtest | ogv



Get-Command *vm*
Get-Command *vsp*
Get-vSphereServerConfiguration
Get-VMHost | Get-VM | Get-Stat -CPU -Memory -Realtime


Get-VM -Name exzh1-p | fl *
Get-VM -Name exzh2-p | fl *
Get-VM -Name exzh3-p | fl *
Get-VM -Name exzh4-p | fl *
# get sp 
(Get-VM -Name sh*).count
Get-VM -Name sh* | select name
Get-VM -Name exzh* | select name
Get-VM -Name sh*sql* | select name
Get-VM -Name sh* | fl *
Get-VM -Name sh* | select name, notes | fl

# old
Get-VM -Name dczh2 | fl *
# new 
Get-VM -Name dczh1p | fl *
Get-VM -Name dczh2p | fl *
Get-VM -Name dczh3 | fl *
#


Get-VM -Name nps | fl *
(Get-vm).count
get-


$vmhost = Get-VMHost
$vmhost.ExtensionData.Summary.Hardware

$vmhost | Get-Stat -Stat cpu.usagemhz.average


$vmhost | Get-Stat -Stat cpu.usagemhz.average -Realtime -MaxSamples 1

get-vmhost "esx-server*" | get-stat -Stat cpu.usage.average -MaxSamples 1 -Realtime | Where{$_.Instance -eq ""}

Get-VM -Location $myDatacenter | where {$_.Name -like "dc*"}
Get-VMGuest dczh1p | fl *
Get-VMGuest * | where {($_.OSFullName -like "*server 2012*") -and ($_.State -eq "running")} | select vm, state, Hostname | ft -AutoSize



get-help Get-Snapshot -Examples

Get-Snapshot -VM dczh1p | fl *
Get-Snapshot -VM pki-p | fl *


Get-Snapshot -VM * | select name

Get-Snapshot -VM * | select name

Get-Snapshot -VM * | where {$_.Created -cle (Get-Date).AddDays(-120)} | select name, created
Get-Snapshot -VM * | where {$_.Created -cle (Get-Date).AddMonths(-6)} | select name, created

Get-Snapshot -VM dczh2p | Remove-Snapshot -WhatIf

Get-Command *snapshot*
get-help Remove-Snapshot -Examples

Get-Snapshot -vm "pki-p" | fl *
New-Snapshot -VM "pki-p" -Name "leuzim-01" -Description "test02" -Memory # mit memory
New-Snapshot -VM "pki-p" -Name "leuzim-01" -Description "test02"  # ohne memory
Get-Snapshot -vm "pki-p" | Remove-Snapshot

Get-VMGuest "DNSBYOD-P" | fl *



$hosts = @(
'dcext3', `
'dcext4', `
'DCExt1VM', `
'DCExt2VM', `
#'KISPITS01', `
#'SHTPEXT-TESTVM', `
'SHPTAPPEXTVM', `
'SHPTSQLEXTVM', `
'AlarmserverDMZ', `
'DATACOLLECT02P', `
'WAP01', `
'RedcapWeb-P', `
'SQLDMZ01P', `
'SWIFTEXT-P', `
'PhoenixWebExt')

foreach ($n1 in $hosts) { Get-VM -Name $n1}