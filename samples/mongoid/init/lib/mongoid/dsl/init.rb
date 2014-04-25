def filling(hash)
  if hash.class == Array
    hash=Hash[*hash]
  end

  ### hash data converting
  hash.each do |key,value|

    case value.to_s.downcase

      when "string"
        hash[key]=RND.string(18,2)

      when "date"
        hash[key]=RND.date

      when "datetime"
        hash[key]=RND.datetime

      when "time"
        hash[key]=RND.time

      when "integer","float"
        hash[key]=RND.integer(11)

      when "boolean"
        hash[key]=RND.boolean

      when "moped::bson::objectid","object"
        hash.delete key

    end

  end

  return hash
end