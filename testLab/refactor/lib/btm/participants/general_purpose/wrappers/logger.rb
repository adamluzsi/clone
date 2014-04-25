module Participants
  module GPP
    class Logger

      include Ruote::LocalParticipant

      def on_workitem
        begin
          logger "logger participant: #{workitem.fields.inspect}"
        rescue Exception => ex
          workitem.fields['error_backtrace']=Hash.new if workitem.fields['error_backtrace'].nil?
          workitem.fields['error'] = true; workitem.fields['error_backtrace'][self.to_s.split('::').last]= ex
          ex.logger
        end; reply
      end

      def on_cancel

      end

      def on_reply

      end

    end
  end
end