#
# Cookbook:: WinDevWorkstation
# Recipe:: utils
#
# Copyright:: 2020, The Authors, All Rights Reserved.

#enable the administrator user so we can configure powershell
batch 'Enable administrator' do
  code <<-EOH
  net user administrator /active:yes
  EOH
end

#configure powershell
powershell_script 'Configure powershell' do
  ignore_failure true
  elevated true
  domain "msedgewin10"
  user "administrator"
  password "Passw0rd!"
  code <<-EOH
  start-process powershell -verb runAs -Wait -ArgumentList 'Enable-PSRemoting -SkipNetworkProfileCheck -Force'
  start-process powershell -verb runAs -Wait -ArgumentList 'Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' -RemoteAddress Any'
  EOH
end

#set exeuction policy for powershell
# powershell_script 'set powershell execution policy' do
#   ignore_failure true
#   elevated true
#   domain "msedgewin10"
#   user "administrator"
#   password "Passw0rd!"
#   code <<-EOH
#   start-process powershell -Wait -ArgumentList 'set-executionpolicy -ExecutionPolicy Unrestricted -Force'
#   EOH
# end

 #install Azure CLI
 windows_package 'azure-cli-2.1.0.msi' do
    action :install
    installer_type :custom
    options '/quiet' 
    source 'https://jkwfiles.blob.core.windows.net/public-scripts/azure-cli-2.1.0.msi'
 end 
 
  #install WinMerge
  windows_package 'WinMerge-2.16.6-Setup.exe' do
    action :install
    installer_type :custom
    options '/VERYSILENT /NOICON' 
    source 'https://downloads.sourceforge.net/winmerge/WinMerge-2.16.6-Setup.exe'
  end 
 
  file 'c:/utils.txt' do
    content "installed"
end