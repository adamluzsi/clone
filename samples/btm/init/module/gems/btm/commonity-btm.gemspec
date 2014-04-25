Gem::Specification.new do |s|
  s.name        = 'commonity-btm'
  s.version     = '2.0'
  s.date        = Time.now.to_s.split(' ')[0]
  s.summary     = "Business Transaction Manager"
  s.description = "PPT Group Kft. - Commonity BTM"
  s.authors     = ["Zsolt Tasnadi"]
  s.email       = 'zsolt.tasnadi@ppt.eu'
  s.files       = [
				  "lib/btm.rb",
				  "lib/btm/definition.rb", 
				  "lib/btm/init.rb", 
				  "lib/btm/log.rb",
				  "lib/btm/monitor.rb", 
				  "lib/btm/participant.rb",
				  "lib/btm/transaction.rb"
				  ]
  s.homepage    = 'http://ppt.eu'
  s.add_dependency 'mongoid'
  s.add_dependency 'ruote'
  s.add_dependency 'ruote-mon'
  
end
