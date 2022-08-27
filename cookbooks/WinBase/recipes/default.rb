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
install_postman = ::File.exist?('c:/postman.txt')
install_terraform = ::File.exist?('c:/terraform.txt')

puts ("sql installed: " + install_sql.to_s )
puts (" vs code installed: " + install_vscode.to_s)
puts ("vs installed: " + install_vs.to_s )
puts ("chrome installed: " + install_chrome.to_s)
puts ("postman installed: " + install_postman.to_s)
puts ("terraform installed: " + install_terraform.to_s)

chef_client_scheduled_task 'Run Chef Infra Client as a scheduled task'


directory 'c:/temp' do
    action :create
end

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

if !install_postman
        #download postman
        remote_file 'C:/packages/postman.exe' do
            source 'https://dl.pstmn.io/download/latest/win64'
            action :create
        end
        
        #install postman
        windows_package 'postman.exe' do
            action :install
            installer_type :custom
            options '--silent'
            source 'C:/packages/postman.exe'
        end
    
        file 'c:/postman.txt' do
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
    #this install takes a long time and sometimes hasnt completed when the chef-client run as completed.
    #probably need to create a resource for this that nows how to wait for VS to finish installing
    #Visual Studio Pro
    #windows_package 'VisualStudioSetup' do
    #    action :install
    #    installer_type :custom
    #    options '--add Microsoft.VisualStudio.Product.Professional --add Microsoft.VisualStudio.Component.Web --add Microsoft.VisualStudio.ComponentGroup.Web --add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions  --includeRecommended --includeOptional --quiet --norestart'
    #    source 'https://jkwfiles.blob.core.windows.net/bootstrap/VisualStudioSetup.exe?sp=r&st=2022-06-27T13:27:40Z&se=2024-01-01T22:27:40Z&spr=https&sv=2021-06-08&sr=b&sig=6q%2FPrBA6zluywNm5lHBZsEwCMDsJ%2FTRcB0Z6GprWoAw%3D'
    #end

    #wait until setup exits before continueing
    # powershell_script 'wait-for-setup' do
    #     code <<-EOH
    #     wait-process -name "setup" -ErrorAction SilentlyContinue
    #     EOH
    # end
    
    cookbook_file "c:/temp/installVS.ps1" do
        source "installVS.ps1"
        action :create
    end

    powershell_script 'Install VS' do
        code 'c:/temp/installVS.ps1'
    end

    file 'c:/visualstudio.txt' do
        content "installed"
    end
end

directory 'c:/users/sysadmin/temp' do
    action :create
end

directory 'c:/users/sysadmin/Documents/WindowsPowerShell' do
    action :create
end

directory 'c:/source' do
    action :create
end

#install Terraform
if !install_terraform
    
    remote_file 'C:/packages/terraform_1.2.7.zip' do
        source 'https://releases.hashicorp.com/terraform/1.2.7/terraform_1.2.7_windows_386.zip'
        action :create
    end

    seven_zip_archive 'unzip_terraform' do
        action :extract
        path 'c:/source/bin'
        source 'c:/packages/terraform_1.2.7.zip'
        overwrite true
    end

    file 'c:/terraform.txt' do
        content "installed"
    end

end

#personalize the workstation
cookbook_file 'c:/users/sysadmin/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1' do
    source 'Microsoft.PowerShell_profile.ps1'
    action :create
end

cookbook_file 'c:/users/sysadmin/pictures/laughing-man.jpg' do
    source 'laughing-man.jpg'
    action :create
end

cookbook_file 'c:/temp/personalize.ps1' do
    source 'personalize.ps1'
    action :create
end

cookbook_file 'c:/temp/vs-import.ps1' do
    source 'vs-import.ps1'
    action :create
end

cookbook_file 'c:/temp/usersettings.xml' do
    source 'sql-usersettings.xml'
    action :create
end

cookbook_file 'c:/source/bin' do
    source 'azlogin.ps1'
    action :create
end

#powershell_script 'set wallpaper' do
#    code 'c:/temp/set-wallpaper.ps1'
#end

#file 'c:/temp/set-wallpaper.ps1' do
#    action :delete
#end

#HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce
registry_key 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce' do
    values [{
      name: 'Personalize',
      type: :string,
      data: 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe c:\temp\personalize.ps1'
    }]
    action :create
  end

# load my code snippets

# load my file templates

# setup x509 cert to auth w/ ADO

file 'c:/win-dev-workstation.txt' do
    content node.default['windows_base']['cookbook_version']
end