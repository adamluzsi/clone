
### load meta-s
def meta_load

  ### find elements
  begin
    Dir.glob( File.join(Dir.pwd, "lib", "**","meta" ,"*.rb") ).each do |one_rb_file|
      require one_rb_file
    end
  end

end

### mount libs
def mount_libs

  ### check dirs
  begin

    if Application.environment.nil?
      Application.environment= "development"
    end

  end

  ### load lib files
  begin
    Dir.glob(File.join(Dir.pwd, "lib","*.{rb,ru}")).uniq.each do |one_rb_file|
      require one_rb_file
    end
  end

end

### Offline repo activate
def mount_modules
  $LOAD_PATH << (File.expand_path(File.join(File.dirname(__FILE__),"..","..","module","gems")))
end

### #Return File_name:File_path
def get_files(folder)

  ### Pre def. variables
  begin
    files = Hash.new
  end

  ### Validation
  begin
    ### Check that does the folder is absolute or not
    if folder != File.expand_path(folder)
      folder =  File.expand_path(folder)
    end
  end

  ### Get Files list
  begin
    Dir[File.join(folder,'**','*')].uniq.each do |file_path|
      if !File.directory? file_path
        files[file_path.split(File::SEPARATOR).last.to_sym]= file_path
      end
    end
  end

  ### Return file_name:folder
  return files
end

### require by absolute path directory's files
def require_directory(folder)
  get_files(folder).each do |file_name,file_path|
    puts "file will be loaded: #{file_name} from\n\t#{file_path}" if $DEBUG
    if file_path.split('.').last == 'rb'
      load file_path
    end
  end
end

### require sender relative directory's files
def require_relative_directory(folder)

  ### pre format
  begin

    path= caller[0].split('.rb:').first.split(File::SEPARATOR)
    path= path[0..(path.count-2)]

    if !File.directory?(path.join(File::SEPARATOR))
      path.pop
    end

    path= File.join(path.join(File::SEPARATOR))

    if path != File.expand_path(path)
      path= File.expand_path(path)
    end

    path= File.join(path,folder)

  end

  ### find elements
  begin
    tmp_array = Array.new
    get_files(path).sort.each do |file_name,file_path|
      if file_path.split('.').last == 'rb'
        tmp_array.push file_path
      end
    end
  end

  ### after format
  begin
    tmp_array.uniq!
    tmp_array.sort!
    tmp_array.each do |full_path_to_file|
      load full_path_to_file
    end
  end

end

### generate config from yaml
def generate_config(target_config_hash= Application.config)

  ### defaults
  begin
    require "yaml"
    if target_config_hash.class != Hash
      target_config_hash= Hash.new()
    end
  end

  ### find elements
  begin

    Dir.glob(File.join(Dir.pwd, "lib", "**","meta" ,"*.{yaml,yml}")).each do |config_object|

      ### defaults
      begin
        config_name_elements= config_object.split(File::SEPARATOR)
        type=     config_name_elements.pop.split('.')[0]
        config_name_elements.pop
        category= config_name_elements.pop
        tmp_hash= Hash.new()
        yaml_data= YAML.load(File.open(config_object))
      end

      ### processing
      begin
        if target_config_hash[category].nil?
          target_config_hash[category]= { type => yaml_data }
        else
          target_config_hash[category][type]= yaml_data
        end
      end

    end

  end

  ### update by config yaml
  begin


    config_yaml_paths= Dir.glob(File.join(Dir.pwd, "{config,conf}","*.{yaml,yml}")).uniq

    puts config_yaml_paths.inspect



























    #Array.new.each do |config_object|
    #
    #  if config_object.include?('default')
    #
    #    ### defaults
    #    begin
    #      config_name_elements= config_object.split(File::SEPARATOR)
    #      type=     config_name_elements.pop.split('.')[0]
    #      config_name_elements.pop
    #      category= config_name_elements.pop
    #      tmp_hash= Hash.new()
    #      yaml_data= YAML.load(File.open(config_object))
    #    end
    #
    #    puts yaml_data.inspect
    #
    #    ### processing
    #    begin
    #      if target_config_hash[category].nil?
    #        target_config_hash[category]= { type => yaml_data }
    #      else
    #        target_config_hash[category][type]= yaml_data
    #      end
    #    end
    #
    #
    #  end
    #
    #end


    #Dir.glob(File.join(Dir.pwd, "{config,conf}","*.{yaml,yml}")).each do |one_env|
    #
    #end

  ### something like #> search yml commands for config env variable to config data
  #begin
  #  unless $ENV.nil?
  #
  #  end

  end

end
