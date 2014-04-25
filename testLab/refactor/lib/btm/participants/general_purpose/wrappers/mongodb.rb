module Participants
  module GPP
    class Mongodb

      include Ruote::LocalParticipant

      def on_workitem
        begin

          #========================================|
          ###pdef requested control structure data:|
          #set field: 'mongoid',                   |
          #    value:  {                           |
          #    'model'     => "",                  |
          #    'method'    => "",                  |
          #    'fields'    => %w[strings],         |
          #    "workitems" => {:hash=>"tags"}      |
          #}                                       |
          #========================================|



          #=============================================================================================================

          ###control data check
          raise ArgumentError, "missing contol data!:all"       if workitem.fields['mongoid'].nil?
          raise ArgumentError, "missing contol data!:model"     if workitem.fields['mongoid']['model'].nil?
          raise ArgumentError, "missing contol data!:method"    if workitem.fields['mongoid']['method'].nil?
          raise ArgumentError, "missing contol data!:fields"    if workitem.fields['mongoid']['fields'].nil?
          raise ArgumentError, "missing contol data!:workitems" if workitem.fields['mongoid']['workitems'].nil?

          #=============================================================================================================

          ###Check dbmodel name complexity
          module_name = String.new
          if workitem.fields['mongoid']['model'].to_s.include? "::"
            module_name = workitem.fields['mongoid']['model'].to_s
          else
            module_name = "Models::"+workitem.fields['mongoid']['model'].to_s.downcase.capitalize
          end

          #=============================================================================================================

          ###fill up Fields chech field type
          field_names = Array.new
          if    workitem.fields['mongoid']['fields'].class == Array
            field_names =     workitem.fields['mongoid']['fields']
          else
            field_names.push  workitem.fields['mongoid']['fields'].to_s
          end

          ###create fields for mongoid request!
          fields = Array.new
          field_names.each do |one_field_name|
            fields.push workitem.fields[one_field_name]
          end

          #=============================================================================================================

          ###fill up Fields chech workitem_requests type
          workitem_requests = Array.new
          if    workitem.fields['mongoid']['workitems'].class == Hash
            workitem_requests =     workitem.fields['mongoid']['workitems']
            #TODO itt hash validacio kell!
          elsif workitem.fields['mongoid']['workitems'].class == String
            workitem_requests =     {
                workitem.fields['mongoid']['workitems'] => nil
            }
          else
            raise ArgumentError, "invalid workitem request data => must be a Hash or at least a String"
          end

          ###create fields for mongoid request!
          workitems = Array.new
          workitem_requests.each do |key,value|

            if value.nil?
              workitems.push workitem.__send__(key.to_s)
            else
              workitems.push workitem.__send__(key.to_s,value)
            end

          end

          #=============================================================================================================

          ###Merge the two data collection what need to be saved in mongo
          begin
            to_mongo_data = workitems + fields
          end

          i = 0
          to_mongo_data.each do |one_element_of_to_mongo_data|

            one_element_of_to_mongo_data = {i.to_s => one_element_of_to_mongo_data}
            i+=1

          end


          #=============================================================================================================

          exlogger "fields to mongoid:    "+fields.inspect
          exlogger "workitems to mongoid: "+workitems.inspect
          exlogger "merged, changed one:  "+to_mongo_data.inspect


          ###Create new model data
          mongoid_data = module_name.constantize.__send__(

              #method to be used
              workitem.fields['mongoid']['method'].to_s,

              #methods parameters
              *to_mongo_data
          )

          begin
            mongoid_data.save!
          rescue Exception
          end

          #=============================================================================================================

          ###removing unused workitem field! => spawner
          workitem.fields.delete('mongoid')

          #=============================================================================================================
        rescue Exception => ex
          workitem.fields['error_backtrace']=Hash.new if workitem.fields['error_backtrace'].nil?
          workitem.fields['error'] = true; workitem.fields['error_backtrace'][self.to_s.split('::').last]= ex
          ex.logger
        end; reply
      end

      def on_cancel

      end

      def on_reply

      end

    end
  end
end