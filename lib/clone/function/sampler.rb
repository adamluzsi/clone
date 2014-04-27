module Clone

  module Functions

    def categories
      Dir.glob( File.join(OPTS.sample_path, '*')).
          select{|p| File.directory?(p) }.
          map{|p| p.split(File::Separator).last }

    end

    def commands category
      Dir.glob( File.join(OPTS.sample_path,category,'*')).
          select{|p| File.directory?(p) }.
          map{|p| p.split(File::Separator).last }

    end

    def get_cmd_obj category,command
      var= ::YAML.safe_load(File.read(File.join(OPTS.sample_path,category,command,"cmd.yml")))
      [FalseClass,NilClass].each{ |errcls|
        raise(ArgumentError) if var.class == errcls }




    rescue Errno::ENOENT, Psych::SyntaxError, ArgumentError
      return {}
    end

    def build_command category,command

      Dir.glob( File.join(OPTS.sample_path,category,command,"**","*") ).
      #select{|p| var=(true);OPTS.exceptions.each{|ex| var=(false) if p.include?(ex)};var}.
      select{|p| p.include?(OPTS.exceptions) }.
      select{|p| !File.directory?(p) }.
      each do |path|
        puts path
      end

    end

  end

  self.extend Functions

end


Clone.build_command(
    Clone.categories.first,
    Clone.commands(Clone.categories.first).first
)

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