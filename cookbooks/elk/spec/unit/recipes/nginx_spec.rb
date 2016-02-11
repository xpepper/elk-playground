require 'spec_helper'

describe 'elk::nginx' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['nginx']['hostname'] = '192.168.33.100'
    end.converge(described_recipe)
  end

  it 'installs nginx package' do
    expect(chef_run).to install_yum_package('epel-release')
    expect(chef_run).to install_yum_package('nginx')
    expect(chef_run).to install_yum_package('httpd-tools')
  end

  it 'creates server entry for kibana' do
    expect(chef_run).to create_template('/etc/nginx/conf.d/kibana.conf').with(
                          variables: {
                            'hostname' => '192.168.33.100'
                          },
                          mode: 0644
                        )
  end

  it 'notifies nginx restart when configuration changes' do
    template = chef_run.template('/etc/nginx/conf.d/kibana.conf')

    expect(template).to notify('service[nginx]').to(:restart).delayed
  end

  it 'enables and starts nginx' do
    expect(chef_run).to enable_service('nginx')
    expect(chef_run).to start_service('nginx')
  end
end
