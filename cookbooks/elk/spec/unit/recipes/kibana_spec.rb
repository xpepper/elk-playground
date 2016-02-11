require 'spec_helper'

describe 'elk::kibana' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['kibana']['user'] = 'kibana'
      node.set['kibana']['group'] = 'kibana'
      node.set['kibana']['url'] = 'any url'
      node.set['kibana']['target_dir'] = '/opt/kibana'
      node.set['elasticsearch']['network_host'] = 'localhost'
      node.set['elasticsearch']['http_port'] = 9200
    end.converge(described_recipe)
  end

  it 'creates group kibana' do
    expect(chef_run).to create_group('kibana')
  end

  it 'creates user kibana' do
    expect(chef_run).to create_user('kibana').with(group: 'kibana')
  end

  it 'creates target directory' do
    expect(chef_run).to create_directory('/opt/kibana').with(
                          owner: 'kibana',
                          group: 'kibana',
                          mode: '0755',
                          recursive: true
                        )
  end

  it 'extracts kibana package' do
    expect(chef_run).to extract_tar_extract('any url').with(
                          target_dir: '/opt/kibana',
                          creates: '/opt/kibana/is_extracted',
                          tar_flags: ['--strip 1']
                        )
  end

  it 'fixes target dir ownership' do
    expect(chef_run).to run_execute('fix target dir ownership').with(command: 'chown -R kibana: /opt/kibana')
  end

  it 'creates kibana.yml' do
    expect(chef_run).to create_template('/opt/kibana/config/kibana.yml').with(
                          variables: {
                            'elasticsearch_url' => 'http://localhost:9200'
                          }
                        )
  end

  it 'creates the init script' do
    expect(chef_run).to create_template('/etc/init.d/kibana').with(
                          mode: 0755,
                          variables: {
                            'target_dir' => '/opt/kibana'
                          }
                        )
  end

  it 'sets defaults for init script' do
    expect(chef_run).to create_template('/etc/default/kibana').with(
                          variables: {
                            'user' => 'kibana',
                            'group' => 'kibana'
                          }
                        )
  end

  it 'enables and starts the service' do
    expect(chef_run).to enable_service('kibana')
    expect(chef_run).to restart_service('kibana')
  end
end
