
### connect to the database
## CONFIGURATION OPTIONS
#
# Mongoid currently supports the following configuration options, either
# provided in the mongoid.yml or programatically (defaults in parenthesis).
#
#    allow_dynamic_fields (true): When attributes are not defined as
#     fields but added to an object, they will get fields added for them dynamically and will get persisted. If set to false an error will get raised when attempting to set a value that has no field defined.
#                                                                                                                                                                                                                                                                         autocreate_indexes (false): When set to true Mongoid will attempt to create indexes each time a class is loaded. This is not recommended for any environment other than development or test.
#    identity_map_enabled (false): When set to true Mongoid will store
#     documents loaded from the database in the identity map by their ids,
#     so subsequent database queries for the same document in the same unit
#     of work do not hit the database. This is only for relation queries at
#     the moment. See the identity map documentation for more info.
#
#    include_root_in_json (false): When set to true mongoid will include the
#     name of the root document and the name of each association as the root
#     element when calling #to_json on a model.
#
# max_retries_on_connection_failure (0): If you would like Mongoid to retry
# operations if a Mongo::ConnectionFailure occurs you may specify this option
# in your config. Mongoid will retry the operation every half second up to the
# limit that is set. This is particularly useful when using replica sets.
#                                                                                                                                                                                                                                                                                                         parameterize_keys (true): Tells Mongoid to convert basic special characters in composite keys to SEO friendly substrings.
#                                                                                                                                                                                                                                                                                                                                                                                                                           persist_in_safe_mode (false): Tells Mongoid to perform all database operations in MongoDB's safe mode. This will cause the driver to double check operations and raise an error if they failed. Switching to true will be safe but will be a slight performance hit.
# preload_models (false): Tells Mongoid to preload all application model classes
# on each request in environments where classes are not being cached. This should
# only be used by applications that use single collection inheritance due to
# performance issues with enabling this.
#
# raise_not_found_error (true): Will raise a Mongoid::Errors::DocumentNotFound
#  when attempting to find a document by an id that doesnt exist. When set to
# false will only return nil for the same query.
# skip_version_check (false): If you are having issues authenticating against
# MongoHQ or MongoMachine because of access to the system collection being not
# allowed, set this to true.


#unless Application.environment == String.new

  unless Application.config['db'].nil?
    Application.config['mongoid']['mongoid']['development']['sessions']= Hash.new()
    Application.config['db'].each do |one_session_name,value|
      if Application.config['db'][one_session_name]['adapter'].downcase == "mongodb"
        Application.config['mongoid']['mongoid']['development']['sessions'][one_session_name]={
            'database' => value['params']['dbname'],
            'hosts' => Array.new.push(value['params']['host']+':'+value['params']['port'])
        }
      end
    end
  end

#end


puts Application.config['db'].inspect

### connect sessions
begin

  Mongoid.configure do |config|
    #config.options = { raise_not_found_error: true }
    config.sessions = Hash.new() #{"default"=>{"database"=>"db","hosts"=>["localhost:27017"]}}

    Application.config['mongoid']['mongoid']['development']['sessions'].each do |one_session,one_params|
      config.sessions[one_session]= one_params
    end

  end

rescue Exception => ex
  puts ex
end



#session= Mongoid.session("default")
#puts session.cluster.inspect #>inspect


### Require Mongoid parts
require_relative_directory File.join "mongoid","dsl"
require_relative_directory File.join "mongoid","models"
