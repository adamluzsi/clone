module Application
  class << self
    attr_accessor :config,
                  :env_data,
                  :environment
  end
  self.config= Hash.new()
  self.env_data= Hash.new()
  self.environment= String.new()
end

