class BTM
  class << self
	private
	
	#Monitoring
	def monitoring
	  @@engine.register_participant :monitor_error do |wfid|
	  end
	  
	  @@engine.register_participant :monitor_termination do |wfid|
	  end
	  
	  Ruote.on_launch do |wfid|
	  end
	  
	  Ruote.on_pause do |wfid|
	  end
	  
	  Ruote.on_resume do |wfid|
	  end
	  
	  Ruote.on_cancel do |wfid|
	  end
	  
	  Ruote.on_kill do |wfid|
	  end
	  
	  Ruote.on_error = 'monitor_error'
	  Ruote.on_terminate = 'monitor_termination'
	end
	
  end
end
