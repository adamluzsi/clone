module Grape
  # The API class is the primary entry point for
  # creating Grape APIs.Users should subclass this
  # class in order to build an API.
  class API

    def self.inherited(subclass)
      @classes ||= Array.new
      @classes.push subclass.name.constantize

      subclass.reset!
      subclass.logger = logger.clone
    end

    def self.classes
      @classes
    end

  end
end