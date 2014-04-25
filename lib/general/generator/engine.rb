module General
  begin
    class << self
      ### Generator method parts
      begin

        ### Get exception files list #Return Array
        def get_exceptions

          return_array= Array.new
          return_array= SampleConfig.readme_file_names
          return_array.push SampleConfig.cmd_file_name

          return return_array
        end

        ### Get Directory list #Return Hash  name:path
        def get_directories(path)
          #### Get Directories list
          begin

            ### Check that does the path is absolute or not
            if path != File.expand_path(path)
               path =  File.expand_path(path)
            end

            ### Generate directory lists with absolute paths
            directories = Hash.new
            Dir[File.join( path, '**')].uniq.each do |file_path|
              if File.directory? file_path
                directories[file_path.split(File::SEPARATOR).last.to_sym]= file_path
              end
            end

            return directories
          end
        end

        ### Get files from path #Return Hash name:path
        def get_files(path)

          ### Pre def. variables
          begin
            files           = Hash.new
          end

          ### Validation
          begin
            ### Check that does the path is absolute or not
            if path != File.expand_path(path)
              path =  File.expand_path(path)
            end
          end

          ### Get Files list
          begin
            Dir[File.join(path,'**','*')].uniq.each do |file_path|
              if !File.directory? file_path
                files[file_path.split(File::SEPARATOR).last.to_sym]= file_path
              end
            end
          end

          return files
        end

        ### Show Category list #Return: Hash
        def get_categories_hash(root=SampleConfig.samples_path)
          begin
            get_directories root
          rescue Errno::ENOENT
            ### nothing to do! YAY...
            return nil
          end
        end

        ### Show Category participants name in a array
        def show_categories(is_array=false,root=SampleConfig.samples_path)
          begin

            return_array = Array.new
            get_categories_hash(root).each do |one_file_name,one_file_path|
              return_array.push one_file_name
            end

            if is_array
              return return_array
            else
              return return_array.join(', ')
            end


          rescue Errno::ENOENT
            ### nothing to do! YAY...
            return nil
          end
        end

        ### Show Category commands
        def get_commands_hash(category_name,root=SampleConfig.samples_path)

          get_categories_hash(root).each do |file_name,file_path|
            if file_name.to_s.downcase == category_name.to_s.downcase
              return get_directories file_path
            end
          end

        end

        ### Get command structure by file_data_array:file_path
        def get_command_structure(category_name,command_name)

          files_hash = Hash.new
          get_commands_hash(category_name).each do |directory_name,directory_path|
            if directory_name.to_s.downcase == command_name.to_s.downcase

              get_files(directory_path).each do |file_name,file_path|
                tmp_string_array = Array.new

                ## Read data out from the file
                File.open(file_path).each do |one_line|
                  tmp_string_array.push one_line
                end

                ### Make hash with the data String:Path
                ## generate dynamic path cutter length
                begin

                  cut_from =  SampleConfig.samples_path.to_s.length+1+\
                              category_name.to_s.length+1+\
                              command_name.to_s.length+1

                  cut_to   = file_path.to_s.length-1

                end

                ## Do the hash populate
                files_hash[tmp_string_array]=file_path[cut_from..cut_to]

              end

            end
          end

          return files_hash

        end

        ### Show Category commands
        def show_commands(category_name=nil,is_array=false,root=SampleConfig.samples_path)

          sum_array  = Array.new
          merge_hash = Hash.new
          get_categories_hash(root).each do |category,path_to_category|

            tmp_array=Array.new
            if category_name.nil?
              get_directories(path_to_category).each do |file_name,file_path|
                tmp_array.push file_name
              end
            else
              if file_name.to_s.downcase == category_name.to_s.downcase
                get_directories(path_to_category).each do |file_name,file_path|
                  tmp_array.push file_name
                end
              end
            end
            merge_hash[category]=tmp_array

            tmp_array.each do |one_element_of_tmp_array|
              sum_array.push one_element_of_tmp_array
            end

          end

          ### Return the value
          if is_array
            return sum_array
          else
            return_string = String.new
            merge_hash.each do |category,elements|
              return_string+= "In "+category.to_s+ ": " + elements.inspect + ", "
            end
            return_string[return_string.length-2]=String.new

            return return_string
          end
        end

        ### Show readmes from categories
        def show_readmes(*args)
          arg=Hash[*args]

          ### Set default variables
          begin

            arg[:root]    ||= SampleConfig.samples_path
            arg[:readme]  ||= SampleConfig.readme_file_names
            ready_paths   = Array.new
            tmp_array     = Array.new

            ## Make readme-s united
            if arg[:readme].class != Array
              arg[:readme] = [arg[:readme]]
            end

          end

          ### Start searching for readme
          begin
            get_categories_hash(arg[:root]).each do |category_name,category_path|

              ### Get category readme list
              begin
                tmp_array.push "\n"
                Dir[File.join(category_path,'*')].uniq.each do |category_file_path|
                  #if !File.directory? category_file_path
                    if arg[:readme].include? category_file_path.split(File::SEPARATOR).last
                      tmp_array.push "\t\t#{category_name.upcase}:\n"
                      File.open(category_file_path).each do |one_line|
                        tmp_array.push "\t\t\t#{one_line}"
                      end
                      tmp_array.push "\n"
                      ready_paths.push category_file_path
                    end
                  #end
                end
              end

              ### Get category commands readme list
              begin
                Dir[File.join(category_path,'**','*')].uniq.each do |category_file_path|
                  if !File.directory? category_file_path
                    if !ready_paths.include? category_file_path
                      if arg[:readme].include? category_file_path.split(File::SEPARATOR).last
                        tmp_array.push "\n"
                        recursive_path= category_file_path[(category_path.length+1)..(category_file_path.length-1)]
                        tmp_array.push "\t\t#{category_name.upcase}/#{recursive_path.split(File::SEPARATOR)[0]}:\n"
                        File.open(category_file_path).each do |one_line|
                          tmp_array.push "\t\t\t#{one_line}"
                        end
                        tmp_array.push "\n"
                        ready_paths.push category_file_path
                      end
                    end
                  end
                end
              end

            end
          end

          return tmp_array.join()
        end

        ### this will only update bootfile isntead deleting the data
        def update_special_file(create_path,input_string_array)

          ### default variables
          begin
            data_string = String.new
            file_mod    = "w"
          end

          ### Update!
          begin

            ### File write prepare
            begin

              if !File.exist?(create_path)
                File.create :path     => create_path,
                            :data     => String.new,
                            :file_mod => file_mod
              end

              begin

                merge_code = Array.new
                source_code = String.new

                ### Create the old code block!
                File.open(create_path).each do |one_line_of_source_code|
                  if one_line_of_source_code.gsub(' ','') != "\n"
                    merge_code.push one_line_of_source_code
                    source_code += one_line_of_source_code
                  end
                end

                ### add a seperator line to the code
                begin
                  merge_code.push "\n"
                end

                ### Adding new lines
                input_string_array.each do |target_line|
                  if !source_code.include? target_line
                    #puts target_line
                    merge_code.push target_line
                  end
                end

                ### sub complete file data
                data_string = merge_code.join
              end

            end

            ### File Write
            begin

              ### prepeare data
              begin
                new_data=  "\n"
                new_data+= data_string
              end

              File.open(create_path,file_mod) do |file|
                file.write new_data
              end



              #File.create :path     => create_path,
              #            :data     => data_string,
              #            :file_mod => file_mod
            end

          end

        end

        ### Clone a command from the sample collection
        def clone_sample(*args)
          arg=Hash[*args]
          begin

            ### 'Exception' throw
            begin

              ### Check the two important argument
              if arg[:category].nil? || arg[:command].nil?
                if arg[:command].nil?
                  puts "missing chosen command"
                end
                if arg[:category].nil?
                  puts "missing chosen category"
                end

                return nil
              end

            end

            ### Generate Defaults
            begin

              ### method variables
              begin

                ##structured
                begin
                  if    arg[:structured] == "true"
                        arg[:structured]= true
                  elsif arg[:structured] == "false"
                        arg[:structured]= false
                  else
                        arg[:structured]= nil
                  end
                end

                arg[:file_name]  ||= String.new
                arg[:structured] ||= SampleConfig.yml_data['structured']
                arg[:root]       ||= SampleConfig.samples_path
                #arg[:command]   ||= "participant"
                #arg[:category]  ||= "general"
                #arg[:module]    ||= nil
                #arg[:class]     ||= nil
                #arg[:file_name] ||= nil

              end

              ### local variables
              begin

                samples = Hash.new

              end

            end

            ### Create samples
            begin

              ### Generate sample from structure #=> String:short_path
              begin

                ### Generate Structure
                get_command_structure(arg[:category],arg[:command]).each do |data_array,short_path|

                  ### Some dynamical value set
                  begin

                    ### Generate Auto Module name
                    if arg[:module].nil? || arg[:file_name]==String.new
                      module_name = short_path.split(File::SEPARATOR).pinch.last.split('.')[0].downcase.capitalize
                    else
                      module_name = arg[:module]
                    end

                    ### Generate Auto Class name
                    if arg[:file_name].nil? || arg[:file_name]==String.new
                      class_name = short_path.split(File::SEPARATOR).last.split('.')[0].downcase.capitalize
                    else
                      class_name = arg[:file_name].downcase.capitalize
                    end


                    ### Generate Auto Resource name
                    if arg[:file_name].nil? || arg[:file_name]==String.new
                      resource_name = short_path.split(File::SEPARATOR).last.split('.')[0].downcase
                    else
                      resource_name = arg[:file_name].downcase
                    end

                  end

                  ### do the data_array formation/replace
                  begin
                   begin
                    linenmb=0
                    data_array.each do |one_line|
                      data_array[linenmb]= data_array[linenmb].gsub(
                          SampleConfig.yml_data['module_name'],module_name
                      ).gsub(
                          SampleConfig.yml_data['class_name'],class_name
                      ).gsub(
                          SampleConfig.yml_data['resource_name'],resource_name
                      )
                      linenmb+=1
                    end
                   rescue ArgumentError
                   end

                  end

                  ### Populate_hash
                  begin

                    samples[data_array]= File.expand_path short_path

                  end

                end

              end

              ### Create files on filesystem
              begin

                file_created = 0
                samples.each do |final_string_array,short_path|

                  extension  = String.new
                  if short_path.include? '.'
                    extension= '.'+short_path.split('.').last
                  end

                  begin
                    begin
                      if arg[:file_name] != String.new && !arg[:file_name].nil?
                        arg[:file_name]= "_"+arg[:file_name]
                      end
                    end
                    file_path= short_path.split(File::SEPARATOR).pinch.join(File::SEPARATOR)
                    file_name= (short_path.split(File::SEPARATOR).last.split('.')[0]+arg[:file_name])+extension
                  end

                  if arg[:structured]
                    create_path = File.join(
                        file_path,file_name
                    )
                  else
                    create_path = File.join(
                        short_path.split(File::SEPARATOR).last.split('.')[0]+
                            arg[:file_name]+file_created.to_s+extension
                    )
                  end

                  ### Create the File!
                  if SampleConfig.special_file_names.include?(create_path.split(File::SEPARATOR).last)
                    update_special_file(create_path,final_string_array)
                  else
                    if !get_exceptions.include? short_path.split(File::SEPARATOR).last
                      if File.exist?(create_path)
                        puts "File already exist at #{create_path}" if $DEBUG
                      else
                        File.create :path => create_path,
                                    :data => final_string_array.join
                      end
                    end
                  end
                file_created+=1
                end

              end

            end

          end
        end

        ### after part for command launch
        def extension_command(*args)
          arg=Hash[*args]
          begin
            get_command_structure(arg[:category],arg[:command]).each do |file_string,short_path|

              file_path = File.join(SampleConfig.samples_path,arg[:category],arg[:command],short_path)
              file_name = file_path.split(File::SEPARATOR).last
              if file_name == SampleConfig.cmd_file_name
                (YAML.load(File.open(file_path))).each do |category,command|

                  clone_sample :category   => category.to_s,
                               :command    => command.to_s,
                               :file_name  => arg[:file_name],
                               :structured => arg[:structured]

                end
              end
            end
          end
        end

        ### Prev part for command launch
        def command_for_sample_generate(*args)
          arg=Hash[*args]

          ### variables
          begin
            #:category
            #:command
            #:structured
            #:file_name
          end

          ## validation and job
          begin

            extension_command :category       => arg[:category],
                              :command        => arg[:command],
                              :file_name      => arg[:file_name],
                              :structured     => arg[:structured]

            clone_sample :category       => arg[:category],
                         :command        => arg[:command],
                         :file_name      => arg[:file_name],
                         :structured     => arg[:structured]

          end

        end

      end
    end
  end
end



=begin
implementations:

            #rescue Exception

              #require 'fileutils'
              #
              ##def copy_with_path(src, dst)
              #  FileUtils.mkdir_p(File.dirname())
              #  FileUtils.cp(src, dst)
              ##end

=end