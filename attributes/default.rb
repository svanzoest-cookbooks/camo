#
# cookbook name: camo
#
# variables

# deployment
default['camo']['app_name'] = 'camo'
default['camo']['path'] = '/srv/camo'
default['camo']['user'] = 'www-data'
default['camo']['group'] = 'users'
default['camo']['install_method'] = 'package'

# config
default['camo']['port'] = 8_081
default['camo']['header_via'] = nil
default['camo']['key'] = 'FEEDFACEDEADBEEFCAFE'
default['camo']['logging'] = 'disabled'
default['camo']['length_limit'] = 5_242_880
default['camo']['max_redirects'] = 4
default['camo']['socket_timeout'] = 10
default['camo']['timing_allow_origin'] = nil
default['camo']['hostname'] = 'unknown'
