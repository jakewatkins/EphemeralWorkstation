#
# Cookbook:: WinDevWorkstation
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

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

install_dotnet = ::File.exist?('dotnet.txt')
install_utils = ::File.exist?('utils.txt')
install_vscode = ::File.exist?('vscode.txt')
install_sql = ::File.exist?('sql.txt')
install_vs = ::File.exist?('visualstudio.txt')

puts ("dotnet installed: " + install_dotnet.to_s )
puts ("utils installed: " + install_utils.to_s )
puts ("vscode installed: " + install_vscode.to_s )
puts ("sql installed: " + install_sql.to_s )
puts ("vs installed: " + install_vs.to_s )

if !install_dotnet
  include_recipe 'WinDevWorkstation::dotnet'
end

include_recipe 'WinDevWorkstation::utils' if !install_utils
#include_recipe 'WinDevWorkstation::vscode' if !install_vscode
include_recipe 'WinDevWorkstation::visualstudio' if !install_vs
#include_recipe 'WinDevWorkstation::mssql' if !install_sql

#reboot 'install reboot' do
#    action :reboot_now
#    delay_mins 0
#end

file 'c:/win-dev-workstation.txt' do
    content node.default['windows_base']['cookbook_name'] + " " + node.default['windows_base']['cookbook_version']
end