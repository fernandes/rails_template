#########
# Home
#########

require_relative "../utils.rb"

after_bundle do
  route("root to: 'home#show'")

  create_file("app/controllers/home_controller.rb") do <<~EOF
    class HomeController < ApplicationController
      def show
      end
    end
  EOF
  end

  create_file("app/views/home/show.html.erb") do <<~EOF
    <h1 class="bg-red-500">Home#show</h1>
    <p>Find me in app/views/home/show.html.erb</p>

    <div data-controller="hello">
      foo
    </div>
  EOF
  end

  git add: "."
  git commit: "-m home"
end

do_tool_bundle

