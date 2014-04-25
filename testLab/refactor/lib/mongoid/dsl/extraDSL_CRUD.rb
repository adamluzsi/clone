module Mongoid
  module ExtraDSL
    ###  Mongoid::ExtraDSL.CRUD_name(
    #         *models, #target , parent
    #         *param_hashTags,
    #         [optionable]relation_type_string
    #)
    class << self

      def input(*args)

        ### defaults
        begin

          relation_type_model = nil

          parent_model = nil
          target_model = nil

          models_array = Array.new
          params       = Hash.new
          pager        = Hash.new
          properties   = Hash.new

        end

        ### fill up defaults by argumens
        begin
          args.each do |argument|
            case argument.class.to_s.downcase

              when "class"
                models_array.push argument

              when "hash","hashie::mash"
                argument.each do |key,value|
                  case key.to_s.downcase

                    when "db_page_limit","db_page_number"
                      pager[key.to_s.downcase]= value

                    else
                      params[key]=value

                  end
                end

              when "string"
                begin
                  if argument.to_s.downcase.include?("mongoid::relations")
                    #argument=argument.split('::')
                    #2.times do
                    #  argument.shift()
                    #end
                    #argument=argument.join('::')
                    relation_type_model= argument
                  else
                    begin
                      if argument.constantize != Object
                        models_array.push argument.constantize
                      end
                    rescue NameError
                      relation_type_model= argument
                    end
                  end
                end

            end
          end
          if models_array.count <= 1
            target_model= models_array[0]
            models_array.shift()
          else

            target_model= models_array[0]
            models_array.shift()

            parent_model= models_array[0]
            models_array.shift()

          end
        end

        ### params sub key remove
        begin
          if !params['params'].nil?

            tmp_hash=Hash.new
            tmp_hash= params['params']
            params.delete 'params'
            tmp_hash.each do |key,value|
              params[key]= value
            end

          end
        end

        ### BSON::ObjectId convert in params
        begin
          tmp_hash= Hash.new
          params.each do |key,value|
            if key.to_s == '_id'
              tmp_hash[key]= Moped::BSON::ObjectId.from_string(value.to_s)
            end
            if key.to_s == 'id'
              tmp_hash['_id']= Moped::BSON::ObjectId.from_string(value.to_s)
              params.delete 'id'
            end
          end
          if tmp_hash != Hash.new
            tmp_hash.each do |key,value|
              params[key]= value
            end
          end
        end

        ### parent_id key search
        begin
          parent_id_key= "#{parent_model.convert_model_name.to_s.downcase}_id"
          parent_id_key= "parent_id" if parent_id_key=='_id'

          tmp_hash= Hash.new
          params.each do |key,value|
            case key.to_s.downcase
              when "parent_id","parentid",parent_id_key
                properties['parent_id']=value
              else
                tmp_hash[key]=value
            end
          end
          params= tmp_hash
        end

        ### params trim by banned elements
        begin
          Mongoid::Banned.list.each do |category,category_elements|
            case category

              when :ProtocolElements
                category_elements.each do |one_banned_global_key|
                  params.delete one_banned_global_key
                end

              else
                #nothing

            end
          end
        end

        ### generate model connection type
        begin
          begin
            relation_type_model ||= target_model.reverse_relation_connection_type(parent_model)
          rescue Exception
            relation_type_model ||= parent_model.relation_connection_type(target_model)
          end
        end

        ### return processed data as hash table
        begin
          return_hash= {
              :parent_model => parent_model,
              :target_model => target_model,
              :models       => models_array,
              :model_type   => relation_type_model,
              :params       => params,
              :pager        => pager,
              :properties   => properties
          }
          return return_hash
        end

      end

      def read(*args)

        ### defaults
        begin
          input_hash    = self.input(*args)
          parent_model  = input_hash[:parent_model]
          target_model  = input_hash[:target_model]
          model_type    = input_hash[:model_type]
          params        = input_hash[:params]
          pager         = input_hash[:pager]
          properties    = input_hash[:properties]
          return_object = nil
        end

        #puts args.inspect,""
        #puts input_hash.inspect,""

        ### processing
        begin
          case true

            when model_type.downcase.include?("none"),
                model_type.downcase.include?("self")
              begin
                if params.find_hashize == Hash.new
                  return_object= target_model._all
                elsif !params.find_hashize['_id'].nil?
                  return_object= target_model._find(params.find_hashize['_id'])
                else
                  return_object= target_model._where(params.find_hashize)
                end
              end

            when model_type.downcase.include?("embedded"),
                model_type.downcase.include?("referenced")
              begin
                if !properties['parent_id'].nil?
                  ### find embeds collection by parent_id
                  return_object= parent_model._find_by(
                      properties['parent_id']).__send__(target_model.convert_model_name)
                else
                  ### find by params
                  if !params['_id'].nil?
                    return_object= target_model._find_by(params.find_hashize)
                  elsif params.find_hashize == Hash.new
                    return_object= target_model._all(parent_model)
                  else
                    return_object= target_model._where(params.find_hashize)
                  end
                end
              end

          end
        end

        ### after limiting
        begin
          if pager != Hash.new && return_object.class == Mongoid::Criteria && !pager['db_page_limit'].nil?
            if pager['db_page_number'].nil?
              return_object= return_object.limit(pager['db_page_limit'])
            else
              return_object= return_object.limit(pager['db_page_limit'].to_i).offset(
                  (pager['db_page_number'].to_i * pager['db_page_limit'].to_i))
            end
          end
        end

        ### grape readable formating
        begin

          #if return_object.class == Mongoid::Criteria
          #  return_object= Array[*return_object]
          #end


          return return_object
        end

      end

      def create(*args)

        ### defaults
        begin
          input_hash    = self.input(*args)
          parent_model  = input_hash[:parent_model]
          target_model  = input_hash[:target_model]
          model_type    = input_hash[:model_type]
          params        = input_hash[:params]
          properties    = input_hash[:properties]
          return_key    = 'id'
          return_object = nil
        end

        ### params trim by banned elements
        begin
          Mongoid::Banned.list.each do |category,category_elements|
            case category

              when :Elements
                category_elements.each do |one_banned_global_key|
                  params.delete one_banned_global_key
                end

              when :ModelElements
                category_elements.each do |one_info_hash|
                  if one_info_hash.keys[0].to_s == target_model.to_s
                    params.delete one_info_hash.values[0]
                  end
                end

            end
          end
        end

        ### processing
        begin
          case true

            when model_type.downcase.include?("none"),
                model_type.downcase.include?("self")
                begin


                  new_data= target_model.new(params.new_hashize)

                  begin
                    new_data.save
                  rescue Exception
                    return_object= false
                  end

                  if return_object.nil?
                    return_object= new_data['_id']
                  end

                end

            when model_type.downcase.include?("embedded::many"),
                model_type.downcase.include?("referenced::many")
              begin
                parent= parent_model._find(properties['parent_id'])
                if params['_id'].nil?
                  parent.__send__(target_model.convert_model_name.to_s).push(
                      target_model.new((params.new_hashize)))
                else
                  parent.__send__(target_model.convert_model_name.to_s).push(
                      target_model._find((params.find_hashize['_id'])))
                end
                begin
                  parent.save!
                rescue Exception
                  return_object= false
                end

                if return_object.nil?
                  return_object= parent.__send__(target_model.convert_model_name.to_s).last['_id']
                end

              end

            when model_type.downcase.include?("embedded::one"),
                model_type.downcase.include?("referenced::one")
              begin
                parent= parent_model._find(properties['parent_id'])
                if params['_id'].nil?
                  parent.__send__("#{target_model.convert_model_name}=",
                                  target_model.new(params.new_hashize))
                else
                  parent.__send__("#{target_model.convert_model_name}=",
                                  target_model._find((params.find_hashize['_id'])))
                end

                begin
                  parent.save
                rescue Exception
                  return_object= false
                end

                if return_object.nil?
                  return_object=  parent.__send__(target_model.convert_model_name.to_s)['_id']
                end

              end

          end
        end

        ### return return_obj
        begin
          #return { return_key => return_object }
          return return_object

        end

      end

      def update(*args)

        ### defaults
        begin
          input_hash   = self.input(*args)
          parent_model = input_hash[:parent_model]
          target_model = input_hash[:target_model]
          model_type   = input_hash[:model_type]
          params       = input_hash[:params]
        end

        ### processing
        begin
          case true

            when false
              #do nothing

            else
              begin

                new_data= target_model._find(params['_id'])
                params.new_hashize.each do |key,value|
                  new_data[key]=value
                end
                new_data.save!

              end

          end
        end

      end

      def delete(*args)

        ### defaults
        begin
          input_hash   = self.input(*args)
          parent_model = input_hash[:parent_model]
          target_model = input_hash[:target_model]
          model_type   = input_hash[:model_type]
          params       = input_hash[:params]
        end

        ### processing
        begin
          case true

            when false
              #do nothing

            else
              ### embeds collections
              begin

                something_to_delete= target_model._find(params['_id'])
                something_to_delete.delete
                begin
                  something_to_delete.save
                rescue Exception
                  false
                end

              end

          end
        end

      end

    end
  end
end
