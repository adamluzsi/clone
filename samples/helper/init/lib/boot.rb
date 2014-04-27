# -*- encoding : utf-8 -*-

# set program directory
unless Dir.pwd == File.expand_path(File.join(File.dirname(__FILE__),'..'))
  Dir.chdir(File.join(File.dirname(__FILE__),'..'))
end

# Require Gemfile gems
require File.join 'bundler','setup'
Bundler.require(:default, :development)

# daemonize if app started with right tags
DaemonOgre.init

# use the __CONFIG__ object to get the config variables
# place yaml files under each module named folders meta folder
Loader.metaloader_framework config_obj: __CONFIG__

# set app name based on project folder
$0= TMP.project_folder

# show help if started with -h / --help
ARGV.show_help