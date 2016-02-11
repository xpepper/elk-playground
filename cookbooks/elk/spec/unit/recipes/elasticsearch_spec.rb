require 'spec_helper'

describe 'elk::elasticsearch' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['elasticsearch']['network_host'] = 'localhost'
      node.set['elasticsearch']['http_port'] = 9200
    end.converge(described_recipe)
  end

  it 'creates elasticsearch user' do
    expect(chef_run).to create_elasticsearch_user('elasticsearch')
  end

  it 'installs elasticsearch 2.1.1' do
    expect(chef_run).to install_elasticsearch('elasticsearch').with(type: :package, version: '2.1.1')
  end

  it 'configures elasticsearch' do
    expect(chef_run).to manage_elasticsearch_configure('elasticsearch').with(
                          configuration: {
                            'network.host' => 'localhost',
                            'cluster.name' => 'elasticsearch',
                            'http.port' => 9200
                          }
                        )
  end

  it 'configures elasticsearch service' do
    expect(chef_run).to configure_elasticsearch_service('elasticsearch')
  end

  it 'enables and starts elasticsearch service' do
    expect(chef_run).to enable_service('elasticsearch')
    expect(chef_run).to start_service('elasticsearch')
  end
end
