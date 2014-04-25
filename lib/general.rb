#encoding: UTF-8
module General

  ### Load the requirements in to the general Module
  load File.expand_path(File.join(File.dirname(__FILE__),'general','helpers','require.rb'))

  ### Apply monkey patch
  require_relative_directory File.join "general","helpers"

  ### Directory loader
  require_relative_directory File.join "general","config"

  if $generator_commands
    require_relative_directory File.join "general","generator"
  end

end
