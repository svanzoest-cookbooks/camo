# camo [![Build Status](https://travis-ci.org/viverae-cookbooks/camo.png?branch=master)](https://travis-ci.org/viverae-cookbooks/camo)

Description
===========

Installs camo - a small http proxy to simplify routing images through an SSL host
For more information on camo see https://github.com/atmos/camo/

Requirements
============

* nodejs cookbook
* git cookbook

Attributes
==========

The following are the deployment specific attributes that are used to describe where to download camo from,
where to install it and who to run it as. It assumes that all these users are already present and the permissions
are setup appropriately.

* node[:camo][:path] = "/srv/camo"
* node[:camo][:deploy_user] = "root"
* node[:camo][:deploy_group] = "users"
* node[:camo][:deploy_migrate] = false
* node[:camo][:deploy_action] = "deploy"
* node[:camo][:repo] = "git://github.com/atmos/camo.git"
* node[:camo][:branch] = "master"
* node[:camo][:user] = "www-data"
* node[:camo][:group] = "users"

# config

* node[:camo][:port] = 8081
* node[:camo][:header_via] = nil
* node[:camo][:key] = '0x24FEEDFACEDEADBEEFCAFE'
* node[:camo][:logging] = "disabled"
* node[:camo][:length_limit] = 5242880
* node[:camo][:max_redirects] = 4
* node[:camo][:socket_timeout] = 10
* node[:camo][:timing_allow_origin] = nil
* node[:camo][:hostname] = "unknown"


Usage
=====

Usually you would run this behind a web server proxy, such as apache2, nginx, etc.
In a wrapper cookbook add this cookbook as a dependency and include the default recipe

include_recipe "camo::default"
