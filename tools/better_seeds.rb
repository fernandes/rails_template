#########
# Better Seeds
#########

require_relative "../utils.rb"

file 'db/seeds.rb', <<-CODE
Dir[Rails.root.join('db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end
Dir[Rails.root.join('db', 'seeds', Rails.env, '*.rb')].sort.each do |seed|
  load seed
end
CODE

file 'db/seeds/01_settings.rb', <<-CODE
# all environments
CODE

file 'db/seeds/development/01_users.rb', <<-CODE
# development only
CODE

file 'db/seeds/production/01_users.rb', <<-CODE
# production only
CODE

