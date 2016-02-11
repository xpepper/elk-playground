def load_custom_config
  local_config = Psych::load_file(File.dirname(__FILE__) + '/.config.yml')

  default_config = {
    "box" => "bento/centos-7.1",
    "proxy" => true
  }
  default_config.merge(local_config)
end

def custom_config
  @custom_config ||= load_custom_config
end

