#
# Cookbook Name:: camo
# Recipe:: default
#
# Copyright 2012-2014, OneHealth Solutions, Inc.
# Copyright 2015, Alexander van Zoest
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

user node['camo']['user']

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

include_recipe "camo::_install_#{node['camo']['install_method']}"
include_recipe "camo::_init_#{node['camo']['init_style']}"
