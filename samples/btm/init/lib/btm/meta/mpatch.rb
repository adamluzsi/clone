module Ruote
  module LocalParticipant
    def self.included(base)
      @classes ||= Array.new
      @classes.push base.name.constantize
    end
    def self.classes
      @classes
    end
  end
end
module Ruote
  class Participant
    def self.inherited(base)
      @classes ||= Array.new
      @classes.push base.name.constantize
    end
    def self.classes
      @classes
    end
  end
end
class BTM
  def self.register_all!
    ### generate participant names
    begin
      participants = Array.new
      [Ruote::LocalParticipant,
       Ruote::Participant
      ].each do |class_name|
        if !class_name.classes.nil?
          participants+= class_name.classes
        end
      end
    end
    ### Participant register
    begin
      ### Go through the participant name collection
      participants.each do |one_participant_class|
        begin
          participant_reg_name= one_participant_class.to_s.underscore
          if participant_reg_name.split('/')[0].include? "participants"
            participant_reg_name= participant_reg_name.split('/')
            participant_reg_name= participant_reg_name[1..(participant_reg_name.count-1)].join('/')
          end
          BTM.engine.register_participant participant_reg_name,
                                          one_participant_class
        rescue Exception => ex
          puts "An error occurred while registering local participant:\n#{ex}"
          ex.logger
        end
      end
    end
  end
end
