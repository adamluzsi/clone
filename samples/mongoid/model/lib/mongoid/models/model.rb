module MODULE
  class CLASS
    include Mongoid::Document #; include Mongoid::Timestamps  #; include Mongoid::Paranoia

    store_in :collection => (self.to_s.split('::').last) #, :session => "default"

    #embeds_many :target_class_name
    #embeds_one  :target_class_name

    #field      :name,
    #           :type => String,
    #           :default => "Hello World!"

    #validates  :name,
    #           :presence => true


    ### you can validate here the fields
    #self.fields.keys.each do |key|
    #  validates  key.to_sym,
    #             presence: true
    #end

    ### you can set here that only fields can be saved to db
    #attr_accessible *fields.keys

  end
end
