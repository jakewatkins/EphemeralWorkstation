# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'WinDevWorkstation'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'chef-client::task', 'seven_zip::default', 'git::windows','WinDevWorkstation::default'


# Specify a custom source for a single cookbook:
cookbook 'WinDevWorkstation', path: '.'

cookbook 'windows', '~> 6.0.1', :supermarket
cookbook 'seven_zip', '~> 3.1.2', :supermarket
cookbook 'git', '~> 10.0.0', :supermarket
cookbook 'chef-client', '~> 11.5.0', :supermarket