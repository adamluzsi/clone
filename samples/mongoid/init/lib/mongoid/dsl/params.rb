class Hash
  def find_hashize
    return_hash = self
    return_hash.delete 'route_info'
    return_hash.delete 'method'
    return_hash.delete 'path'

    #%w[ id  ].each do |one_key|
    #  if !return_hash[one_key].nil?
    #    return_hash['_id']= return_hash[one_key]
    #    return_hash.delete one_key
    #  end
    #end

    return_hash.each do |key,value|
      if value.class == String
        return_hash[key]=value.duck
      end
    end

    return_hash.each do |key,value|
      if key.to_s == '_id'
        return_hash[key]= Moped::BSON::ObjectId.from_string(value.to_s)
      end
    end


    return return_hash
  end
  def new_hashize
    return_hash = self
    %w[route_info method path _id id parentid parent_id].each do |one_element|
      return_hash.delete one_element
    end
    return_hash.each do |key,value|
      if value.class == String
        return_hash[key]=value.duck
      end
    end
    return return_hash
  end
  def extraction_next_item(oth_str,offsets=2)
    extracted_string= String.new
    position_nmbr= 0
    loop do
      begin
        new_indx= (self.inspect.positions(oth_str).last+offsets)+position_nmbr
        new_element= self.inspect[new_indx]
        if new_element == ' ' || new_element == ','
          break
        else
          extracted_string+= new_element
          position_nmbr+= 1
        end
      rescue Exception
        break
      end
    end

    if extracted_string.include?('(.:format)>')
      index_nbr= extracted_string.length-1
      extracted_string= extracted_string[0..(index_nbr-('(.:format)>'.length))]
    end

    return extracted_string
  end
end