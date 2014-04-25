require_relative File.join("..","..","boot.rb")


begin
  relations_array = Array.new
  Mongoid::Document.classes.each do |class_name|
    relations_array.push class_name.constantize.getPaths[0]
  end
  relations_array= relations_array.sort_by{ |hsh| hsh.values }
end
puts relations_array
