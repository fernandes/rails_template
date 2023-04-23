#########
# Hotwire
#########

require_relative "../utils.rb"

gem 'hotwire-rails'

after_bundle do
  run "yarn add @hotwired/turbo-rails @hotwired/stimulus"

  rails_command "hotwire:install"
  rails_command "turbo:install:redis"

  if File.exist?('config/vite.json')
    remove_file "app/javascript/controllers/index.js"
    create_file "app/javascript/controllers/index.js" do <<~EOF
      // Import and register all your controllers from the importmap under controllers/*
      import { application } from "~/controllers/application"

      // Eager load all controllers defined in the import map under controllers/**/*_controller
      import { registerControllers } from 'stimulus-vite-helpers'
      const controllers = import.meta.globEager('./**/*_controller.js')
      registerControllers(application, controllers)

      // Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
      // import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
      // lazyLoadControllersFrom("controllers", application)
    EOF
    end
  end

  git add: "."
  git commit: "-m hotwire"
end

do_tool_bundle

