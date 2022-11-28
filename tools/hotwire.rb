#########
# Hotwire
#########

require_relative "../utils.rb"

gem 'hotwire-rails'

after_bundle do
  run "yarn add @hotwired/turbo-rails @hotwired/stimulus"

  rails_command "hotwire:install"
  rails_command "turbo:install:redis"

  git add: "."
  git commit: "-m hotwire"
end

do_tool_bundle

