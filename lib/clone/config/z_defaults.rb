module General

  ### Set Defaults
  begin

    ### Set basic paths
    begin
      SampleConfig.samples_path  = File.expand_path(File.join(File.dirname(__FILE__),"..","..","..","samples"))
      SampleConfig.yml_file_path = File.expand_path(File.join(File.dirname(__FILE__),"config.yml"))
    end

    ### Yml data
    begin
      Yaml.load
    end

    ### Config params
    begin
      SampleConfig.class_name         = SampleConfig.yml_data['class_name']
      SampleConfig.module_name        = SampleConfig.yml_data['module_name']
      SampleConfig.cmd_file_name      = SampleConfig.yml_data['cmd_file_name']
      SampleConfig.readme_file_names  = SampleConfig.yml_data['readme_file_names']
      SampleConfig.special_file_names = SampleConfig.yml_data['special_file_names']
    end

  end

end