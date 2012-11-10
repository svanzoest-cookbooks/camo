Description
===========
Installs camo - a small http proxy to simplify routing images through an SSL host

Requirements
============
requires nodejs recipe

Attributes
==========

The following are the deployment specific attributes that are used to describe where to download camo from,
where to install it and who to run it as. It assumes that all these users are already present and the permissions
are setup appropriately.

default[:camo][:path] = "/srv/camo"
default[:camo][:deploy_user] = "deploy"
default[:camo][:deploy_group] = "users"
default[:camo][:deploy_migrate] = false
default[:camo][:deploy_action] = "deploy"
default[:camo][:repo] = "git://github.com/atmos/camo.git"
default[:camo][:branch] = "master"
default[:camo][:user] = "www-data"
default[:camo][:group] = "users"

# config
default[:camo][:port] = 8081
default[:camo][:key] = '0x24FEEDFACEDEADBEEFCAFE'
default[:camo][:max_redirects] = 4
default[:camo][:host_exclusions] = "*.example.org"
default[:camo][:hostname] = "unknown"
default[:camo][:logging] = "disabled"

Usage
=====

Usually you would run this behind a web server proxy, such as apache2, nginx, etc.

include_recipe "camo::default"
