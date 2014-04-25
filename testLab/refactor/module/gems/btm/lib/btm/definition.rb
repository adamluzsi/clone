class BTM
  class << self

	#Munkafolyamat definialasa (pdef)
	def definition(name, &block)
	  pdef = ::Ruote.define :name=> name, &block
	  @@definitions.merge!(Hash[name=>pdef])
	end
	
	#Munkafolyamatok listazasa
	def definition_list
	  @@definitions
	end

  end
end
 
