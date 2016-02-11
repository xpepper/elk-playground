elasticsearch_user 'elasticsearch'

elasticsearch_install 'elasticsearch' do
  version '2.1.1'
end

elasticsearch_configure 'elasticsearch' do
  configuration(
    {
      'network.host' => node['elasticsearch']['network_host'],
      'cluster.name' => 'elasticsearch',
      'http.port' => node['elasticsearch']['http_port']
    }
  )
end

elasticsearch_service 'elasticsearch'

service 'elasticsearch' do
  action [:enable, :start]
end
