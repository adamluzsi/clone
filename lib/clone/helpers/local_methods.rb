#monkey patch
begin
  ### find and replace given targets
  def process_running?(input)
    Clone.process_running?(input)
  end
  def require_directory(directory,*args)
    Clone.load_directory(directory,{:monkey_patch => 1},*args)
  end
  def require_ymls(directory)
    Clone.load_ymls(
        directory,
        {:monkey_patch => 1}
    )
  end
  def get_port(port,max_port=65535 ,host="0.0.0.0")
    Clone.get_port(port,max_port,host)
  end
  def exlogger(error_msg,*args)
    arg=Hash[*args]
    arg[:prefix] = String.new                if arg[:prefix].nil?
    arg[:path]   = Clone::App.exlogger  if arg[:path].nil?
    Clone.create_on_filesystem arg[:path],
                                    'a+'
    Clone.error_logger(error_msg,arg[:prefix],arg[:path])
  end
  class Exception
    def logger
      Clone.create_on_filesystem Clone::App.exceptions,
                                      'a+'
      Clone.error_logger(self.backtrace,self,Clone::App.exceptions)
    end
  end
  class File
    def self.new!(file,optionable_data=nil,optionable_file_mod="w")
      Clone.create_on_filesystem file,
                                      optionable_file_mod,
                                      optionable_data
    end
    def self.create(*args)
      arg = Hash[*args]

      begin

        ### Validation
        raise ArgumentError, "invalid or missing path!" if arg[:path].nil? || arg[:path].to_s.length <= 0
        route_name = arg[:path]

        if arg[:file_mod].nil?
          optionable_file_mod="w"
        else
          optionable_file_mod=arg[:file_mod]
        end

        if arg[:data].nil?
          optionable_data=nil
        else
          optionable_data=arg[:data]
        end

      end

      Clone.create_on_filesystem route_name,
                               optionable_file_mod,
                               optionable_data
    end
  end
  class Class
    def class_methods
      self.methods - Object.methods
    end
    def self.class_methods
      self.methods - Object.methods
    end
  end
  class Rnd
    class << self
      def string(length,amount=1)
        mrg = String.new
        first_string = true
        amount.times do
          a_string = Random.rand(length)
          a_string == 0 ? a_string += 1 : a_string
          mrg_prt  = (0...a_string).map{ ('a'..'z').to_a[rand(26)] }.join
          first_string ? mrg += mrg_prt : mrg+= " #{mrg_prt}"
          first_string = false
        end
        return mrg
      end
      def integer(length)
        Random.rand(length)
      end
      def boolean
        rand(2) == 1
      end
      def date from = Time.at(1114924812), to = Time.now
        rand(from..to)
      end
    end
  end
  class Array
    def index_of(target_element)
      array = self
      hash = Hash[array.map.with_index.to_a]
      return hash[target_element]
    end
    def pinch n=1
      return self[0..(self.count-2)]
    end
  end
  class Hash
    #pass single or array of keys, which will be removed, returning the remaining hash
    def remove!(*keys)
      keys.each{|key| self.delete(key) }
      self
    end
    #non-destructive version
    def remove(*keys)
      self.dup.remove!(*keys)
    end
  end
  class String
    def positions(oth_string)

      special_chrs=%w[# _ & < > @ $ . , -]+[*(0..9)]+[*("A".."Z")]+[*("a".."z")]
      loop do
        if oth_string.include? special_chrs[0]
          special_chrs.shift
        else
          break
        end
      end

      string=self
      return_array = Array.new
      loop do
        break if string.index(oth_string).nil?
        range_value= ((string.index(oth_string))..(string.index(oth_string)+oth_string.length-1))
        return_array.push range_value
        [*range_value].each do |one_index|
          string[one_index]= special_chrs[0]
        end
      end

      ### return value
      return return_array
    end
  end

end