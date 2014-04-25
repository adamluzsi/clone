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
end


check_datas=Array.new
("A".."Z").each do |one_letter|
  check_datas.push " :"+one_letter
end

get_files(File.join(File.dirname(__FILE__),"..")).each do |file_path,file_name|

  if !File.directory? file_path
    new_data=Array.new
    File.open(file_path).each do |one_line|
      new_string = nil
      check_datas.each do |one_key_to_Be_replaced|
        new_string ||= one_line
        new_string.gsub!(one_key_to_Be_replaced.upcase,one_key_to_Be_replaced.downcase)
      end
      new_data.push new_string
    end

    File.open(file_path,"w") do |file|
      file.write new_data.join
    end
 



  end

  
end

