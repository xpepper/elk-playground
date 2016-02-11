require_relative 'config.rb'

Vagrant.configure('2') do |config|

  config.vm.box = 'bento/centos-7.1'
  config.vm.box_check_update = false

  if Vagrant.has_plugin?('vagrant-omnibus')
    config.omnibus.chef_version = 'latest'
  end

  if custom_config['proxy']
    config.proxy.no_proxy = 'localhost,127.0.0.1,192.168.33.*'
    config.proxy.http = custom_config['proxy']
    config.proxy.https = custom_config['proxy']
  end

  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box
    config.cache.auto_detect = false
    config.cache.enable :yum
    config.cache.enable :gem
    config.cache.enable :chef_gem
    config.cache.enable :generic, { :cache_dir => '/var/chef/cache' }
  end

  config.vm.define "elk" do |elk|
    elk.vm.hostname = "elk"
    elk.vm.network :private_network, ip: '192.168.33.200'

    elk.vm.provider 'virtualbox' do |vb|
      vb.memory = 512
    end

    elk.vm.provision :chef_zero, install: true do |chef|
      chef.verbose_logging
      chef.nodes_path = 'cookbooks'
      chef.file_cache_path = '/var/chef/cache'
      chef.add_recipe 'elk::default'
      chef.json = {
        'nginx' => {
          'hostname' => '192.168.33.200'
        }
      }
    end
  end

end
