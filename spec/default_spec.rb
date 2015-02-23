require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'camo::default' do
  platforms = {
    'ubuntu' => ['10.04', '12.04'],
    'centos' => ['6.6', '7.0']
  }

  # Test all generic stuff on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        before do
          stub_command("rpm -qa | grep -q '^runit'").and_return(false)
        end
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version) do |node|
            node.set[:camo][:deploy_user] = 'deploy'
          end.converge('camo::default')
        end
        it 'includes the `nodejs::default` recipe' do
          expect(chef_run).to include_recipe('nodejs::default')
        end

        it 'creates a camo user' do
          expect(chef_run).to create_user('camo')
          expect(chef_run).to_not create_user('not_camo')
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
            user: 'camo',
            group: 'users',
            mode: '0775'
          )
        end

        it 'creates a /srv/camo/shared/tmp' do
          expect(chef_run).to create_directory('/srv/camo/shared/tmp').with(
            user: 'camo',
            group: 'users',
            mode: '0775'
          )
        end
      end
    end
  end
end
