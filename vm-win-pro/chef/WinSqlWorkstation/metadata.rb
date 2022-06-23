name 'WinSqlWorkstation'
maintainer 'Jake Watkins'
maintainer_email 'jake.watkins@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures SQL Server'
long_description 'Installs/Configures SQL Server'
version '0.1.0'
chef_version '>= 14.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/WinBase/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/WinBase'
depends 'git', '~> 10.0.0'
depends 'windows', '~> 6.0.1'