module XMPP
  class API
    ### class var
    begin
      @@route_path    ||= Array.new.push(nil)
      @@route_version ||= "v0"
    end
    ### syntax sugar
    begin
      ### main class dsl
      begin
        class << self
          def version(version)
            if !version.nil?
              @@route_version= version.to_s
            end
          end
          def namespace(space,  &block)
            @@route_path.push space.to_s.downcase
            index_of_space= (@@route_path.count-1)
            yield
            @@route_path.delete_at index_of_space
            return true
          end
          def rout_path(join='.')
            return @@route_path.join(join)
          end

          def route(method, paths, options = {}, &block)

            ### generate method path
            begin
              full_path= rout_path('_')
              if !paths.nil?
                full_path+= '_'+paths.to_s
              end
            end

            ### generate name
            begin
              name_hash= Hash.new
              name_hash['method']=  method.to_s
              name_hash['path']=    full_path
              name_hash['version']= @@route_version
              method_name= XMPP.gen_name(name_hash)
            end

            ### generate new xmpp path/method
            begin
              XMPP::Call.create_singleton_method method_name, &block
            end

          end
          def head(paths = nil, options = {}, &block); route(:head, paths, options, &block) end
          def snippet(paths = nil, options = {}, &block); route(:snippet, paths, options, &block) end

          def self.inherited(subclass)
            @classes ||= Array.new
            @classes.push subclass.name.constantize
          end
          def self.classes
            @classes
          end
        end
      end
      ### sugar alias
      begin
        class << self
          alias_method :group, :namespace
          alias_method :resource, :namespace
          alias_method :resources, :namespace
          alias_method :segment, :namespace
        end
      end
    end
  end
end