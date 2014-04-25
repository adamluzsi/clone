class Class
  def class_methods
    self.methods - Object.methods
  end
  def create_class_method(method,&block)
    self.class_eval do
      define_singleton_method method do |*args|
        block.call *args
      end
    end
  end
  def create_instance_method(method,&block)
    self.class_eval do
      define_method method do |*args|
        block.call *args
      end
    end
  end
end