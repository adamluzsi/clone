module Clone;end
require 'loader'
require 'yaml'


### Apply monkey patch
require_relative_directory File.join "clone","config"
require_relative_directory File.join "clone","function"