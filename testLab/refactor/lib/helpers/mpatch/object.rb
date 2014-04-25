class Object

  def find_and_replace(input,*params)
    params=Hash[*params]
    ### some default values
    begin
      #None!
    end
    ### Do the find and replace
    begin

      if    input.class == Array
        input.count.times do |counter|
          params.each do |key,value|
            input[counter]= input[counter].gsub(key,value)
          end
        end
      elsif input.class == String
        params.each do |key,value|
          input= input.gsub(key,value)
        end
      elsif input.class == Integer
        params.each do |key,value|
          input= input.to_s.gsub(key,value).to_i
        end
      elsif input.class == Float
        params.each do |key,value|
          input= input.to_s.gsub(key,value).to_f
        end
      end

      ### return value
      return input
    end
  end
  def each_universal(&block)
    case self.class.to_s.downcase
      when "hash"
        self.each do |key,value|
          block.call(key,value)
        end
      when "array"
        self.each do |one_element|
          block.call(self.index(one_element),one_element)
        end
      else
        block.call nil,self
    end
  end
  def map_object(symbol_key="$type")

    stage       = self
    do_later    = Hash.new
    samples     = Hash.new
    relations   = Hash.new
    main_object = nil

    loop do

      ### processing
      begin

        tmp_key = String.new
        tmp_hash= Hash.new
        stage.each_universal do |key,value|

          if value.class.to_s.downcase == "string"

            if key== symbol_key
              tmp_key= value
              main_object ||= value
            else
              tmp_hash[key]= value
            end

          else

            value.each_universal do |key_sub,value_sub|
              if key_sub == symbol_key && tmp_key != String.new
                child_property = Hash.new
                child_property['type']= value_sub
                child_property['class']= value.class.to_s
                relations[tmp_key]= child_property
              end
              do_later[key_sub]= value_sub
            end

          end
        end

        if tmp_key != String.new && tmp_hash != Hash.new
          samples[tmp_key]=tmp_hash
        end

      end

      ### finish
      begin
        break if do_later == Hash.new
        stage= do_later
        do_later = Hash.new
      end

    end

    return {:samples    => samples,
            :relations  => relations,
            :main       => main_object
    }

  end
  def class?
    self.class == Class
  end

  alias :map_sample :map_object
  alias :each_univ :each_universal
  alias :fnr :find_and_replace

end