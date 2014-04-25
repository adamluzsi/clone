require "argv"

#$ ruby sample/test.rb --test test this ok

# new help
ARGV.add_help "heeeelp meeeeee~~~",:no

ARGV.show_help

puts "","original ARGV:",ARGV.inspect,""

puts "hash from argv:",ARGV.to_hash,""
# {"--test"=>"test"}

puts "multi valued hash:",ARGV.to_hash( multi_value: true ),""
# {"--test"=>["test", "this", "ok"]}

puts "sym keyed hash:",ARGV.to_hash( sym_key: true ),""
# {:test=>"test"}

puts "sym keyed multi valued hash:",ARGV.to_hash( s: true, m: true ),""
# {:test=>["test", "this", "ok"]}

puts "argv values without the tags:",ARGV.values.inspect,""
# ["test", "this", "ok"]

puts "argv tags, \"keys\":",ARGV.keys.inspect,""
# ["--test"]

puts "symbolized flags:",ARGV.sym_flags.inspect,""
