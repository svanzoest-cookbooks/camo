require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'camo::_install_deploy_revision' do
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
          end.converge('camo::_install_deploy_revision')
        end

        it 'includes the `git::default` recipe' do
          expect(chef_run).to include_recipe('git::default')
        end

        # it 'deploys a revision of camo into /srv/camo' do
        #   expect(chef_run).to deploy_revision_deploy('/srv/camo')
        #   expect(chef_run).to_not deploy_revision_deploy('/srv/not_camo')
        # end
      end
    end
  end
end
