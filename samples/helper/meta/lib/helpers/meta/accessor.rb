class Class
  def class_attr_accessor(name)

    ### GET
    begin
      define_method name do
        class_variable_get "@@#{name}"
      end
    end

    ### SET
    begin
      define_method "#{name}=" do |new_val|
        class_variable_set "@@#{name}" new_val
      end
    end

  end
  def instance_attr_accessor(name)

    ### GET
    begin
      define_method name do
        instance_variable_get "@#{name}"
      end
    end

    ### SET
    begin
      define_method "#{name}=" do |new_val|
        instance_variable_set "@#{name}" new_val
      end
    end

  end
end