require 'rest_client'
params=Hash.new
params['hello']="world!"

RestClient.get "0.0.0.0:8080", :params => params
