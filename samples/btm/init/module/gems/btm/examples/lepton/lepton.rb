#Lepton tranzakcios pelda

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require 'ruote'	
# require 'btm'
Bundler.require(:default, :development)


BTM.start!

BTM.participant 'lepton_authentication' do |workitem|
	puts "Run: lepton_authentication"
end

BTM.participant 'lepton_authorization' do |workitem|
	puts "Run: lepton_authorization"
end

BTM.participant 'lepton_billing' do |workitem|
	puts "Run: lepton_billing"
end

BTM.participant 'lepton_capture' do |workitem|
	puts "Run: lepton_capture"
end

BTM.participant 'lepton_payment' do |workitem|
	puts "Run: lepton_payment"
end

BTM.participant 'lepton_settelment' do |workitem|
	puts "Run: lepton_settelment"
end

BTM.definition :lepton_transaction do
  sequence do
	participant :ref =>'lepton_authentication'
	participant :ref =>'lepton_authorization'
	concurrence do
	  participant :ref =>'lepton_capture'
	  participant :ref =>'lepton_billing'
	  participant :ref =>'lepton_payment'
	end
	participant :ref =>'lepton_settelment'
  end
end

#puts BTM.participant_list
#puts BTM.definition_list

fields = Hash.new
variables = Hash.new 

BTM.launch(:lepton_transaction, fields, variables)

sleep 10
BTM.stop!
