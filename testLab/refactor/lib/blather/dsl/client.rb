module XMPP
  class Client
    include Blather::DSL
    class << self
      attr_accessor :engine,
                    :ready,
                    :setup,
                    :answers,
                    :launch

      def launch

        XMPP::Client.launch= true
        blather_thread = Thread.new do

          if XMPP::Client.ready.nil? || XMPP::Client.ready == false

            while port_open?(XMPP::CONFIG::PORT,XMPP::CONFIG::HOST)
              sleep 0.5
            end

            sleep 3
            EventMachine.run{XMPP::Client.engine.run}

          end

        end
        blather_thread.abort_on_exception= true

      end

      def start

        ### config the singleton class
        begin
          XMPP::Client.engine  ||= XMPP::Client.new
          XMPP::Client.answers ||= Hash.new
        end

        ### setup the client connection properties
        begin
          XMPP::Client.setup = XMPP::Client.engine.setup XMPP::CONFIG::JID,
                                                         XMPP::CONFIG::PWD,
                                                         XMPP::CONFIG::HOST,
                                                         XMPP::CONFIG::PORT
        end

        ### when ready get ready for disconnections!
        begin
          XMPP::Client.engine.when_ready do

            XMPP::Client.ready= true
            XMPP::Client.launch= false
            puts "ready!"

          end
        end

        ### on disconnection
        begin
          XMPP::Client.engine.disconnected do
            XMPP::Client.ready= false

            begin
              XMPP::Client.engine.shutdown
            rescue Exception => ex
              puts ex
            end

            sleep 3

            puts "Disconnected!"

            unless XMPP::Client.launch
              XMPP::Client.launch
            end

          end
        end

        ### on subscription request
        begin
          XMPP::Client.engine.subscription :request? do |s|
            XMPP::Client.engine.write_to_stream s.approve!
          end
        end

        ### on message receive
        begin
          XMPP::Client.engine.message :chat?, :body do |m|
            XMPP::Client.engine.say m.from, XMPP.receive(m.body)
          end
        end

        ### connect to the server
        begin
          XMPP::Client.launch
        end

        return nil
      end

    end
    XMPP::Client.launch ||= false
  end
end