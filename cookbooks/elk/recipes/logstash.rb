cookbook_file '/etc/yum.repos.d/logstash.repo' do
  source 'logstash/logstash.repo'
  mode 0644
end

yum_package 'logstash'

template '/etc/logstash/conf.d/10-inputs.conf' do
  source 'logstash/inputs.conf.erb'
  mode 0644
  variables({ 'syslog_port' => node['logstash']['syslog_port'] })
  notifies :restart, 'service[logstash]', :delayed
end

cookbook_file '/etc/logstash/conf.d/20-filters.conf' do
  source 'logstash/filters.conf'
  mode 0644
  notifies :restart, 'service[logstash]', :delayed
end

elasticsearch_host = "#{node['elasticsearch']['network_host']}:#{node['elasticsearch']['http_port']}"

template '/etc/logstash/conf.d/30-outputs.conf' do
  source 'logstash/outputs.conf.erb'
  mode 0644
  variables(
    {
      'elasticsearch_host' => elasticsearch_host
    }
  )
  notifies :restart, 'service[logstash]', :delayed
end

service 'logstash' do
  supports :restart => true, :status => true
  action [:enable, :restart]
  start_command 'systemctl start logstash'
  stop_command 'systemctl stop logstash'
  restart_command 'systemctl restart logstash'
  status_command 'systemctl status logstash'
end
