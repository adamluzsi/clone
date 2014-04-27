#encode: UTF-8
project_path= ARGV.shift
if ARGV == Array.new
  puts "you forget mark extension names, type \"--all\" if you want all type"
  Process.exit!
end

project_file_extensions= ARGV.join(',')
line_number= 0

target_files= nil
if ARGV.include? "--all"
  target_files= "*"
else
  target_files= "*.{#{project_file_extensions}}"
end

Dir.glob(File.join(project_path, "**",target_files)).uniq.each do |filename|

  begin
    unless File.directory?(filename)
      count = 0
      File.open(filename) {|f| count = f.read.count("\n")}
      line_number += count
    end
  rescue Exception
  end

end

puts "target project folder files with #{project_file_extensions} "+
         "extensions are:\n\t#{line_number}"
