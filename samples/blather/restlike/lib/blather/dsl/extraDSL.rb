module XMPP
  ### extraDSL
  begin
    class << self
      def send(to,what)
        ### hold thread
        if XMPP::Client.ready.nil? && XMPP::Client.engine.nil?
          timeout= 30
          while XMPP::Client.ready.nil?
            sleep 1
            timeout-= 1
            if timeout <= 0
              break
            end
          end
        end
        XMPP::Client.engine.say to, what
        return true
      end
      def ask(to,what)
        ### wait for engine
        begin
          if XMPP::Client.ready.nil? && XMPP::Client.engine.nil?
            timeout= 30
            while XMPP::Client.ready.nil?
              sleep 1
              timeout-= 1
              if timeout <= 0
                break
              end
            end
          end
        end
        ### generate sample form
        begin
          ### check msg structure
          begin
            if what['body'].nil?
              tmp_hash= Hash.new
              begin
                XMPP::CONFIG::MSG.each do |key,value|
                  if !what[key].nil?
                    tmp_hash[key]= what[key]
                    what.delete key
                  else
                    tmp_hash[key]= value
                  end
                end
              end
              tmp_hash['body']=  what
              tmp_hash['token']= self.token
              what= tmp_hash
            else
              begin
                XMPP::CONFIG::MSG.each do |key,value|
                  if what[key].nil?
                    what[key]= value
                  end
                end
              end
              what['token']= self.token
            end
          end
        end
        ### mark token
        begin
          XMPP::Client.answers[what['token']]=nil
        end
        ### send msg
        begin
          XMPP::Client.engine.say to, what.to_json
        rescue Exception
          XMPP::Client.engine.say to, what
        end
        ### after msg
        begin
          ### hold process
          begin
            sleep_time= XMPP::CONFIG::SLEEP_TIME
            timeout   = XMPP::CONFIG::TIMEOUT.to_f / sleep_time
            while XMPP::Client.answers[what['token']].nil?
              sleep sleep_time
              timeout -= 1
              if timeout <= 0
                #logger
                puts "time is out for the answer"
                break
              end
            end
          end
          ### finis process with answer
          begin
            answer_msg = XMPP::Client.answers[what['token']]
            XMPP::Client.answers.delete what['token']
          end
          ### return answer
          begin
            return answer_msg
          end
        end
      end
      def receive(msg)
        if XMPP.json? msg
          message= JSON.parse(msg)
          XMPP::CONFIG::MSG.each do |key,value|
            if message[key].nil?
              message[key]= value
            end
          end
          if XMPP::Client.answers.keys.include?(message['token'])
            XMPP::Client.answers[message['token']]= message['body']
          else
            call_method= XMPP.generate_method_name(message)
            message['body']= XMPP::Call.__send__(call_method,message['body'])
            return message.to_json
          end
        end
      end
      def token
        begin
          token_string= Time.now.to_s
          [' ',':','-','+'].each do |one_sym|
            token_string.gsub!(one_sym,'')
          end
          token_string+= Random.srand(Time.now.to_i).to_s
          token_string+= XMPP::CONFIG::JID.to_s.gsub('@','').gsub('.','').upcase
        end
        return token_string
      end
      def json? json
        begin
          JSON.parse(json)
          return true
        rescue Exception => e
          return false
        end
      end
      def routes
        XMPP::Call.singleton_methods - [:create_singleton_method,:method_missing]
      end
      def generate_method_name(hash)

        call_method= String.new
        call_method+= hash['method'].to_s.downcase
        call_method+= '_'
        call_method+= hash['version']
        call_method+= '_'
        if hash['path'].include? '/'
          call_method+= hash['path'].to_s.gsub('/','_')
        elsif  hash['path'].include? '\\'
          call_method+= hash['path'].to_s.gsub('\\','_')
        elsif  hash['path'].include? '.'
          call_method+= hash['path'].to_s.gsub('.','_')
        else
          call_method+= hash['path']
        end

        return call_method

      end
    end
  end
end