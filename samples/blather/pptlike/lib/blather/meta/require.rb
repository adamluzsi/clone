require "yaml"
BLATHER_CONFIG = CONFIG.data['blather']['xmpp']

module XMPP
  ### require
  require 'blather/client/dsl'
  require 'json'
end