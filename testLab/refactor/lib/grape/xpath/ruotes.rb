if $DEBUG
  puts "\n\nREST::API ROUTES:"
  REST::API.routes.map do |route|
    putsf 8,"\t#{route.route_method}","#{route.route_path}"
  end
end