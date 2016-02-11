kibana_user = node['kibana']['user']
kibana_group = node['kibana']['group']
kibana_url = node['kibana']['url']
kibana_target_dir = node['kibana']['target_dir']

elasticsearch_url = "http://#{node['elasticsearch']['network_host']}:#{node['elasticsearch']['http_port']}"

group kibana_group do
  action :create
end

user kibana_user do
  group kibana_group
  action :create
end

directory kibana_target_dir do
  owner kibana_user
  group kibana_group
  mode '0755'
  recursive true
end

tar_extract kibana_url do
  target_dir kibana_target_dir
  creates "#{kibana_target_dir}/is_extracted"
  tar_flags ['--strip 1']
end

execute 'fix target dir ownership' do
  command "chown -R #{kibana_user}: #{kibana_target_dir}"
  action :run
end

template '/opt/kibana/config/kibana.yml' do
  source 'kibana/kibana.yml.erb'
  variables(
    {
      'elasticsearch_url' => elasticsearch_url
    }
  )
end

template '/etc/init.d/kibana' do
  source 'kibana/kibana-4.x-init.erb'
  mode 0755
  variables(
    {
      'target_dir' => kibana_target_dir
    }
  )
end

template '/etc/default/kibana' do
  source 'kibana/kibana-4.x-default.erb'
  variables(
    {
      'user' => kibana_user,
      'group' => kibana_group
    }
  )
end

service 'kibana' do
  supports :restart => true, :reload => true, :status => true
  action [:enable, :restart]
  start_command 'systemctl start kibana'
  stop_command 'systemctl stop kibana'
  restart_command 'systemctl restart kibana'
  status_command 'systemctl status kibana'
end
