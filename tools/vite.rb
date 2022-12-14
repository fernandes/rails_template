#########
# Vite
#########

require_relative "../utils.rb"

gem "vite_rails"

after_bundle do
  run "bundle exec vite install"

  inject_into_file('vite.config.ts', "import FullReload from 'vite-plugin-full-reload'\n", after: %(from 'vite'\n))
  inject_into_file('vite.config.ts', "import StimulusHMR from 'vite-plugin-stimulus-hmr'\n", after: %(from 'vite'\n))
  inject_into_file('vite.config.ts', "\n    FullReload(['config/routes.rb', 'app/views/**/*']),", after: 'plugins: [')
  inject_into_file('vite.config.ts', "\n    StimulusHMR(),", after: 'plugins: [')

  run "yarn add vite-plugin-stimulus-hmr vite-plugin-full-reload stimulus-vite-helpers"

  remove_file "app/assets/stylesheets/application.css"

  append_to_file 'app/frontend/entrypoints/application.js', 'import "../controllers/index"'

  inside('app') do
    run 'mkdir -p javascript/entrypoints/'
    run 'mv frontend/entrypoints/application.js javascript/entrypoints/'
    run 'rm -rf frontend/entrypoints/'
  end

  inject_into_file "app/views/layouts/application.html.erb", before: "    <%= vite_client_tag %>" do <<-EOF
    <%= vite_stylesheet_tag "application", "data-turbo-track": "reload" %>
EOF
  end

  gsub_file "app/views/layouts/application.html.erb", '    <%= stylesheet_link_tag "application" %>', ''

  gsub_file "config/vite.json", '"sourceCodeDir": "app/frontend",', '"sourceCodeDir": "app/javascript",', verbose: true
      
  inject_into_file "config/vite.json", before: '    "publicOutputDir": "vite-dev"' do <<-EOF
    "host": "0.0.0.0",
EOF
  end

  git add: "."
  git commit: "-m vite"
end

do_tool_bundle

