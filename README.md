Description
===========

Installs camo - a small http proxy to simplify routing images through an SSL host
For more information on camo see https://github.com/atmos/camo/

Requirements
============

* nodejs cookbook

Attributes
==========

The following are the deployment specific attributes that are used to describe where to download camo from,
where to install it and who to run it as. It assumes that all these users are already present and the permissions
are setup appropriately.

* node[:camo][:path] = "/srv/camo"
* node[:camo][:deploy_user] = "deploy"
* node[:camo][:deploy_group] = "users"
* node[:camo][:deploy_migrate] = false
* node[:camo][:deploy_action] = "deploy"
* node[:camo][:repo] = "git://github.com/atmos/camo.git"
* node[:camo][:branch] = "master"
* node[:camo][:user] = "www-data"
* node[:camo][:group] = "users"

# config

* node[:camo][:port] = 8081
* node[:camo][:key] = '0x24FEEDFACEDEADBEEFCAFE'
* node[:camo][:max_redirects] = 4
* node[:camo][:host_exclusions] = "*.example.org"
* node[:camo][:hostname] = "unknown"
* node[:camo][:logging] = "disabled"

Usage
=====

Usually you would run this behind a web server proxy, such as apache2, nginx, etc.
In that cookbook add this cookbook as a dependency and include the default recipe

include_recipe "camo::default"
