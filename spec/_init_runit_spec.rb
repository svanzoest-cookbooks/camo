# frozen_string_literal: true

require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'camo::_init_runit' do
  platforms = {
    'ubuntu' => ['14.04', '16.04'],
    'centos' => ['6.7', '7.2.1511']
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
            node.automatic[:virtualization][:systems] = {}
          end.converge('camo::_init_runit')
        end

        it 'includes the `runit::default` recipe' do
          expect(chef_run).to include_recipe('runit::default')
        end

        it 'enable runit_service camo' do
          expect(chef_run).to enable_runit_service('camo')
          # expect(chef_run).to enable_runit_service('camo').with(
          #   env(
          #    'PORT'                      => ops['port'].to_s,
          #    'CAMO_HEADER_VIA'           => ops['header_via'].to_s,
          #    'CAMO_KEY'                  => ops['key'],
          #    'CAMO_LENGTH_LIMIT'         => ops['length_limit'].to_s,
          #    'CAMO_LOGGING_ENABLED'      => ops['logging'],
          #    'CAMO_MAX_REDIRECTS'        => ops['max_redirects'].to_s,
          #    'CAMO_SOCKET_TIMEOUT'       => ops['socket_timeout'].to_s,
          #    'CAMO_TIMING_ALLOW_ORIGIN'  => ops['timing_allow_origin'].to_s
          #   )
          #   options(
          #     :user => ops['user'],
          #     :path => ops['path']
          #   )
          #   default_logger true
          # )
        end

        it 'start runit_service camo' do
          expect(chef_run).to start_runit_service('camo')
        end
      end
    end
  end
end
