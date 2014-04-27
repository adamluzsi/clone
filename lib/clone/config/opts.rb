module Clone

  module OPTS
    class << self

      def config_file_path
        File.join(File.dirname(__FILE__),"opts.yaml")
      end

      def config_file_obj
        var= ::YAML.safe_load(File.read(config_file_path))

        [FalseClass,NilClass].each{ |errcls|
          raise(ArgumentError) if var.class == errcls }

          return var

      rescue Errno::ENOENT, Psych::SyntaxError, ArgumentError
        return {}
      end

      def get_sample_path_default
        File.expand_path(File.join(File.dirname(__FILE__),"..","..","..","samples"))
      end

      def get_sample_path
        config_file_obj['path'] || get_sample_path_default
      end

      def set_sample_path path
        yaml_hash = config_file_obj || {}

        if path.class <= String
          yaml_hash['path']= path
          @@sample_path= path
          File.write(config_file_path,yaml_hash.to_yaml)
        end

        return path
      end

      def sample_path path= nil
        set_sample_path(path) if path
        @@sample_path ||= get_sample_path
      end

      def exception_file_names
        "cmd.yml"
      end
      alias :exceptions :exception_file_names

    end
  end

end