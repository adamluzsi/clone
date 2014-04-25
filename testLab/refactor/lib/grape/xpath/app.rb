#encoding: UTF-8
module REST
  class API < Grape::API

    ### format/version
    begin
      #version 'v1', using: :header, vendor: 'Travel'
      default_format :txt
      #format :txt
      #format :xml
      format :json
    end

    ### defaults
    begin
      ### exclude array
      exclude_list = [
          self
      ]
    end

    ### mount components
    begin
      Grape::API.classes.each do |component|
        if !exclude_list.include? component
          begin
            if component.class == Class
              mount component
            else
              mount component.constantize
            end
          end
        end
      end
    end

  end
end