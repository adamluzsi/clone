#encoding: UTF-8
module REST
  class CLASS < Grape::API

    version 'v1',
            using: :header,
            vendor: 'APP'

    default_format :txt
    format :txt
    #format :xml
    #format :json


    resource :RESOURCE do

      desc ""
      params do
        #requires :id, type: Integer
        #optional :text, type: String, regexp: /^[a-z]+$/
        #group :media do
        #  requires :url
        #end
      end
      get do

      end


      desc ""
      post do

      end


      desc ""
      put do

      end


      desc ""
      delete do

      end


    end
  end
end







