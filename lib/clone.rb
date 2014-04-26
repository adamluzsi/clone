module Clone;end

require 'loader'

### Apply monkey patch
require_relative_directory_r File.join "clone","helpers"

### Directory loader
require_relative_directory_r File.join "clone","config"

if defined? Clone::GCMD
  if Clone::GCMD[:state] == true
    require_relative_directory_r File.join "clone","generator"
  end
end