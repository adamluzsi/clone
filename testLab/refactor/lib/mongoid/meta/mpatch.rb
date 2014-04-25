module Mongoid
  module Document

    def self.classes

      tmp_array= Array.new
      Mongoid.models.each do |one_element|
        tmp_array.push one_element.to_s
      end
      return tmp_array

    end

  end
end