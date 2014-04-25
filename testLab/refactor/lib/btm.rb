
### Load the participants
require_relative_directory File.join "btm","participants"

### Start up the BTM engine
require_relative_directory File.join "btm","engine"

### Register Participants in the system
require_relative_directory File.join "btm","register"

### Load up the process definitions
require_relative_directory File.join "btm","definitions"