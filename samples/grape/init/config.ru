###load_Grape_API
Rack::Handler::Thin.run REST::API,:Port => get_port(THIN_CONFIG['tcp']['min'],THIN_CONFIG['tcp']['max'])