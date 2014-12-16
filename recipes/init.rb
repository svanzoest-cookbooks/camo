#
# Cookbook Name:: camo
# Recipe:: init
#
# Copyright 2012-2014, OneHealth Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['camo']['init_style']
when 'upstart'

  package 'upstart' do
    action :install
  end

  # create the upstart script
  template "/etc/init/#{node['camo']['app_name']}.conf" do
    source 'upstart.conf.erb'
    owner 'root'
    group 'users'
    mode '0644'
    notifies :restart, "service[#{node['camo']['app_name']}]", :delayed
  end

  service node['camo']['app_name'] do
    case node['platform']
    when 'ubuntu'
      if node['platform_version'].to_f >= 9.10
        provider Chef::Provider::Service::Upstart
      end
    end
    action [:enable, :start]
  end

when 'runit'

  include_recipe 'runit'

  ops = node['camo']

  runit_service node['camo']['app_name'] do
    env(
      'PORT'                      => ops['port'].to_s,
      'CAMO_HEADER_VIA'           => ops['header_via'].to_s,
      'CAMO_KEY'                  => ops['key'],
      'CAMO_LENGTH_LIMIT'         => ops['length_limit'].to_s,
      'CAMO_LOGGING_ENABLED'      => ops['logging'],
      'CAMO_MAX_REDIRECTS'        => ops['max_redirects'].to_s,
      'CAMO_SOCKET_TIMEOUT'       => ops['socket_timeout'].to_s,
      'CAMO_TIMING_ALLOW_ORIGIN'  => ops['timing_allow_origin'].to_s
    )
    options(
      :user => ops['user'],
      :path => ops['path']
    )
    default_logger true
    action [:enable, :start]
  end
else
  chef::Log.error 'Not a supported init_style'
  fail RunTimeError
end
