class Logger

  ### class methods
  begin
    def self.update_logg(error_msg,prefix="",log_file= nil)
      log_file ||= Logger.log_path.to_s

      if log_file.to_s != File.expand_path(log_file)
        log_file= File.expand_path(log_file)
      end

      ###convert error msg to more human friendly one
      begin
        error_msg= error_msg.to_s.gsub('", "','",'+"\n\"")
      rescue Exception
        error_msg= error_msg.inspect.gsub('", "','",'+"\n\"")
      end


      if File.exists?(log_file)
        error_log = File.open(log_file, "a+")
        error_log << "\n#{Time.now} | #{prefix}#{":" if prefix != ""} #{error_msg}"
        error_log.close
      else
        File.create(log_file, "w","#{Time.now} | #{prefix}#{":" if prefix != ""} #{error_msg}")
      end

      return {:error => error_msg}
    end
    def self.clone_mpath(original_path,new_name)
      log_path = File.expand_path(original_path)
      log_path = log_path.split(File::SEPARATOR)
      log_path.pop
      log_path.push(new_name)
      log_path = log_path.join(File::SEPARATOR)
      return log_path
    end
   

  end

  ### config
  begin
    ### class config data
    class << self
      attr_accessor :log_path,
                    :pid_path,
                    :daemon_stderr,
                    :exceptions
    end

    ### Defaults set
    begin
      Logger.log_path= File.expand_path File.join(File.dirname(__FILE__),"..","..","log","logfile.log")
      Logger.pid_path= File.expand_path File.join(File.dirname(__FILE__),"..","..","pid","processidfile.pid")
      begin
        %w[ daemon_stderr exceptions ].each do |one_log|
          Logger.__send__(one_log+"=",Logger.clone_mpath(Logger.log_path,one_log+".log"))
        end
      end
    end
  end

end

def logger(logg,*args)
  arg=Hash[*args]
  arg[:prefix] ||= String.new
  arg[:path]   ||= Logger.log_path
  File.create arg[:path],'a+'
  Logger.update_logg(logg,arg[:prefix],arg[:path])
end
