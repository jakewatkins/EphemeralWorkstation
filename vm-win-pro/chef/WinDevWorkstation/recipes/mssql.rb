#
# Cookbook:: WinDevWorkstation
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

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

#reboot to complete the install
reboot 'finish install' do
    delay_mins 0
    reason 'complete sql install'
    action :nothing
end

file 'c:/sql.txt' do
    content "installed"
end