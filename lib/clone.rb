module Clone;end
require 'loader'

### Apply monkey patch
require_relative_directory_r File.join "clone","helpers"

### Directory loader
require_relative_directory_r File.join "clone","config"

require_relative_directory_r File.join "clone","generator" if $generator_commands
