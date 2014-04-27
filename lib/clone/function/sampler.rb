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

    def build_command category,command

      Dir.glob( File.join(OPTS.sample_path,category,command,"**","*") ).each do |path|
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