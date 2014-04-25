
### Load the blather extraDSL
require_relative_directory File.join "blather","dsl"

### Load the blather Snippet Vendors!
require_relative_directory File.join "blather","vendors"

### Fire up Blather Engine
XMPP::Client.start
