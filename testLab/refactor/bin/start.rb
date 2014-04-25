#!/usr/bin/env ruby
Dir.chdir File.expand_path(File.join(File.dirname(__FILE__),".."))

ARGV.each do |one_param|

  case one_param.downcase

    when "--daemon","-d"
      $DAEMON="start"

    when "--debug","-bug"
      require "debugger"
      debugger

    when "--config","-c"
      $CONF= ARGV[(ARGV.index(one_param)+1)]

    when "--environment","-e"

      $ENV= ARGV[(ARGV.index(one_param)+1)]

  end

end

load File.join(".","config.ru")