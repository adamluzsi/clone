class ASD

  def self.create_instance_method(name,*args)
    define_method name.to_sym do |*args|
      puts "I am instance method #{args.inspect}!"
    end
  end

  def self.create_class_method(name,&block)#,*args)
    class << self
      define_method name.to_s.to_sym do |*args|
        yield
      end
    end
  end

  def self.create_cm(name,*args,&block)
    define_singleton_method name do #|*args|
      block.yield(*args)

    end
  end

end

ASD.create_cm :hello_world do

  #params = [1,2,4,5,6]

  puts params.inspect

end

ASD.hello_world([123,321,321,432,345])

#ASD.new.hello "asd","hello"
#ASD.hello "dsa"