# -*- encoding : utf-8 -*-
module REST
  class API < Grape::API

    begin

      version 'v1.0.0',
              using: :header,
              vendor: 'APP'

      default_format :txt
      format :json
      content_type :txt,  "application/text"
      content_type :json, "application/json"

    end

    mount_subclasses
    #console_write_out_routes

  end
end
