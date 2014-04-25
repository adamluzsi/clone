require_relative File.join '..','..','..','mongoid.rb'
module REST
  class Models < Grape::API
    ### This is a plugin for Mongoid
    ### models rest layer generate

    ### include to tmp vendors
    begin
      include REST::Vendors::SPEC
    rescue Exception
    end

    begin
      #version 'v1', using: :header, vendor: 'Travel'
      #default_format :txt
      #format :txt
      #format :xml
      #format :json
    end

    ### generate rest control layer for Mongoid
    begin
      def self.generate_rest_call(hash)
        crud_helper_model = Mongoid::ExtraDSL
        resource hash[:target_model].convert_model_name.to_sym do

          desc "read #{hash[:target_model].convert_model_name} record by: \n"+
               "if no params         #> return all,\n"+
               "if _id given         #> return that record,\n"+
               "if parent_id given   #> return all child,\n"+
               "if no id only params #> return array of matches"
          params do

            [:parent_id, :parentid, (hash[:parent_model].convert_model_name.to_s+'_id').to_sym ].each do |one_element|
              optional one_element, :type => String, :desc => "use in case with embeds models"
            end
            optional :id,             :type => String, :desc => "used for search with id"
            optional :db_page_limit,  :type => String, :desc => "you can set page limit"
            optional :db_page_number, :type => String, :desc => "you can set page number"
            hash[:target_model].properties.each do |field_name,type|
              #requires field_name.to_sym, type: type ,desc: "field name ~> /#{field_name}/"
              optional field_name.to_sym, type: type ,desc: "field name ~> /#{field_name}/"
            end

          end
          get do
            #error!('Unauthorized', 401) unless env['HTTP_SECRET_PASSWORD'] == 'swordfish'
            crud_helper_model.read(hash[:target_model],hash[:parent_model],hash[:relation_type],params)
          end

          desc "create #{hash[:target_model].convert_model_name} data by params\nreturn #> Boolean"
          params do
            hash[:target_model].properties.each do |field_name,type|
              optional field_name.to_sym, type: type ,desc: "field name ~> /#{field_name}/"
            end
          end
          post do
            #error!('Unauthorized', 401) unless env['HTTP_SECRET_PASSWORD'] == 'swordfish'
            crud_helper_model.create(hash[:target_model],hash[:parent_model],hash[:relation_type],params)
          end

          desc "update #{hash[:target_model].convert_model_name} data by params\nreturn #> Boolean"
          params do
            optional :id, type: String ,desc: "in real this is required,because it's a key element to find the target object in the database"
            hash[:target_model].properties.each do |field_name,type|
              if field_name.to_s != '_id'
                optional field_name.to_sym, type: type ,desc: "field name ~> /#{field_name}/"
              end
            end
          end
          put do
            #error!('Unauthorized', 401) unless env['HTTP_SECRET_PASSWORD'] == 'swordfish'
            crud_helper_model.update(hash[:target_model],hash[:parent_model],hash[:relation_type],params)
          end

          desc "delete #{hash[:target_model].convert_model_name} data by params\nreturn #> Boolean"
          params do
            hash[:target_model].properties.each do |field_name,type|
              optional field_name.to_sym, type: type ,desc: "field name ~> /#{field_name}/"
            end
          end
          delete do
            #error!('Unauthorized', 401) unless env['HTTP_SECRET_PASSWORD'] == 'swordfish'
            crud_helper_model.delete(hash[:target_model],hash[:parent_model],hash[:relation_type],params)
          end


        end
      end
    end

    ### dynamic rest calls build protocol
    begin
      Mongoid::Document.classes.each do |target_model_name|

        ### skip banned model
        begin
          if Mongoid::Banned::Models.list.include? target_model_name.to_s
            next
          end
        end

        ### defaults
        begin
          target_model_name=  target_model_name.constantize
        end

        ### generate methods by collection embed property
        begin
          if !target_model_name.parents.nil?

            ### case when there are parents to be marked
            begin
              target_model_name.parents.each do |one_parent_underscore|

                input_property=     Hash.new()
                input_property[:target_model] = target_model_name
                input_property[:parent_model] = one_parent_underscore.convert_model_name

                resource one_parent_underscore.to_s.to_sym do
                  generate_rest_call(input_property)
                end

              end
            end

          else

            ### case when there is no parent so it's a main collection
            begin
              input_property=Hash.new()
              input_property[:target_model] = target_model_name
              generate_rest_call(input_property)
            end

          end
        end

        ### check for references for after build
        begin
          if !target_model_name.references.nil?

            ### case when there are parents to be marked
            begin
              target_model_name.references.each do |one_reference_underscore|

                ### Hash reset
                input_property= Hash.new
                input_property[:target_model] = target_model_name
                input_property[:parent_model] = one_reference_underscore.convert_model_name
                resource one_reference_underscore.to_s.to_sym do
                  generate_rest_call(input_property)
                end

              end
            end

          end
        end

      end
    end

  end
end