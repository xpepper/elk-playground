require 'spec_helper'

describe 'elk::kibana' do
  describe service('kibana') do
    it { should be_enabled }
    it { should be_running }

    describe port(5601) do
      it { should be_listening }
    end
  end
end
