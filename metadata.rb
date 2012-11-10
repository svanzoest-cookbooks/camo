maintainer       "OneHealth Solutions, Inc."
maintainer_email "cookbooks@onehealth.com"
license          "Apache 2.0"
description      "Configures camo - a small http proxy to simplify routing images through an SSL host"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"
supports 	 'ubuntu', ">= 10.04"
depends		 "nodejs"

attribute 'camo/key',
:display_name => "Camo Shared Key",
:description => "The application key",
:type => "string",
:required => "recommended",
:default => "FEEDFACEDEADBEEFCAFE"

attribute 'camo/port',
:display_name => "Camo Network Port",
:description => "The tcp port Camo should bind to",
:type => "string",
:required => "optional",
:default => "8081"

attribute 'camo/max_redirects',
:display_name => "Max Redirects",
:description => "Maximum number of HTTP Redirects to follow",
:type => "string",
:required => "optional",
:default => "4"

attribute 'camo/host_exclusions',
:display_name => "Host Exclusions",
:description => "Hostname Glob List of hosts to not proxy: e.g. *.example.org",
:type => "string",
:required => "optional",
:default => ""

attribute 'camo/hostname',
:display_name => "Hostname",
:description => "Used in the response headers to expose the camo instance hostname",
:type => "string",
:required => "optional",
:default => "unknown"

attribute 'camo/logging',
:display_name => "Logging Boolean",
:description => "Set this to anything other than 'disabled' to see debug logging to stdout",
:type => "string",
:required => "optional",
:default => "disabled"

attribute 'camo/app_name',
:display_name => "App Name",
:description => "The application name",
:type => "string",
:required => "optional",
:default => "camo"

attribute 'camo/path',
:display_name => "Deployment Root Path",
:description => "Deployment Root Location",
:type => "string",
:required => "optional",
:default => "/srv/camo"

attribute 'camo/user',
:display_name => "Runtime User",
:description => "The local unix user used to run Camo",
:type => "string",
:required => "optional",
:default => "www-data"

attribute 'camo/group',
:display_name => "Runtime Group",
:description => "The local unix user used to run Camo",
:type => "string",
:required => "optional",
:default => "users"

attribute 'camo/deploy_user',
:display_name => "Deployment User",
:description => "The local unix user used for deployment",
:type => "string",
:required => "optional",
:default => "deploy"

attribute 'camo/deploy_group',
:display_name => "Deployment Group",
:description => "The local unix group used for deployment",
:type => "string",
:required => "optional",
:default => "users"

attribute 'camo/deploy_action',
:display_name => "Deployment action type",
:description => "The chef deployment revision action",
:type => "string",
:required => "optional",
:default => "deploy"

attribute 'camo/repo',
:display_name => "Camo Source Repository",
:description => "Repository from where to download Camo",
:type => "string",
:required => "optional",
:default => "git://github.com/atmos/camo.git"

attribute 'camo/branch',
:display_name => "Camo Source Branch",
:description => "Branch from where to download Camo",
:type => "string",
:required => "optional",
:default => "master"
