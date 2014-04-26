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

  ### Offline repo activate
  begin
    $LOAD_PATH << (File.expand_path(File.join(File.dirname(__FILE__),"..","..","..","module","gems")))
  end

end