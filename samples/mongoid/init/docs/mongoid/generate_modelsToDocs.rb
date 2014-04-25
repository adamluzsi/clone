require_relative File.join("..","..","boot.rb")

write_out_array= Array.new
begin
  puts "\n"
  separator= "="*0#*99
  Mongoid::Document.classes.each do |class_name|
    puts separator
    write_out_array.push separator
    puts "the model name:#{class_name}"
    write_out_array.push "the model name:#{class_name}"
    begin
    puts "the embeds model:"+(class_name.constantize.getPaths).inspect
    write_out_array.push "the embeds model:"+(class_name.constantize.getPaths).inspect
    rescue NoMethodError
    end
    class_name.constantize.properties.each do |key,value|
      printf "%-78s %s\n", "The field name: #{key}", "field type: #{value}"
      write_out_array.push("The field name: #{key},\t                       field type: #{value}")
    end
    puts separator
    write_out_array.push separator
  end
end
File.new("models_docs.txt","w").write write_out_array.join("\n")