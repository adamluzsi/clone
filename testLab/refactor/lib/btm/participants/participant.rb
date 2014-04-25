module Participants
  class Participant
    include Ruote::LocalParticipant
    ### This will run by default when the ruote use this participant
    def on_workitem
      begin






      rescue Exception => ex
        workitem.fields['error_backtrace']=Hash.new if workitem.fields['error_backtrace'].nil?
        workitem.fields['error'] = true; workitem.fields['error_backtrace'][self.to_s.split('::').last]= ex
        ex.logger
      end; reply
    end
    ### This wil run on cancel signal when the ruote use this participant
    def on_cancel
      begin






      rescue Exception => ex
        workitem.fields['error_backtrace']=Hash.new if workitem.fields['error_backtrace'].nil?
        workitem.fields['error'] = true; workitem.fields['error_backtrace'][self.to_s.split('::').last]= ex
        ex.logger
      end; reply
    end
    ### This wil run on reply command when the ruote use this participant
    def on_reply
      begin






      rescue Exception => ex
        workitem.fields['error_backtrace']=Hash.new if workitem.fields['error_backtrace'].nil?
        workitem.fields['error'] = true; workitem.fields['error_backtrace'][self.to_s.split('::').last]= ex
        ex.logger
      end; reply
    end
  end
end