require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'camo::default' do
  platforms = {
    'ubuntu' => ['10.04', '12.04']
  }

  # Test all generic stuff on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(platform: platform, version: version) do |node|
            node.set[:camo][:deploy_user] = 'deploy'
          end.converge('camo::default')
        end
        it 'includes the `nodejs::default` recipe' do
          expect(chef_run).to include_recipe('nodejs::default')
        end

        it 'includes the `git::default` recipe' do
          expect(chef_run).to include_recipe('git::default')
        end

        it 'creates a /srv/camo' do
          expect(chef_run).to create_directory('/srv/camo').with(
            user: 'deploy',
            group: 'users',
            mode: '0775'
          )
        end

        it 'creates a /srv/camo/shared' do
          expect(chef_run).to create_directory('/srv/camo/shared').with(
            user: 'deploy',
            group: 'users',
            mode: '0775'
          )
        end

        it 'creates a /srv/camo/shared/log' do
          expect(chef_run).to create_directory('/srv/camo/shared/log').with(
            user: 'www-data',
            group: 'users',
            mode: '0775'
          )
        end

        it 'creates a /srv/camo/shared/tmp' do
          expect(chef_run).to create_directory('/srv/camo/shared/tmp').with(
            user: 'www-data',
            group: 'users',
            mode: '0775'
          )
        end

        it 'installs the `upstart` package' do
          expect(chef_run).to install_package('upstart')
        end

        it 'creates a template /etc/init/camo.conf' do
          expect(chef_run).to create_template('/etc/init/camo.conf').with(
            source: 'upstart.conf.erb',
            owner:  'root',
            group:  'users',
            mode:   '0644'
          )
        end

        # it 'deploys a revision of camo into /srv/camo' do
        #   expect(chef_run).to deploy_revision_deploy('/srv/camo')
        #   expect(chef_run).to_not deploy_revision_deploy('/srv/not_camo')
        # end

        it 'starts the camo service' do
          expect(chef_run).to start_service('camo')
          expect(chef_run).to_not start_service('not_camo')
        end
      end
    end
  end
end
