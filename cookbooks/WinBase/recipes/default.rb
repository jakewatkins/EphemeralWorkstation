#
# Cookbook:: WinBase
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.

chef_client_scheduled_task 'Run Chef Infra Client as a scheduled task'

#install 7zip
seven_zip_tool '7z 15.14 install' do
    action    [:install, :add_to_path]
    package   '7-Zip 15.14'
    path      'C:\program files\7z'
    source    'http://www.7-zip.org/a/7z1514.msi'
    checksum  'eaf58e29941d8ca95045946949d75d9b5455fac167df979a7f8e4a6bf2d39680'
  end

#install the git cli
windows_package 'Git-2.36.1-64-bit.exe' do
    action :install
    installer_type :custom
    options '/verysilent'
    source 'https://github.com/git-for-windows/git/releases/download/v2.36.1.windows.1/Git-2.36.1-64-bit.exe'
end

#install Azure CLI
windows_package 'azure-cli-2.37.0.msi' do
   action :install
   installer_type :custom
   options '/quiet' 
   source 'https://azcliprod.blob.core.windows.net/msi/azure-cli-2.37.0.msi'
end 

#install latest .net SDK (runtime, asp.net, desktop)
windows_package 'dotnet-sdk-6.0.301-win-x64.exe' do
   action :install
   installer_type :custom
   options '/install /quiet' 
   source 'https://download.visualstudio.microsoft.com/download/pr/15ab772d-ce5c-46e5-a90e-57df11adabfb/4b1b1330b6279a50c398f94cf716c71e/dotnet-sdk-6.0.301-win-x64.exe'
end

file 'c:/win-dev-workstation.txt' do
    content node.default['windows_base']['cookbook_version']
end