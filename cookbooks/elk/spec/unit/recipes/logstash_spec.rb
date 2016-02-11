require 'spec_helper'

describe 'elk::logstash' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['elasticsearch']['network_host'] = 'localhost'
      node.set['elasticsearch']['http_port'] = 9200
      node.set['logstash']['syslog_port'] = 5014
    end.converge(described_recipe)
  end

  it 'creates logstash repository entry' do
    expect(chef_run).to create_cookbook_file('/etc/yum.repos.d/logstash.repo').with(source: 'logstash/logstash.repo')
  end

  it 'installs logstash package' do
    expect(chef_run).to install_yum_package('logstash')
  end

  it 'configures inputs' do
    expect(chef_run).to create_template('/etc/logstash/conf.d/10-inputs.conf').with(
                          source: 'logstash/inputs.conf.erb',
                          mode: 0644,
                          variables: {
                            'syslog_port' => 5014
                          }
                        )
  end

  it 'configures filters' do
    expect(chef_run).to create_cookbook_file('/etc/logstash/conf.d/20-filters.conf').with(
                          source: 'logstash/filters.conf',
                          mode: 0644
                        )
  end

  it 'configures outputs' do
    expect(chef_run).to create_template('/etc/logstash/conf.d/30-outputs.conf').with(
                          mode: 0644,
                          variables: {
                            'elasticsearch_host' => 'localhost:9200'
                          }
                        )
  end

  it 'enables and restart the service' do
    expect(chef_run).to enable_service('logstash')
    expect(chef_run).to restart_service('logstash')
  end

  [
    '/etc/logstash/conf.d/10-inputs.conf',
    '/etc/logstash/conf.d/30-outputs.conf'
  ].each do |file|
    it "restarts the service when '#{file}' changes" do
      template = chef_run.template(file)
      expect(template).to notify('service[logstash]').to(:restart).delayed
    end
  end

  it "restarts the service when '/etc/logstash/conf.d/20-filters.conf' changes" do
    file = chef_run.cookbook_file('/etc/logstash/conf.d/20-filters.conf')
    expect(file).to notify('service[logstash]').to(:restart).delayed
  end


end
