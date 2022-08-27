#
#
#
#
param($vmName, $base)

if (!$vmName) {
    $vmName = "jkwVM"
    write-host "default vm name: $vmName"
}

if (!$base) {
    $base = (Get-Date).tostring("MMdd")
    write-host "automatically generate base: $base"
    
}

$vmName += $base
write-host $vmName

$rgName = "Sprinter-$base"
$publicIp = "pubIp$base"

# get the local machine's ip address
$workstationId = (Invoke-webrequest ifconfig.me/ip).Content.Trim()

# do the terraform stuff
Write-Host "running Terraform Plan"
terraform plan -var-file="sprinter.tfvars" -var="nameBase=$base" -var="workstation_ip=$workstationId" -var="machineName=$vmName"
Write-Host "Running Terraform Apply"
terraform apply -var-file="sprinter.tfvars" -var="nameBase=$base" -var="workstation_ip=$workstationId" -var="machineName=$vmName" -auto-approve
Write-host "finished creating VM - waiting 60s before starting bootstrap process"
start-sleep -seconds 60

Write-Host "Configuring VM for Chef Bootstrap"
#get password from the keyvault
$secret = (ConvertFrom-Json -InputObject ((az keyvault secret show --name SprinterPassword --vault-name  kvGPSecrets) -join " ")).value

#setup remote session
#change this to get the username from the keyvault as well
$username = (ConvertFrom-Json -InputObject ((az keyvault secret show --name SprinterUsername --vault-name  kvGPSecrets) -join " ")).value
$password = ConvertTo-SecureString -string $secret -AsPlainText -Force

$credential = new-object -TypeName system.management.automation.pscredential -ArgumentList ($username, $password)

$vmDNSLabel = "vm-jkw-ws$base.centralus.cloudapp.azure.com"
Write-Host $vmDNSLabel
$session = new-pssession -computer $vmDNSLabel -Credential $credential
invoke-command -session $session -filepath ./files/config.ps1
exit-pssession

az vm auto-shutdown -g $rgName -n $vmName --time 2300

write-host 'waiting to give Azure a moment to rest'
start-sleep -seconds 60

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
