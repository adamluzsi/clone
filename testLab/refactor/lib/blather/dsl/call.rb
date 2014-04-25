module XMPP
  module Call
    ### meta defs
    begin
      def self.create_singleton_method(method,&block)
        define_singleton_method method, &block
      end
      def self.method_missing (method_name)
        return {:error => "invalid method or version"}
      end
    end
  end
end