module Mongoid
  module Banned
    class Elements
      ### Elements        output Format: [*String]
      @@elements_list ||= Array.new
      class << self
        def add(input)
          case input.class.to_s.downcase
            when "class"
              @@elements_list.push input.to_s
            when "string"
              @@elements_list.push input
            when "array"
              input.each do |one_element|
                @@elements_list.push one_element.to_s
              end
            else
              @@elements_list.push input.to_s
          end
        end
        def list
          return @@elements_list
        end
      end
    end
    class ModelElements
      ### modelElements   output Format: [*Class => String]
      @@element_list ||= Array.new
      class << self
        def add(hash)

          if hash.class == Array
            hash= Hash[*hash]
          end

          tmp_array= Array.new
          tmp_hash= Hash.new
          hash.each do |key,value|
            if key.class != Class
              tmp_hash[key.to_s]= value
            else
              tmp_hash[key]= value
            end
          end
          tmp_hash.each do |key,value|

            case value.class.to_s.downcase

              when "string"
                tmp_array.push( { key => value })

              when "array"
                value.each do |one_element|
                  tmp_array.push( {key => value.to_s})
                end

              else
                tmp_array.push( {key => value.to_s})

            end

          end

          tmp_array.each do |one_element|
            @@element_list.push one_element
          end
        end
        def list
          return @@element_list
        end
      end
    end
    class Models
      ### Models          output Format: [*Class]
      @@model_list ||= Array.new
      class << self
        def add(input)
          case input.class.to_s.downcase
            when "class"
              @@model_list.push input
            when "string"
              @@model_list.push input.to_s
            when "array"
              input.each do |one_element|
                @@model_list.push one_element.to_s
              end
            else
              @@model_list.push input.to_s
          end
        end
        def list
          return @@model_list
        end
      end
    end
    class ProtocolElements
      ### Elements        output Format: [*String]
      @@elements_list ||= Array.new
      class << self
        def add(input)
          case input.class.to_s.downcase
            when "class"
              @@elements_list.push input.to_s
            when "string"
              @@elements_list.push input
            when "array"
              input.each do |one_element|
                @@elements_list.push one_element.to_s
              end
            else
              @@elements_list.push input.to_s
          end
        end
        def list
          return @@elements_list
        end
      end
    end
    class << self
      def list
        tmp_hash= Hash.new
        tmp_hash[:Elements]= self::Elements.list
        tmp_hash[:ModelElements]= self::ModelElements.list
        tmp_hash[:Models]= self::Models.list
        tmp_hash[:ProtocolElements]= self::ProtocolElements.list

        return tmp_hash
      end
    end
  end
end

begin
  Application.config['mongoid']['control']['banned'].each do |key,value|
    case key.to_s.downcase
      when "modelelements","model_elements","modelelement","model_element"
        Mongoid::Banned::ModelElements.add value
      when "elements","element"
        Mongoid::Banned::Elements.add value
      when "protocol","protocolelements"
        Mongoid::Banned::ProtocolElements.add value
      when "models","model"
        Mongoid::Banned::Models.add value
    end
  end
rescue Exception
end