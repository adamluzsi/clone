# coding: utf-8

Gem::Specification.new do |spec|

  spec.name          = "clone"
  spec.version       = File.open(File.join(File.dirname(__FILE__),"VERSION")).read.split("\n")[0].chomp.gsub(' ','')
  spec.authors       = ["Adam Luzsi"]
  spec.email         = ["adamluzsi@gmail.com"]
  spec.description   = %q{ File system based sample cloner. You can build new projects with it, or merge,reuse parts from one or other. }
  spec.summary       = %q{ Tool making projects from samples and vice versa }

  spec.homepage      = "https://github.com/adamluzsi/clone"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_dependency "commander"

end
