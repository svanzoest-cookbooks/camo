require 'serverspec'

set :backend, :exec

describe package('camo') do
  it { should be_installed }
end

describe service('camo') do
  it { should be_enabled }
  it { should be_running }
end
