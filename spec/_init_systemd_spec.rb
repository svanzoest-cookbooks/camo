require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'camo::_init_systemd' do
  platforms = {
    'ubuntu' => ['14.04', '16.04'],
    'centos' => ['6.7', '7.2.1511']
  }

  # Test all generic stuff on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version) do |node|
            node.set[:camo][:deploy_user] = 'deploy'
          end.converge('camo::_init_systemd')
        end

        it 'creates a template /etc/sysconfig/camo' do
          expect(chef_run).to create_template('/etc/sysconfig/camo').with(
            source: 'camo.env.erb',
            owner:  'root',
            group:  'root',
            mode:   '0644'
          )
        end

        subject(:sysconfig) { chef_run.template('/etc/sysconfig/camo') }
        it 'notification is triggered by /etc/sysconfig/camo template to restart service[camo]' do
          expect(sysconfig).to notify('service[camo]').to(:restart).delayed
          expect(sysconfig).to_not notify('service[camo]').to(:restart).immediately
        end

        it 'creates a template /usr/lib/systemd/system/camo.service' do
          expect(chef_run).to create_template('/usr/lib/systemd/system/camo.service').with(
            source: 'camo.service.erb',
            owner:  'root',
            group:  'root',
            mode:   '0644'
          )
        end

        subject(:service) { chef_run.template('/usr/lib/systemd/system/camo.service') }
        it 'notification is triggered by /usr/lib/systemd/system/camo.service template to restart service[camo]' do
          expect(service).to notify('service[camo]').to(:restart).delayed
          expect(service).to_not notify('service[camo]').to(:restart).immediately
        end

        it 'starts the camo service' do
          expect(chef_run).to start_service('camo')
          expect(chef_run).to_not start_service('not_camo')
        end
      end
    end
  end
end
