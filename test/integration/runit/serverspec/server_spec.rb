require 'serverspec'

set :backend, :exec

describe file('/etc/sv/camo/run') do
  its(:content) { should match %r{/usr/bin/node /srv/camo/current/server.js} }
end
