
### Require Gemfile gems
require 'bundler/setup'
Bundler.require(:default, :development)

### Helpers Method
load File.join(Dir.pwd,'lib','helpers.rb')

### create config singleton
generate_config

### load meta-s
meta_load

### mount libs
mount_libs

### mount offline modules
mount_modules

### Daemonize
Daemon.init

###load_Grape_API
Rack::Handler::Thin.run REST::API,:Port => THIN_CONFIG['PORT']
