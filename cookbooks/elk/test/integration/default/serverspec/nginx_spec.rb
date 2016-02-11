require 'spec_helper'

describe 'elk::nginx' do
  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }

    describe port(80) do
      it { should be_listening }
    end

    describe file('/etc/nginx/conf.d/kibana.conf') do
      its(:content) { should match /server_name 192.168.33.100;/ }
    end
  end
end
