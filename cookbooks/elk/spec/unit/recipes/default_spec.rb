require 'spec_helper'

describe 'elk::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0').converge(described_recipe) }

  it 'includes needed recipes' do
    expect(chef_run).to include_recipe('java')
    expect(chef_run).to include_recipe('elk::elasticsearch')
    expect(chef_run).to include_recipe('elk::kibana')
    expect(chef_run).to include_recipe('elk::nginx')
    expect(chef_run).to include_recipe('elk::logstash')
  end
end
