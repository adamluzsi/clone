#!/usr/bin/env ruby
Dir.chdir File.expand_path(File.join(File.dirname(__FILE__),".."))
$DAEMON="stop"
load File.join(".","config.ru")
