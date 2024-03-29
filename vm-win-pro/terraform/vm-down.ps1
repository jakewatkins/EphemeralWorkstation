#
#
#
#
param($vmName)

$base = (Get-Date).tostring("MMdd")

if(!$vmName) {
    $vmName = "jkwVM$base"
}

# get the local machine's ip address
$workstationId = (Invoke-webrequest ifconfig.me/ip).Content.Trim()

write-host "deleting $vmName from Chef server"
knife node delete $vmName -y

write-host "removing $vmName from Azure"
terraform destroy -var-file="sprinter.tfvars" -var="nameBase=$base" -var="workstation_ip=$workstationId"  -var="machineName=$vmName" -auto-approve