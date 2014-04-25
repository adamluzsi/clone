
class BTM
  class << self
	
	#BTM inditasa. A mongo hash a [name, host, port] kulcsokra hallgat.
	def start!(mongo=Hash.new)
	  log "Starting BTM"

	  @@definitions		= Hash.new
	  mongo[:name]		||= 'btm'
	  mongo[:host]		||= 'localhost'
	  mongo[:port]		||= 27017
  
	  mongo				= ::Mongo::Connection.new(mongo[:host]).db(mongo[:name])
	  storage			= ::Ruote::Mon::Storage.new(mongo)
	  worker			= ::Ruote::Worker.new(storage)
	  @@engine			= ::Ruote::Engine.new(worker) 

	  #Load monitoring
	  #  monitoring
	  raise StandardError.new('Engine not runing') unless runing?
	  log "BTM has started"
	end

	#BTM allapotanak lekerdezese
	def runing?
	  if @@engine
		true
	  else
		false
	  end
	end
	
	#Engine visszaadasa (hasznalhato minden metodusa)
	def engine
	  raise StandardError.new('Engine not runing') unless runing?
	  @@engine
	end
	
	#Ruote singleton visszaadasa (hasznalhato minden metodusa)
	def ruote
	  ::Ruote
	end
	
	#BTM leallitasa
	def stop!
	  log "Stopping BTM"    
	  @@engine.shutdown
	  @@engine = nil  
	  log "BTM has stopped"
	end
  end
end
 
