#
# cookbook name: camo
#
# variables
# deployment
default['camo']['deploy_user'] = 'root'
default['camo']['deploy_group'] = 'users'
default['camo']['deploy_migrate'] = false
default['camo']['deploy_action'] = 'deploy'
default['camo']['repo'] = 'git://github.com/atmos/camo.git'
default['camo']['branch'] = 'v2.3.0'
