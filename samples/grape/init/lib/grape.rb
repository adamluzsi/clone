require 'grape-dsl'
require 'grape'
require 'argv'

### Load Grape API parts
require_relative_directory_r File.join "grape","vendors"
require_relative_directory_r File.join "grape","mount"

if ARGV.to_hash(m:true,s:true)[:generate].include?(:grape)

  Grape.create_wiki_doc path: (File.join(Dir.pwd,"README")),
                        type: :github

end
