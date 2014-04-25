module XMPP
  class Client
    include Blather::DSL
    class << self
      attr_accessor :engine,
                    :ready,
                    :answers

      def start
        thread = Thread.new do
          ### config
          begin
            XMPP::Client.engine  ||= XMPP::Client.new
            XMPP::Client.answers ||= Hash.new
            jid  = XMPP::CONFIG::JID
            pwd  = XMPP::CONFIG::PWD
            host = XMPP::CONFIG::HOST
            port = XMPP::CONFIG::PORT
          end
          ### settings
          begin
            XMPP::Client.engine.setup jid,pwd,host,port
            XMPP::Client.engine.when_ready do
              XMPP::Client.ready= true
            end
            XMPP::Client.engine.subscription :request? do |s|
              XMPP::Client.engine.write_to_stream s.approve!
            end
            XMPP::Client.engine.disconnected do
              begin
                #EM.run do
                XMPP::Client.engine.run
                  #end
              rescue Exception
                retry
              end
            end
            XMPP::Client.engine.message :chat?, :body do |m|
              XMPP::Client.engine.say m.from, XMPP.receive(m.body)
            end
          end
          ### launch
          begin
            #EM.run do
            XMPP::Client.engine.run
              #end
          rescue Exception
            retry
          end
        end
        thread.abort_on_exception = true
        return true
      end

    end
  end
end