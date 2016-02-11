require 'spec_helper'

describe 'elk::elasticsearch' do
  describe service('elasticsearch') do
    it { should be_enabled }
    it { should be_running }

    describe port(9200) do
      it { should be_listening }
    end
  end
end
