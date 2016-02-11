require '../config.rb'

local_mode true
cookbook_path ['./berks-cookbooks']
http_proxy custom_config['proxy']
https_proxy custom_config['proxy']
noproxy 'localhost, 127.0.0.1, 192.*'

knife[:bootstrap_proxy] = custom_config['proxy']
knife[:bootstrap_no_proxy] = 'localhost, 127.0.0.1, 192.*'
knife[:bootstrap_curl_options] = "-x #{custom_config['proxy']}"
knife[:bootstrap_wget_options] = "-e use_proxy=yes -e http_proxy='#{custom_config['proxy']}'"
