yml_file = (Dir.entries(File.join(File.dirname(__FILE__))).reject{|x| x[-4,4] != ".yml"})[0].to_s
BLATHER_CONFIG = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__),yml_file)))

module XMPP
  ### require
  require 'blather/client/dsl'
  require 'json'
end