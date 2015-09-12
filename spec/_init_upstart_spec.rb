require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'camo::service' do
  platforms = {
    'ubuntu' => ['10.04', '12.04'],
    'centos' => ['6.6', '7.0']
  }

  # Test all generic stuff on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version) do |node|
            node.set[:camo][:deploy_user] = 'deploy'
            node.set[:camo][:init_style] = 'upstart'
          end.converge(described_recipe)
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

        it 'starts the camo service' do
          expect(chef_run).to start_service('camo')
          expect(chef_run).to_not start_service('not_camo')
        end
      end
    end
  end
end
