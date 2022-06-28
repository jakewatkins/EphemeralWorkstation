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

install_sql = ::File.exist?('c:/sql.txt')
install_vscode = ::File.exist?('c:/vscode.txt')
install_vs = ::File.exist?('c:/visualstudio.txt')
install_chrome = ::File.exist?('c:/chrome.txt')

puts ("sql installed: " + install_sql.to_s )
puts (" vs code installed: " + install_vscode.to_s)
puts ("vs installed: " + install_vs.to_s )
puts ("chrome installed: " + install_chrome.to_s)

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
if !install_chrome
    windows_package 'ChromeSetup.exe' do
        action :install
        installer_type :custom
        options '/silent /install'
        source 'https://jkwfiles.blob.core.windows.net/bootstrap/ChromeSetup.exe?sp=r&st=2022-06-27T13:28:37Z&se=2024-01-01T22:28:37Z&spr=https&sv=2021-06-08&sr=b&sig=D2Fc1Oy9s8K2xIQ2fLp1YWqT%2BPfPAPoRkFfVHMmDVuk%3D'
    end

    # powershell_script 'wait-for-setup' do
    #     code <<-EOH
    #     wait-process -name "ChromeSetup" -ErrorAction SilentlyContinue
    #     EOH
    # end

    file 'c:/chrome.txt' do
        content "installed"
    end
end

#Visual Studio Code
if !install_vscode
    windows_package 'VSCodeUserSetup-x64-1.68.1.exe' do
        action :install
        installer_type :custom
        options '/VERYSILENT /NORESTART /MERGETASKS=!runcode'
        source 'https://jkwfiles.blob.core.windows.net/bootstrap/VSCodeSetup-x64-1.68.1.exe?sp=r&st=2022-06-27T13:26:31Z&se=2024-01-01T22:26:31Z&spr=https&sv=2021-06-08&sr=b&sig=6LFpoKf38i7gUOmZBdtwOQTTvguHufAc1V6yTTffzLg%3D'
    end

    # powershell_script 'wait-for-setup' do
    #     code <<-EOH
    #     wait-process -name "VSCodeSetup-x64-1.68.1" -ErrorAction SilentlyContinue
    #     EOH
    # end

    file 'c:/vscode.txt' do
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

    #wait until setup exits before continueing
    # powershell_script 'wait-for-setup' do
    #     code <<-EOH
    #     wait-process -name "setup" -ErrorAction SilentlyContinue
    #     EOH
    # end
    
    file 'c:/sql.txt' do
        content "installed"
    end
end

if !install_vs
    #Visual Studio Pro
    windows_package 'VisualStudioSetup' do
        action :install
        installer_type :custom
        options '--add Microsoft.VisualStudio.Product.Professional --add Microsoft.VisualStudio.Component.Web --add Microsoft.VisualStudio.ComponentGroup.Web --add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions  --includeRecommended --includeOptional --quiet --norestart'
        source 'https://jkwfiles.blob.core.windows.net/bootstrap/VisualStudioSetup.exe?sp=r&st=2022-06-27T13:27:40Z&se=2024-01-01T22:27:40Z&spr=https&sv=2021-06-08&sr=b&sig=6q%2FPrBA6zluywNm5lHBZsEwCMDsJ%2FTRcB0Z6GprWoAw%3D'
    end

    #wait until setup exits before continueing
    # powershell_script 'wait-for-setup' do
    #     code <<-EOH
    #     wait-process -name "setup" -ErrorAction SilentlyContinue
    #     EOH
    # end
    
    file 'c:/visualstudio.txt' do
        content "installed"
    end
end


file 'c:/win-dev-workstation.txt' do
    content node.default['windows_base']['cookbook_version']
end