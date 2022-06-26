#
# Cookbook:: WinBase
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.

#enable the administrator user so we can configure powershell
# batch 'Enable administrator' do
#     code <<-EOH
#     net user administrator /active:yes
#     EOH
# end

install_sql = ::File.exist?('sql.txt')
install_vs = ::File.exist?('visualstudio.txt')

puts ("sql installed: " + install_sql.to_s )
puts ("vs installed: " + install_vs.to_s )


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

#install Chrome
windows_package 'ChromeSetup.exe' do
    action :install
    installer_type :custom
    options '/silent /install'
    source 'https://www.google.com/chrome/thank-you.html?brand=CHBF&statcb=1&installdataindex=empty&defaultbrowser=0#'
end

#Visual Studio Code
windows_package 'VSCodeUserSetup-x64-1.68.1.exe' do
    action :install
    installer_type :custom
    options '/VERYSILENT /NORESTART /MERGETASKS=!runcode'
    source 'https://jkwfiles.blob.core.windows.net/bootstrap/VSCodeSetup-x64-1.68.1.exe?sp=r&st=2022-06-26T17:27:51Z&se=2022-06-27T01:27:51Z&spr=https&sv=2021-06-08&sr=b&sig=1BFtXuJTVoOmvbl6i%2F0GSLm5PuJlId9ydFa28WT9WiU%3D'
end

if !install_vs
    #Visual Studio Pro
    windows_package 'VisualStudioSetup' do
        action :install
        installer_type :custom
        options '--add Microsoft.VisualStudio.Product.Professional --IncludeRecommended --quiet --norestart'
        source 'https://jkwfiles.blob.core.windows.net/bootstrap/VisualStudioSetup.exe?sp=r&st=2022-06-26T17:27:03Z&se=2022-06-27T01:27:03Z&spr=https&sv=2021-06-08&sr=b&sig=8UNRzzPFp1TURw0kdPFo%2BmcRnC%2BC7Ur%2B5hKxT%2BmyZ0c%3D'
    end

    file 'c:/visualstudio.txt' do
        content "installed"
    end
end

if !install_sql
    #SQL Server Management Studio
    remote_file 'C:/packages/SSMS-Setup-ENU.exe' do
        source 'https://aka.ms/ssmsfullsetup'
        action :create
    end

    windows_package 'SSMS-Setup-ENU.exe' do
        action :install
        installer_type :custom
        options '/Quiet /Action=Install /IAcceptSQLServerLicenseTerms'
        source 'C:/packages/SSMS-Setup-ENU.exe'
    end

    file 'c:/sql.txt' do
        content "installed"
    end
end

file 'c:/win-dev-workstation.txt' do
    content node.default['windows_base']['cookbook_version']
end