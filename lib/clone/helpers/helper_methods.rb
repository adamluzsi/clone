### Helper methods
module Clone

  ### ClassMethods
   begin
    class << self

      #Based on the rb location
      def load_directory(directory,*args)
        arg = Hash[*args]

        #directory = File.expand_path(directory)
        delayed_loads = Array.new

        if !arg[:delayed].nil?
          raise ArgumentError, "Delayed items must be in an "+\
            "Array! Example:\n:delayed => ['abc']" if arg[:delayed].class != Array
        end

        if !arg[:excluded].nil?
          raise ArgumentError, "Exclude items must be in an "+\
            "Array! Example:\n:exclude => ['abc']" if arg[:excluded].class != Array
        end

        arg[:type]         ||= "rb"
        arg[:monkey_patch] ||= 0
        #=============================================================================================================

        ### GET Pre path + validation
        begin
          #get method callers path

          pre_path = caller[arg[:monkey_patch].to_i].split('.rb:').first+('.rb')

          if !pre_path.include?('/') && !pre_path.include?('\\')
            pre_path = File.expand_path(pre_path)
          end

          separator_symbol= String.new
          pre_path.include?('/') ? separator_symbol = '/' : separator_symbol = '\\'

          pre_path= ((pre_path.split(separator_symbol))-([pre_path.split(separator_symbol).pop])).join(separator_symbol)

        end

        puts "prepath: "+pre_path.inspect if $DEBUG

        puts "LOADING_FILES_FROM_"+directory.to_s.split(separator_symbol).last.split('.').first.capitalize if $DEBUG

        puts "Elements found in #{directory}"                                                 if $DEBUG
        puts File.join("#{pre_path}","#{directory}","**","*.#{arg[:type]}")                   if $DEBUG
        puts Dir[File.join("#{pre_path}","#{directory}","**","*.#{arg[:type]}")].sort.inspect if $DEBUG

        Dir[File.join("#{pre_path}","#{directory}","**","*.#{arg[:type]}")].sort.each do |file|

          arg[:delayed]=  [nil] if arg[:delayed].nil?
          arg[:excluded]= [nil] if arg[:excluded].nil?

          arg[:excluded].each do |except|
            if file.split(separator_symbol).last.split('.').first == except.to_s.split('.').first

              puts file.to_s + " cant be loaded because it's an exception" if $DEBUG

            else

              arg[:delayed].each do |delay|

                if file.split(separator_symbol).last.split('.').first == delay.to_s.split('.').first
                  delayed_loads.push(file)
                else
                  load(file)
                  puts file.to_s if $DEBUG
                end

              end

            end
          end
        end
        delayed_loads.each do |delayed_load_element|
          load(delayed_load_element)
          puts delayed_load_element.to_s    if $DEBUG
        end
        puts "DONE_LOAD_FILES_FROM_"+directory.to_s.split(separator_symbol).last.split('.').first.capitalize if $DEBUG

      end

      def error_logger(error_msg,prefix="",log_file=App.log_path)

        ###convert error msg to more human friendly one
        begin
          error_msg= error_msg.to_s.gsub('", "','",'+"\n\"")
        rescue Exception
          error_msg= error_msg.inspect.gsub('", "','",'+"\n\"")
        end

        if File.exists?(File.expand_path(log_file))
          error_log = File.open( File.expand_path(log_file), "a+")
          error_log << "\n#{Time.now} | #{prefix}#{":" if prefix != ""} #{error_msg}"
          error_log.close
        else
          File.new(File.expand_path(log_file), "w").write(
              "#{Time.now} | #{prefix}#{":" if prefix != ""} #{error_msg}"
          )
        end

        return {:error => error_msg}
      end

      def load_ymls(directory,*args)
        arg= Hash[*args]

        require 'yaml'
        #require "hashie"

        arg[:monkey_patch]= 0 if arg[:monkey_patch].nil?


        ### GET Pre path + validation
        begin
          #get method callers path
          pre_path = caller[arg[:monkey_patch].to_i].split('.rb:').first+('.rb')
          if !pre_path.include?('/') && !pre_path.include?('\\')
            pre_path = File.expand_path(pre_path)
          end
          separator_symbol= String.new
          pre_path.include?('/') ? separator_symbol = '/' : separator_symbol = '\\'
          pre_path= ((pre_path.split(separator_symbol))-([pre_path.split(separator_symbol).pop])).join(separator_symbol)
        end

        puts "Elements found in #{directory}"                                       if $DEBUG
        puts File.join("#{pre_path}","#{directory}","**","*.yml")                   if $DEBUG
        puts Dir[File.join("#{pre_path}","#{directory}","**","*.yml")].sort.inspect if $DEBUG

        yaml_files = Dir[File.join("#{pre_path}","#{directory}","**","*.yml")].sort

        puts "\nyaml file found: "+yaml_files.inspect                               if $DEBUG

        @result_hash = {}
        yaml_files.each_with_index do |full_path_file_name|


          file_name = full_path_file_name.split(separator_symbol).last.split(separator_symbol).first

          hash_key = file_name
          @result_hash[hash_key] = YAML.load(File.read("#{full_path_file_name}"))

          #@result_hash = @result_hash.merge!(tmp_hash)


          puts "=========================================================="      if $DEBUG
          puts "Loading "+file_name.to_s.capitalize+"\n"                         if $DEBUG
          puts YAML.load(File.read("#{full_path_file_name}"))                    if $DEBUG
          puts "__________________________________________________________"      if $DEBUG

        end

        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"         if $DEBUG
        puts "The Main Hash: \n"+@result_hash.inspect.to_s                       if $DEBUG
        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"       if $DEBUG

        return @result_hash
      end

      def create_on_filesystem(route_name,optionable_file_mod="w",optionable_data=nil)
        begin

          #file_name generate
          if !route_name.to_s.split(File::SEPARATOR).last.nil? || route_name.to_s.split(File::SEPARATOR).last != ''
            file_name = route_name.to_s.split(File::SEPARATOR).last
          else
            file_name = nil?
          end
                    
          #path_way
          begin
            raise ArgumentError, "missing route_name: #{route_name}"   if route_name.nil?
            path = File.expand_path(route_name).to_s.split(File::SEPARATOR)
            path = path - [File.expand_path(route_name).to_s.split(File::SEPARATOR).last]
            path.shift
          end

          #job
          begin
            if !Dir.exists?(File::SEPARATOR+path.join(File::SEPARATOR))

              at_now = File::SEPARATOR
              path.each do |dir_to_be_checked|

                at_now += "#{dir_to_be_checked+File::SEPARATOR}"
                Dir.mkdir(at_now) if !Dir.exists?(at_now)

              end
            end
          end

          #file_create
          File.new("#{File::SEPARATOR+path.join(File::SEPARATOR)+File::SEPARATOR}#{file_name}", optionable_file_mod ).write optionable_data

        rescue Exception => ex
          puts ex
        end
      end

      def clone_mpath(original_path,new_name)
        log_path = File.expand_path(original_path)
        log_path = log_path.split(File::SEPARATOR)
        log_path.pop
        log_path.push(new_name)
        log_path = log_path.join(File::SEPARATOR)
        return log_path
      end

    end
  end

  ### Config
  begin
    class App
      class << self
        attr_accessor :log_path,
                      :pid_path,
                      :daemon_stderr,
                      :exceptions,
                      :exlogger,
                      :app_name,
                      :port,
                      :terminate
      end
    end
  end

  ### Default
  begin
    App.log_path   = "./var/log/logfile.log"
    App.pid_path   = "./var/pid/pidfile.pid"
    #App.terminate  = false
    #App.port       = 80
    App.app_name   = $0

    begin
      ['daemon_stderr','exceptions','exlogger'].each do |one_log|

        App.__send__(one_log+"=",clone_mpath(App.log_path,one_log+".log"))

      end
    end

  end

end
