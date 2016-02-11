require 'spec_helper'

describe 'elk::logstash' do

  describe service('logstash') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/logstash/conf.d/10-inputs.conf') do
    its(:content) { should match /5014/ }
  end

  describe file('/etc/logstash/conf.d/30-outputs.conf') do
    its(:content) { should match /localhost:9200/ }
  end

  describe 'beats' do
    describe port(5044) do
      it { should be_listening }
    end
  end

  describe 'syslog' do
    describe port(5014) do
      it { should be_listening }
    end
  end

end
