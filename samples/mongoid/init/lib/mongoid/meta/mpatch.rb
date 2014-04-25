module Mongoid
  module Document

    def self.included(base)
      @classes ||= Array.new
      @classes.push base.name
    end

    def self.classes
      @classes
    end

  end
end