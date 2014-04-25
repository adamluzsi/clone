module V1

  def self.included(base)
    @classes ||= Array.new
    @classes.push base.name
  end

  def self.classes
    @classes
  end

end

class V2

  def self.inherited(subclass)
    @classes ||= Array.new
    @classes.push subclass.name
  end

  def self.classes
    @classes
  end

end