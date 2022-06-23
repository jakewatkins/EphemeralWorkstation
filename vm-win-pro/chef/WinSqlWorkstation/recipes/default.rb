#
# Cookbook:: WinDevWorkstation
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

#install latest .net framework
windows_package 'ndp48-devpack-enu.exe' do
   action :install
   installer_type :custom
   options '/install /quiet' 
   source 'https://go.microsoft.com/fwlink/?linkid=2088517'
 end

#install latest .net core framework
windows_package 'windowsdesktop-runtime-3.0.3-win-x64.exe' do
   action :install
   installer_type :custom
   options '/install /quiet' 
   source 'https://download.visualstudio.microsoft.com/download/pr/c525a2bb-6e98-4e6e-849e-45241d0db71c/d21612f02b9cae52fa50eb54de905986/windowsdesktop-runtime-3.0.3-win-x64.exe'
 end

 windows_package 'dotnet-sdk-3.1.102-win-x64.exe' do
   action :install
   installer_type :custom
   options '/install /quiet' 
   source 'https://download.visualstudio.microsoft.com/download/pr/5aad9c2c-7bb6-45b1-97e7-98f12cb5b63b/6f6d7944c81b043bdb9a7241529a5504/dotnet-sdk-3.1.102-win-x64.exe'
 end

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

#  Install Application role
windows_feature 'IIS-WebServerRole' do 
    action :install
end 
 
 windows_feature 'IIS-StaticContent' do 
    action :install 
 end 

service 'W3SVC' do 
  action [:start, :enable]
end 

# Install SQL Server Developer Edition
windows_package 'Sql2019-ssei-dev.exe' do
  action :install
  installer_type :custom
  options '/Quiet /Action=Install /IAcceptSQLServerLicenseTerms' 
  source 'https://jkwfiles.blob.core.windows.net/public-scripts/SQLServer2017-SSEI-Dev.exe'
end 

# Install SQL Server Management Studio
windows_package 'ssms-setup-ENU.exe' do
  action :install
  installer_type :custom
  options '/Quiet /Action=Install /IAcceptSQLServerLicenseTerms' 
  source 'https://jkwfiles.blob.core.windows.net/public-scripts/SSMS-Setup-ENU.exe'
end 

 file 'c:/win-dev-workstation.txt' do
    content node.default['windows_base']['cookbook_name'] + " " + node.default['windows_base']['cookbook_version']
 end