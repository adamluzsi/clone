class ASD

  def method_missing(meth, *args, &block)
    puts "hohooo"
  end

  def self.method_missing(meth, *args, &block)
    puts "hohooo"
  end

end

ASD.hello