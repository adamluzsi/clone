module Clone
  require 'yaml'

  ### YML control
  begin
    class Yaml
      class << self

        def set(config_hash)
            SampleConfig.yml_data = config_hash
            File.open(SampleConfig.yml_file_path, 'w+') {|f| f.write(SampleConfig.yml_data.to_yaml) }
        end

        def load(file_path=SampleConfig.yml_file_path)
            SampleConfig.yml_data = YAML.load(File.open(file_path))
        end

      end
    end
  end

end