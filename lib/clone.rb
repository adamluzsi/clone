module Clone;end

require 'loader'

### Apply monkey patch
require_relative_directory_r File.join "clone","helpers"

### Directory loader
require_relative_directory_r File.join "clone","config"

if defined? Clone::GCMD &&  Clone::GCMD[:state] == true
  require File.join "clone","generator","engine"
  require File.join "clone","generator","terminal"
end