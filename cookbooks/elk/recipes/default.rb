include_recipe 'java'
include_recipe 'elk::elasticsearch'
include_recipe 'elk::kibana'
include_recipe 'elk::nginx'
include_recipe 'elk::logstash'