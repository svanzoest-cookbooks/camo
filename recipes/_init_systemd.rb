#
# Cookbook Name:: camo
# Recipe:: _systemd
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

template "#{node['camo']['systemd']['env_path']}/camo" do
  source 'camo.env.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[camo]'
end

template '/etc/systemd/system/camo.service' do
  source 'camo.service.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[camo]'
end

service 'camo' do
  provider Chef::Provider::Service::Systemd
  action [:start, :enable]
end
