module Thin
  class Server
    def initialize(*args, &block)
      host, port, options = DEFAULT_HOST, DEFAULT_PORT, {}

      # Guess each parameter by its type so they can be
      # received in any order.
      args.each do |arg|
        case arg
          when Fixnum, /^\d+$/ then port    = arg.to_i
          when String          then host    = arg
          when Hash            then options = arg
          else
            @app = arg if arg.respond_to?(:call)
        end
      end

      # Set tag if needed
      self.tag = options[:tag]

      # Try to intelligently select which backend to use.
      @backend = select_backend(host, port, options)

      load_cgi_multipart_eof_fix

      @backend.server = self

      # Set defaults
      @backend.maximum_connections            = Application.config['rack']['thin']['DEFAULT_MAXIMUM_CONNECTIONS'].to_i
      @backend.maximum_persistent_connections = Application.config['rack']['thin']['DEFAULT_MAXIMUM_PERSISTENT_CONNECTIONS'].to_i
      @backend.timeout                        = Application.config['rack']['thin']['DEFAULT_TIMEOUT'].to_i

      # Allow using Rack builder as a block
      @app = Rack::Builder.new(&block).to_app if block

      # If in debug mode, wrap in logger adapter
      @app = Rack::CommonLogger.new(@app) if Logging.debug?

      setup_signals unless options[:signals].class == FalseClass
    end
  end
end