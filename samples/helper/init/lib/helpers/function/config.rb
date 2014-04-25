class CONFIG
  class << self
    attr_accessor :data,
                  :environment,
                  :env_type
  end
  self.data= Hash.new()
  self.environment= Hash.new()

  self.env_type= Hash.new()
  self.env_type['default']=     'PRODUCTION'
  self.env_type['development']= 'DEVELOPMENT'
end