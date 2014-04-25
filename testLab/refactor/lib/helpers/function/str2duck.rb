### duck typing
class String
  def duck

    begin
      if self == self.to_f.to_s
        return self.to_f
      end
    rescue NoMethodError
    end

    begin
      if self == self.to_i.to_s
        return self.to_i
      end
    rescue NoMethodError
    end

    begin
      if self.gsub(":","") == self.to_datetime.to_s.gsub("T"," ").gsub("+"," +").gsub(":","")
        return self.to_datetime
      end
    rescue Exception
    end

    begin
      if self == self.to_datetime.to_s
        return self.to_datetime
      end
    rescue Exception
    end

    begin
      if self == self.to_date.to_s
        return self.to_date
      end
    rescue Exception
    end

    begin
      if self == self.to_s.to_s
        return self.to_s
      end
    rescue NoMethodError
    end

    begin
      if self == "true"
        return true
      end
    rescue NoMethodError
    end


    begin
      if self == "false"
        return false
      end
    rescue NoMethodError
    end

    begin
      if self == self.to_s.to_s
        return self.to_s
      end
    rescue NoMethodError
    end

  end
end