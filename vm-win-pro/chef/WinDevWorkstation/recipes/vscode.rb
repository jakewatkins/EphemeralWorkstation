#
# Cookbook:: WinDevWorkstation
# Recipe:: vscode
#
# Copyright:: 2020, The Authors, All Rights Reserved.


# Install VSCode
windows_package 'VSCodeSetup-x64-1.42.1.exe' do
    action :install
    installer_type :custom
    options '/VERYSILENT' 
    source 'https://jkwfiles.blob.core.windows.net/public-scripts/VSCodeSetup-x64-1.42.1.exe'
end 

file 'c:/vscode.txt' do
    content "installed"
end