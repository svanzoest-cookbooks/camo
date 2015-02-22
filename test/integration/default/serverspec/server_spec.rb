require 'serverspec'

set :backend, :exec

%w(git nodejs).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe user('camo') do
  it { should exist }
end

%w(/srv/camo/ /srv/camo/shared/).each do |dir|
  describe file(dir) do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'users' }
  end
end

%w(/srv/camo/shared/tmp /srv/camo/shared/log).each do |dir|
  describe file(dir) do
    it { should be_directory }
    it { should be_owned_by 'camo' }
    it { should be_grouped_into 'users' }
  end
end

describe port(8081) do
  it { should be_listening }
end
