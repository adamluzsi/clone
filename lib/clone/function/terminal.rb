##encoding: UTF-8
#module Clone
#
#  def self.terminal
#
#    ##require File.join "rubygems"
#    require File.join "commander", "import"
#
#    begin
#      ### Program runtime parameters
#      program :name, "#{self.to_s.split('::')[0].downcase}"
#      program :version, VERSION.show
#      program :description, "#{self.to_s.split('::')[0].downcase} commandline control"
#
#      #command :set do |c|
#      #  c.syntax = "#{self.to_s.split("::")[0].downcase} set --option value"
#      #  c.description = "help configure the generator params"
#      #  c.option "--structured true/false" , String , "set, that does generating follow the samples folder structure or not"
#      #  c.action do |args, options|
#      #
#      #    if !options.structured.nil?
#      #      if    options.structured == "true"
#      #        SampleConfig.yml_data['structured']= true
#      #        Yaml.set SampleConfig.yml_data
#      #      elsif options.structured == "false"
#      #        SampleConfig.yml_data['structured']= false
#      #        Yaml.set SampleConfig.yml_data
#      #      else
#      #        puts "undefined value for structured option:\n\tuse 'true' or 'false'"
#      #      end
#      #    end
#      #
#      #  end
#      #end
#
#      [:build,:generate,:gen].each do |one_sym|
#
#        command one_sym.to_sym do |c|
#
#          if one_sym == :build
#            c.syntax = "#{self.to_s.downcase} generate cat cmd name str or --cat name --cmd name --name file_name --str true/false"
#            c.description= [
#                "help Generate samples from the sample collection\n\t",
#                    "categories:\n\t\t#{show_categories.gsub(':','')}",
#                    "\n\tcommands:\n\t\t#{show_commands.gsub(':','')}",
#                    "\n\tDescriptions:\n\n\t\t#{show_readmes}"
#            ].join
#
#
#          else
#            c.syntax=      "same for build command"
#            c.description= "alias for build command"
#          end
#
#          [
#              {tag: "--name file_name",   desc: "choose file name, this is optionable, not required"},
#              {tag: "--cat category_name",desc: "choose the category"},
#              {tag: "--cmd command_name", desc: "choose the command"},
#              {tag: "--str true/false",   desc: "choose to either you want or not keep sample structure or generate everything in place"}
#
#          ].each{|hash| c.option( hash[:tag], (hash[:type] || String ),hash[:desc] ) }
#          c.option "--debug"
#
#          c.action do |args, options|
#
#            if options.debug
#              $DEBUG = true
#            end
#
#            ### Get options or else args
#            begin
#              if (options.cat).nil?
#                category = args[0]
#              else
#                category = options.cat
#              end
#              if (options.cmd).nil?
#                command = args[1]
#              else
#                command = options.cmd
#              end
#              if (options.name).nil?
#                file_name = args[2]
#              else
#                file_name = options.name
#              end
#              if (options.str).nil?
#                structured = args[3]
#              else
#                structured = options.str
#              end
#            end
#
#            ### Do the job
#            begin
#              command_for_sample_generate :category   => category,
#                                          :command    => command,
#                                          :structured => structured,
#                                          :file_name  => file_name
#            end
#
#
#
#          end
#        end
#
#
#      end
#
#    end
#
#  end
#
#end
