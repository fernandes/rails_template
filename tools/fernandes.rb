#########
# My Config
#########

require_relative "../utils.rb"

after_bundle do
  gsub_file "Procfile.dev", "rails s", "rails s -b 0.0.0.0"

  inject_into_file "config/database.yml", after: 'pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>' do <<-EOF

  host: 127.0.0.1
  username: postgres
EOF
  end

  git add: "."
  git commit: "-m 'personal config'"
end

do_tool_bundle

