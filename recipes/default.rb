#
# Cookbook Name:: camo
# Recipe:: default
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
include_recipe 'nodejs'
include_recipe 'git'

directory node['camo']['path'] do
  owner node['camo']['deploy_user']
  group node['camo']['deploy_group']
  mode '0775'
  action :create
end

directory "#{node['camo']['path']}/shared" do
  owner node['camo']['deploy_user']
  group node['camo']['deploy_group']
  mode '0775'
  action :create
end

directory "#{node['camo']['path']}/shared/log" do
  owner node['camo']['user']
  group node['camo']['group']
  mode '0775'
  action :create
end

directory "#{node['camo']['path']}/shared/tmp" do
  owner node['camo']['user']
  group node['camo']['group']
  mode '0775'
  action :create
end

if platform?('ubuntu', 'debian')
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
end

include_recipe "camo::#{node['camo']['install_method']}"

service node['camo']['app_name'] do
  case node['platform']
  when 'ubuntu'
    if node['platform_version'].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [:enable, :start]
end
