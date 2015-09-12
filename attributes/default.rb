#
# cookbook name: camo
#
# variables

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
default['camo']['keep_alive'] = false

# deployment
default['camo']['app_name'] = 'camo'
default['camo']['path'] = '/srv/camo'
default['camo']['user'] = 'camo'
default['camo']['group'] = 'users'
default['camo']['install_method'] = 'deploy_revision'

default['camo']['env_path'] = value_for_platform_family(
  'debian' => '/etc/default',
  'default' => '/etc/sysconfig'
)

default['camo']['init_style'] = value_for_platform(
  'ubuntu' => {
    'default' => 'upstart',
    '>= 14.10' => 'systemd'
  },
  'debian' => {
    'default' => 'upstart',
    '>= 8' => 'systemd'
  },
  %w(centos rhel scientific) => {
    'default' => 'upstart',
    '>= 7.0' => 'systemd'
  }
)
