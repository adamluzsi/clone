Dir[File.expand_path(File.join(File.dirname(__FILE__),"..","**","*"))].sort.uniq.each do |one_file_path|
  if !File.directory? one_file_path
    if one_file_path.split('.').last == "rb" || one_file_path.split('.').last == "ru"

      ### Create tmp files
      begin
        tmp_array     = Array.new
        tmp_string    = String.new
        File.open(one_file_path).each do |one_line|
          tmp_string+=   one_line
          tmp_array.push one_line
        end
      end

      ### Search For Key Words!
      begin
        shebang_found = false
        encode_found  = false
        shebang_found = tmp_string.include?("#!/usr/bin/env ruby")
        encode_found  = tmp_string.include?("#encoding: UTF-8")
      end

      ### Insert Encoding
      begin
        if !encode_found
          if shebang_found
            tmp_array.insert(1, "#encoding: UTF-8\n")
          else
            tmp_array.insert(0,"#encoding: UTF-8\n")
          end
          File.open(one_file_path,"w").write tmp_array.join
        end
      end

    end
  end
end