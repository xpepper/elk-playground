yum_package 'epel-release'
yum_package 'nginx'
yum_package 'httpd-tools'

template '/etc/nginx/conf.d/kibana.conf' do
  source 'nginx/kibana.conf.erb'
  mode 0644
  variables(
    {
      'hostname' => node['nginx']['hostname']
    }
  )
  notifies :restart, 'service[nginx]', :delayed
end

service 'nginx' do
  action [:enable, :start]
end
