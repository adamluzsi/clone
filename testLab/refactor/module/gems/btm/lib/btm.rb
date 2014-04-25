class BTM
  Dir[File.dirname(__FILE__) + "/btm**/*.rb"].each { |file| require(file) }
end
