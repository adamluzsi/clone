module Participants
  module GPP
    class Sleep

      include Ruote::LocalParticipant

      def on_workitem
        begin

            if  workitem.fields['sleep'].nil? || workitem.fields['sleep'].class != Array
              workitem.fields['sleep']=     Array.new
            end

            workitem.fields['sleep'].push workitem.wfid

            BTM.pause workitem.wfid


        rescue Exception => ex
          workitem.fields['error_backtrace']=Hash.new if workitem.fields['error_backtrace'].nil?
          workitem.fields['error'] = true; workitem.fields['error_backtrace'][self.to_s.split('::').last]= ex
          ex.logger
        end; reply
      end

      def on_cancel
        begin

          BTM.resume workitem.wfid

        rescue Exception => ex
          workitem.fields['error_backtrace']=Hash.new if workitem.fields['error_backtrace'].nil?
          workitem.fields['error'] = true; workitem.fields['error_backtrace'][self.to_s.split('::').last]= ex
          ex.logger
        end; reply
      end

      def on_reply

      end

    end
  end
end