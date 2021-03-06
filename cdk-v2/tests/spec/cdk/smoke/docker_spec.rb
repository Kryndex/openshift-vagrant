require 'spec_helper'

###############################################################################
# Tests verifying everything Docker
###############################################################################
describe service('docker') do
  it { should be_enabled }
end

describe service('docker') do
  it { should be_running }
end

describe file('/etc/sysconfig/docker') do
  it { should contain 'registry.access.redhat.com' }
end

describe docker_container('openshift') do
  it { should be_running }
end

describe command('docker ps --filter "name=k8s_registry.*"') do
  its(:stdout) { should match /ose-docker-registry/ }
end

describe command('docker ps --filter "name=k8s_router.*"') do
  its(:stdout) { should match /ose-haproxy-router/ }
end

describe command('docker pull alpine') do
  its(:exit_status) { should eq 0 }
end

describe docker_image('alpine:latest') do
  it { should exist }
end

describe x509_certificate('/etc/docker/server-cert.pem') do
   let(:disable_sudo) { false }
   it { should be_valid }
end

describe command('openssl x509 -text -noout -in /etc/docker/server-cert.pem') do
  let(:disable_sudo) { false }
  its(:stdout) { should match /IP Address:#{Regexp.quote(ENV['TARGET_IP'])}/ }
end


