#!/usr/bin/env ruby
Dir.chdir File.expand_path(File.join(File.dirname(__FILE__),".."))
ARGV.each do |one_param|
  case one_param.downcase
    when "--daemon","-d"
      $DAEMON="start"

    when "--debug","-bug"
      require "debugger"
      debugger

  end
end
load File.join(".","config.ru")