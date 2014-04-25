begin

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

    path = (caller[0].split('.rb:').first+('.rb')).split(File::SEPARATOR)
    path = path[0..(path.count-2)]
    tmp_array = Array.new

    get_files(File.expand_path(File.join(path,folder))).sort.each do |file_name,file_path|
      puts "file will be loaded: #{file_name} from\n\t#{file_path}" if $DEBUG
      if file_path.split('.').last == 'rb'
        tmp_array.push file_path
      end
    end

    tmp_array.uniq!
    tmp_array.sort!
    tmp_array.each do |path|
      load path
    end

  end

  ### Offline repo activate
  begin
    $LOAD_PATH << (File.expand_path(File.join(File.dirname(__FILE__),"..","..","..","module","gems")))
  end

end