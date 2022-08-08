#
#
#
#
param($vmName, $base)


if (!$vmName) {
    write-host "please provide the name of the vm to be bootstrapped."
    exit
}

if (!$base) {
    $base = (Get-Date).tostring("MMdd")
    write-host "automatically generate base: $base"
    exit
}

$rgName = "Sprinter-$base"
$publicIp = "pubIp$base"

write-host "bootstrapping $vmName"

#We need to setup an encrypted databag for the VM to hold the username & password so the chef client can run as a scheduled
#task
#get password from the keyvault
$username = (ConvertFrom-Json -InputObject ((az keyvault secret show --name SprinterUsername --vault-name  kvGPSecrets) -join " ")).value
$secret = (ConvertFrom-Json -InputObject ((az keyvault secret show --name SprinterPassword --vault-name  kvGPSecrets) -join " ")).value


#create the databag and add it to the server
$publicIp = az vm list-ip-addresses -n $vmName --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv
#$fdqn = (convertfrom-json -InputObject ((az network public-ip show --resource-group $rgName -n $publicIp --query "{fdqn: dnsSettings.fqdn}") -join " ")).fdqn
$fdqn = "vm-jkw-ws$base.centralus.cloudapp.azure.com"
write-host "IP: $publicIp"
write-host "DNS: $fdqn"

write-host "boot strapping $fdqn"
knife bootstrap $publicIp --environment development --run-list "role[WindowsDevWorkstation]"  -N $fdqn -o winrm --winrm-user $username --winrm-password $secret --node-name $vmName -y 


