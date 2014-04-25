require_relative "../boot.rb"

hash = Hash.new
hash["hello"]="world!"

MODULE::CLASS.update_to_model(hash)

puts "ez pedig nem más mint az adatbázisból nyert adat !",
     MODULE::CLASS.load_from_model
