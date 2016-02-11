require 'spec_helper'

describe 'elk::default' do
  describe command('/usr/bin/java -version') do
    its(:stderr) { should contain('1.8') }
  end
end
