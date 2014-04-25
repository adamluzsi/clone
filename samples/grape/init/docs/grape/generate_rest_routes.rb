require_relative File.join("..","..","boot.rb")
write_out_array = Array.new
write_out_array.push "REST::API ROUTES:\n"
write_out_array.push "\nTable Of Contents\n================="

array_of_hash = Array.new
REST::API.routes.map do |route|
  array_of_hash.push({:method => route.route_method.to_s, :path => route.route_path.to_s})
end
contents_array= Array.new
array_of_hash.each do |hash|
  separator_str= String.new
  if hash[:method].to_s == "POST" || hash[:method].to_s == "DELETE"
    separator_str= "\t\t   "
  else
    separator_str= "\t\t\t   "
  end
  contents_array.push "#{hash[:method]}#{separator_str}#{hash[:path]}"
end
write_out_array.push contents_array.join("\n")
write_out_array.push "\nExplanations\n============"
REST::API.routes.map do |route|
  new_docs_element= Array.new
  new_docs_element.push "Method:      #{route.route_method}"
  new_docs_element.push "Path:        #{route.route_path}"
  new_docs_element.push "description: #{route.route_description}"
  if route.route_params.count == 0
    new_docs_element.push "No specified or special params"
  else
    route.route_params.each do |key,value|
      new_docs_element.push " -#{key}: #{value}"
    end
  end
  new_docs_element.push "\n"
  write_out_array.push new_docs_element.join("\n")
end
File.new("routes_docs.txt","w").write write_out_array.join("\n")
