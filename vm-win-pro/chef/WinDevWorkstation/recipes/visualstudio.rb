#
# Cookbook:: WinDevWorkstation
# Recipe:: visualstudio.=
#
# Copyright:: 2020, The Authors, All Rights Reserved.

# Install Visual Studio
windows_package 'vs_professional__270526120.1583528156.exe' do
    action :install
    installer_type :custom
    timeout 3600
    options '--add Microsoft.VisualStudio.Product.Professional --all --allWorkloads --quiet --norestart' 
    source 'https://jkwfiles.blob.core.windows.net/public-scripts/vs_professional__270526120.1583528156.exe'
end 

file 'c:/visualstudio.txt' do
    content "installed"
end