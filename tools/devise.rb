#########
# Devise
#########

require_relative "../utils.rb"

gem "devise"

after_bundle do
  rails_command "generate devise:install"

  # We don't use rails_command here to avoid accidentally having RAILS_ENV=development as an attribute
  run "rails generate devise User first_name:string last_name:string"
  FileUtils.mkdir_p("app/controllers/users")

  create_file "app/controllers/users/devise_controller.rb", <<~END_CONTROLLER
  class Users::DeviseController < ApplicationController
    class Responder < ActionController::Responder
      def to_turbo_stream
        controller.render(options.merge(formats: :html))
      rescue ActionView::MissingTemplate => error
        if get?
          raise error
        elsif has_errors? && default_action
          render rendering_options.merge(formats: :html, status: :unprocessable_entity)
        else
          redirect_to navigation_location
        end
      end
    end

    self.responder = Responder
    respond_to :html, :turbo_stream
  end
  END_CONTROLLER

  inject_into_file 'config/initializers/devise.rb', after: "# frozen_string_literal: true\n" do <<~EOF
  class TurboFailureApp < Devise::FailureApp
    def respond
      if request_format == :turbo_stream
        redirect
      else
        super
      end
    end

    def skip_format?
      %w(html turbo_stream */*).include? request_format.to_s
    end
  end
    EOF
  end

  inject_into_file 'config/initializers/devise.rb', after: "# ==> Warden configuration\n" do <<~EOF
    config.warden do |manager|
      manager.failure_app = TurboFailureApp
    end
    EOF
  end

  # Update devise configs
  find_and_replace_in_file("config/initializers/devise.rb", "# config.parent_controller = 'DeviseController'", "config.parent_controller = 'Users::DeviseController'")
  # uncomment navigational_formats and add :turbo_stream
  find_and_replace_in_file("config/initializers/devise.rb", "# config.navigational_formats = ['*/*', :html]", "config.navigational_formats = ['*/*', :html, :turbo_stream]")
  # use get instead of delete
  find_and_replace_in_file("config/initializers/devise.rb", "config.sign_out_via = :delete", "config.sign_out_via = :get")

  git add: "."
  git commit: "-m devise"
end

do_tool_bundle
