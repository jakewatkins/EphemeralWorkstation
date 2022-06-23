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
 
  file 'c:/dotnet.txt' do
    content "installed"
end