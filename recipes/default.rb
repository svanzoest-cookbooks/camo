#
# Cookbook Name:: camo
# Recipe:: default
#
# Copyright 2012, OneHealth Solutions, Inc.
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
include_recipe "nodejs"

directory "#{node[:camo][:path]}" do
   owner node[:camo][:deploy_user]
   group node[:camo][:deploy_group]
   mode "0775"
   action :create 
end

directory "#{node[:camo][:path]}/shared" do
   owner node[:camo][:deploy_user]
   group node[:camo][:deploy_group]
   mode "0775"
   action :create
end

directory "#{node[:camo][:path]}/shared/log" do
   owner node[:camo][:user]
   group node[:camo][:group]
   mode "0775"
   action :create
end

directory "#{node[:camo][:path]}/shared/tmp" do
   owner node[:camo][:user]
   group node[:camo][:group]
   mode "0775"
   action :create
end

if platform?("ubuntu", "debian")
  package "upstart" do
     action :install
  end

  # create the upstart script
  template "/etc/init/#{node[:camo][:app_name]}.conf" do
    variables(
        :environment => node[:chef_environment],
        :app_path => node[:camo][:path],
        :app_user => node[:camo][:user],
        :app_name => node[:camo][:app_name],
        :port => node[:camo][:port],
        :host_exclusions => node[:camo][:host_exclusions],
        :key => node[:camo][:key],
        :max_redirects => node[:camo][:max_redirects],
	:hostname => node[:camo][:hostname],
	:logging => node[:camo][:logging]
    );
    source "upstart.conf.erb"
    owner "root"
    group "users"
    mode "644"
  end
end

unless node[:chef_environment] == "dev"
  deploy_revision node[:camo][:path] do
      repo node[:camo][:repo]
      branch node[:camo][:branch]
      user node[:camo][:deploy_user]
      group node[:camo][:deploy_group]
      action node[:camo][:action]
      create_dirs_before_symlink []
      symlink_before_migrate ({})
      purge_before_symlink ["tmp", "log"]
      symlinks "tmp" => "tmp", "log" => "log" 
      before_restart do
        # this is needed because deploy does a chown -R user.group on @name argument, including the shared directory
        # we need to fix this, as the tmp can only be written to by the www-data user
        # https://github.com/opscode/chef/blob/master/chef/lib/chef/provider/deploy.rb#L233
        execute "chown-tmp" do
          command "/bin/chown -R #{node[:camo][:user]} #{node[:camo][:path]}/shared/tmp"
          action :run
        end
      end
      restart_command  do
          service node[:camo][:app_name] do
             case node[:platform]
             when "ubuntu"
               if node[:platform_version].to_f >= 9.10
                  provider Chef::Provider::Service::Upstart
               end
             end
             action [:stop, :start]
          end
      end
  end
end

service node[:camo][:app_name] do
      case node[:platform]
          when "ubuntu"
          if node[:platform_version].to_f >= 9.10
             provider Chef::Provider::Service::Upstart
          end
      end
    action [:enable, :start]
end
