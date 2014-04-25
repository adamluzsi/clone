class BTM
  class << self

	  #Tranzakcio inditasa
	  def launch(name, fields=Hash.new, variables=Hash.new)
	    pdef = @@definitions[name]
	    wfid = @@engine.launch(pdef, fields, variables)
	    log "Workflow ID: #{wfid}"
	    wfid
	  end
	
	  #Tranzakcio szuneteltetese
	  def pause(wfid)
	    @@engine.pause(wfid)
	  end

	  #Leallitott tranzakcio folytatasa
	  def resume(wfid)
	    @@engine.resume(wfid)
	  end
	
	  #Tranzakcio ujrainditasa
	  def restart(wfid)
	    @@engine.restart(wfid)
	  end
	
	  #Tranzakcio leallitasa
	  def kill(wfid)
	    @@engine.kill(wfid)
	  end

    #Folyamatok listazasa
    def processes
      statuses = @@engine.processes
    end

    #Folyamat listazasa workFlow_ID alapjan
    def process(wfid)
      status = @@engine.process(wfid)
    end

    #The engine traverses the tree of execution and
    #cancels alive expressions one by one. Active 
    #participants receive a cancel message indicating 
    #which the id of the workitem to cancel.
    #Warning: as explained cancelling a process or a 
    #branch of a process isn’t instantaneous.
    #----------------------------------------
    #NOTE! Processes (and expressions) can be cancelled 
    #or they can be killed. Killing looks much like cancelling, 
    #except that any on_cancel will be ignored.
    def cancel_process_tree(wfid)
      @@engine.cancel_process(wfid)
    end

  end
end
