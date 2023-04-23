#########
# Sorbet
#########

require_relative "../utils.rb"

gem_group :development, :test do
  gem 'sorbet'
end

gem 'sorbet-runtime'
gem 'sorbet-rails'
do_bundle

create_file 'bin/sorbet_generate' do <<~SH
    #!/usr/bin/env bash
    set -euo pipefail

    bundle exec rake rails_rbi:all
    bundle exec srb rbi hidden-definitions
    bundle exec srb rbi suggest-typed
  SH
end
`chmod +x bin/sorbet_generate`

inject_into_file '.gitignore' do <<~GITIGNORE

    sorbet/rbi/hidden-definitions/errors.txt
  GITIGNORE
end

system({'SRB_YES' => "1"}, 'srb init')
system('bin/sorbet_generate')

