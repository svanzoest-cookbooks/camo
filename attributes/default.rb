#
# cookbook name: camo
#
# variables
# deployment
default[:camo][:app_name] = "camo"
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
default[:camo][:key] = 'FEEDFACEDEADBEEFCAFE'
default[:camo][:max_redirects] = 4
default[:camo][:host_exclusions] = ""
default[:camo][:hostname] = "unknown"
default[:camo][:logging] = "disabled"
