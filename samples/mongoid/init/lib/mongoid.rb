# -*- encoding : utf-8 -*-

Mongoid.configure do |config|
  config.sessions= __CONFIG__[:development][:sessions]
end

# load models
require_relative_directory "mongoid/functions",:r
require_relative_directory "mongoid/models",:r

if ARGV.to_hash(s: true)[:db] == "drop"
  Mongoid.purge!
end
