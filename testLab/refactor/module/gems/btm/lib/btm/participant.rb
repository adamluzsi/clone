class BTM
  class << self

	#Participant regisztralasa
	def participant(name, &block)
	  @@engine.register(name, &block)
	end

  #RegisterParticipant regisztrealasa
  def register_participant(regex, participant=nil, opts={}, &block)
    @@engine.register_participant(regex, participant=nil, opts={}, &block)
  end
	
	#Participantok listazasa
	def participant_list
	  @@engine.participant_list
	end
	
  end
end
