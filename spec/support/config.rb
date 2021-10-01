config = YAML.load_file(SPEC_DIR.join('config.yml')).with_indifferent_access
if access_token = ENV['EXTEND_ACCESS_TOKEN'].presence
  config[:access_token] = access_token
end
CONFIG = config
