#########
# Standardrb
#########

require_relative "../utils.rb"

gem "standard", group: [:development, :test]
do_bundle
run 'standardrb --fix'

