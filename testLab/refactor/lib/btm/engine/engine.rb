

### BTM startup!
begin
  class BTM
    class << self
      attr_accessor :startup
    end
  end

  BTM.startup = true if BTM.startup.nil?

  if BTM.startup
    begin


      ### Start BTM
      BTM.start!(
          {
              :name => Application.config['btm']['config']["btm"]["name"],
              :host => Application.config['btm']['config']["btm"]["host"],
              :port	=> Application.config['btm']['config']["btm"]["port"]
          }
      )
      BTM.startup=false
    rescue Exception => ex
      puts "An Exception happened when the BTM started to boot: #{ex}\n\n\treconnection after"
      i=3
      loop do
        puts "#{i} sec"
        sleep 1
        i-=1
        break if i == 0
      end
      retry

    end
  end
end
#=======================================================================================================================