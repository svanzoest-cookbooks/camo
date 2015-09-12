#
# Cookbook Name:: camo
# Recipe:: install
#
# Copyright 2012-2014, OneHealth Solutions, Inc.
# Copyright 2015, Alexander van Zoest
# Copyright 2015, Nathan Williams
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

case node['camo']['install_method']
when 'package'
  package 'camo'
when 'deploy_revision'
  include_recipe 'nodejs'
  include_recipe 'git'

  user node['camo']['user']

  %W( #{node['camo']['path']} shared shared/log shared/tmp ).each do |shdir|
    directory "#{node['camo']['path']}/#{shdir}" do
      owner node['camo']['deploy_user']
      group node['camo']['deploy_group']
      mode '0775'
      recursive true
    end
  end

  deploy_revision node['camo']['path'] do
    repo node['camo']['repo']
    branch node['camo']['branch']
    user node['camo']['deploy_user']
    group node['camo']['deploy_group']
    action node['camo']['action']
    create_dirs_before_symlink []
    symlink_before_migrate.clear
    purge_before_symlink %w(tmp log)
    symlinks 'tmp' => 'tmp', 'log' => 'log'
    before_restart do
      # this is needed because deploy does a chown -R user.group on @name argument, including the shared directory
      # we need to fix this, as the tmp can only be written to by the www-data user
      # https://github.com/opscode/chef/blob/master/chef/lib/chef/provider/deploy.rb#L233
      execute 'chown-tmp' do
        command "/bin/chown -R #{node['camo']['user']} #{node['camo']['path']}/shared/tmp"
        action :run
      end

      execute 'chown-log' do
        command "/bin/chown -R #{node['camo']['user']} #{node['camo']['path']}/shared/log"
        action :run
      end
    end
    notifies :restart, "service[#{node['camo']['app_name']}]", :delayed
  end
else
  Chef::Log.warn(
    "Unknown install method: #{node['camo']['install_method']}! Skipping!"
  )
end
