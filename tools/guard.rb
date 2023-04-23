#########
# Guard
#########

require_relative "../utils.rb"

if File.exists? 'Guardfile'
  puts 'Guardfile already exists, skipping guard setup'
  return
end

gem_group :development, :test do
  gem 'guard'
  gem 'guard-sorbet'
  gem 'guard-minitest'
  gem 'terminal-notifier-guard'
end

do_bundle

create_file 'Guardfile' do <<~EOF
  notification :terminal_notifier if /Darwin/.match?(\`uname\`)

  guard :minitest, spring: "bin/rails test" do
    watch(%r{^app/(.+)\.rb$})                               { |m| "test/\#{m[1]}_test.rb" }
    watch(%r{^app/controllers/application_controller\.rb$}) { 'test/controllers' }
    watch(%r{^app/controllers/(.+)_controller\.rb$})        { |m| "test/integration/\#{m[1]}_test.rb" }
    watch(%r{^app/views/(.+)_mailer/.+})                    { |m| "test/mailers/\#{m[1]}_mailer_test.rb" }
    watch(%r{^lib/(.+)\.rb$})                               { |m| "test/lib/\#{m[1]}_test.rb" }
    watch(%r{^test/.+_test\.rb$})
    watch(%r{^test/test_helper\.rb$}) { 'test' }
  end

  guard :sorbet do
    watch(/^.*.rb$/)
    watch(/^.*.rbi$/)
  end
  EOF
end

