module Padrino

  class << self
    attr_accessor :logger
  end

  class Logger
    def add(word = nil)
      puts "hello #{word}"
    end

    alias_method :write, :add
  end

  Thread.current[:padrino_logger] = Padrino::Logger.new()
  Padrino.logger= Thread.current[:padrino_logger]
end




puts Thread.current[:padrino_logger].nil?
class << Thread.current[:padrino_logger]
  def <<(message)
    puts "Tasi rulz with #{message}"
    super
  end
end

Thread.current[:padrino_logger].add "hekki"

#Padrino.logger.write "logger!"

STDOUT