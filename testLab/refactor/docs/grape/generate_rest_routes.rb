Thread.new do
  load File.expand_path(File.join(File.dirname(__FILE__),"..","..","config.ru"))
end

sleep 11

#<pre><code class="ruby">
#    Place your code here.
#</code></pre>

write_out_array = Array.new
write_out_array.push "h1. Mongo Layer Rest Calls\n"
write_out_array.push "h2. REST::API ROUTES:\n"
write_out_array.push "\n{{>toc}}\n"

REST::API.routes.map do |route|
  new_docs_element= Array.new
  new_docs_element.push "h4.  #{route.route_method.to_s.downcase}/#{route.route_path}\n"
  new_docs_element.push "p((. Method      #{route.route_method}"
  new_docs_element.push "Path  #{route.route_path}"

  ### format
  begin
    new_docs_element.push "Format(s):"

    new_docs_element.push "\n"
    if route.route_content_type.nil?
      if REST::API.content_types.nil?
        new_docs_element.push " - no version specified"
      else
        REST::API.content_types.each do |one_format_type,one_format_header|
          new_docs_element.push " - #{one_format_type} => #{one_format_header}"
        end
      end
    else
      new_docs_element.push " - #{route.route_content_type}"
    end
    new_docs_element.push "\n"

  end


  ### version
  begin
    new_docs_element.push "p((. Version(s):"

    new_docs_element.push "\n"
    if route.route_version.nil?
      if REST::API.versions.nil?
        new_docs_element.push " - no version specified"
      else
        REST::API.versions.each do |one_version|
          new_docs_element.push " - #{one_version}"
        end
      end
    else
      new_docs_element.push " - #{route.route_version}"
    end
    new_docs_element.push "\n"
  end


  new_docs_element.push "p((. description: \n\n #{route.route_description}"

  if route.route_params.count == 0
    new_docs_element.push " No specified or special params"
  else
    new_docs_element.push "\n _*Parameters*_"
    route.route_params.each do |key,value|
      new_docs_element.push "_#{key}_"
      value.each do |value_key,value_value|
        new_docs_element.push " - #{value_key}: #{value_value}"
      end
    end
    new_docs_element.push "\n"
  end

  new_docs_element.push "\n\n"
  write_out_array.push new_docs_element.join("\n")
end
File.new(File.expand_path(File.join(File.dirname(__FILE__),"routes_docs.txt")),"w").write write_out_array.join("\n")

Process.exit
