# chef-solo -c ./solo.rb -j ./configurations/configuration.json
file_cache_path "/tmp/chef"
cookbook_path File.expand_path('../cookbooks', __FILE__)
role_path "#{File.expand_path('../roles', __FILE__)}"
log_level :info
log_location STDOUT
ssl_verify_mode :verify_none
