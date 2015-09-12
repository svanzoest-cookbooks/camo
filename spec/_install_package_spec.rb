require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'camo::install' do
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
            node.set[:camo][:install_method] = 'package'
          end.converge(described_recipe)
        end

        it 'installs package camo' do
          expect(chef_run).to install_package('camo')
        end
      end
    end
  end
end
