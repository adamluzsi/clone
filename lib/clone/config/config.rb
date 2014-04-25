module General

  ### Create Singleton for config params
  class SampleConfig
    class << self
      attr_accessor :module_name,
                    :class_name,
                    :samples_path,
                    :structured,
                    :yml_file_path,
                    :yml_data,
                    :cmd_file_name,
                    :readme_file_names,
                    :special_file_names
    end
  end

end

