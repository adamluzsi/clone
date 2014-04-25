module REST
  class Client

    class << self
      attr_accessor :target,
                    :port
    end

    def after_initialize
      return unless new_record?
      self.target = "0.0.0.0"
      self.port   = "8080"
    end

  end
end