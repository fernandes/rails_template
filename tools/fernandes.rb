# frozen_string_literal: true

#########
# My Config
#########

require_relative '../utils'

after_bundle do
  # creating the file once web must always be the first
  file 'Procfile.dev', force: true do
    <<~CODE
      web: bin/rails s -b 0.0.0.0
      vite: bin/vite dev
    CODE
  end

  inject_into_file 'config/database.yml', after: 'pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>' do
    <<-DB

  host: 127.0.0.1
  username: postgres
    DB
  end

  application %(config.hosts << ENV.fetch('CONFIG_HOSTS', ''))

  inject_into_file 'config/initializers/content_security_policy.rb', <<~'CODE'
    Rails.application.configure do
      config.content_security_policy do |policy|
        if Rails.env.development?
          policy.style_src :self, :unsafe_inline
          policy.script_src :self, :unsafe_eval, :unsafe_inline, :blob, "https://#{ENV['VITE_HMR_HOST']}"
          policy.connect_src :self, "wss://#{ENV['VITE_HMR_HOST']}"
        end
      end
    end
  CODE

  file 'app/javascript/css/development.css', <<~CODE
    @import 'tailwindcss/base';
    @import 'tailwindcss/components';
    @import 'tailwindcss/utilities';
  CODE

  file 'app/javascript/css/production.css', <<~CODE
  CODE

  remove_file 'vite.config.js'
  file 'vite.config.js', <<~CODE
    import { defineConfig } from 'vite'
    import StimulusHMR from 'vite-plugin-stimulus-hmr'
    import FullReload from 'vite-plugin-full-reload'
    import RubyPlugin from 'vite-plugin-ruby'

    export default defineConfig({
      plugins: [
        StimulusHMR(),
        FullReload(['config/routes.rb', 'app/views/**/*']),
        RubyPlugin(),
      ],
      server: {
        hmr: {
          host: `${process.env.VITE_HMR_HOST}`,
          clientPort: 443,
        },
      },
    })
  CODE

  git add: '.'
  git commit: "-m 'personal config'"
end

do_tool_bundle
