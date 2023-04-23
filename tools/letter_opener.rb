#########
# Letter Opener
#########

require_relative "../utils.rb"

gem "letter_opener_web", "~> 2.0", group: [:development, :test]

inject_into_file "config/routes.rb", after: "Rails.application.routes.draw do\n" do
  <<-RUBY
  # open sended email previews in the browser
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  RUBY
end

inject_into_file "config/environments/development.rb", after: "config.action_mailer.perform_caching = false\n" do
  <<-RUBY

  # just want to browse mails using the web interface and don't care about opening emails automatically
  config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.perform_deliveries = true
  RUBY
end

