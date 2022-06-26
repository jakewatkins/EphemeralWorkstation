# See http://docs.chef.io/workstation/config_rb/ for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "jkwdev01"
client_key               "#{current_dir}/jkwdev01.pem"
chef_server_url          "https://api.chef.io/organizations/pscook"
cookbook_path            ["D:\SourceCode\GuerillaProgrammer\EphemeralWorkstation\cookbooks"]
