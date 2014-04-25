module MODULE
  class CLASS
    ### This will trigger the include method and the preparation for registering the participants
    include Ruote::LocalParticipant
    ##================================================================================================================##
    ### This will run by default when the ruote use this participant
    def on_workitem
      begin
        ###=Start=your=code=after=this=line=###







        ###=Stop=your=code=before=this=line=###
      rescue Exception => ex
        workitem.fields['error_backtrace']=Hash.new if workitem.fields['error_backtrace'].nil?
        workitem.fields['error'] = true; workitem.fields['error_backtrace'][self.to_s.split('::').last]= ex
        ex.logger
      end; reply
    end
    ##================================================================================================================##
    ### This wil run on cancel signal when the ruote use this participant
    def on_cancel
      begin
        ###=Start=your=code=after=this=line=###






        ###=Stop=your=code=before=this=line=###
      rescue Exception => ex
        workitem.fields['error_backtrace']=Hash.new if workitem.fields['error_backtrace'].nil?
        workitem.fields['error'] = true; workitem.fields['error_backtrace'][self.to_s.split('::').last]= ex
        ex.logger
      end; reply
    end
    ##================================================================================================================##
    ### This wil run on reply command when the ruote use this participant
    def on_reply
      begin
        ###=Start=your=code=after=this=line=###






        ###=Stop=your=code=before=this=line=###
      rescue Exception => ex
        workitem.fields['error_backtrace']=Hash.new if workitem.fields['error_backtrace'].nil?
        workitem.fields['error'] = true; workitem.fields['error_backtrace'][self.to_s.split('::').last]= ex
        ex.logger
      end; reply
    end
    ##================================================================================================================##
  end
end