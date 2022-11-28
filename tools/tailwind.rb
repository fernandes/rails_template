#########
# Tailwind
#########

require_relative "../utils.rb"

after_bundle do
  run "yarn add -D tailwindcss @tailwindcss/ui @tailwindcss/forms @tailwindcss/typography @tailwindcss/aspect-ratio postcss autoprefixer"

  create_file "app/javascript/entrypoints/application.css" do <<~EOF
    @import 'tailwindcss/base';
    @import 'tailwindcss/components';
    @import 'tailwindcss/utilities';
  EOF
  end

  create_file "postcss.config.js" do <<~EOF
    module.exports = {
      plugins: {
        tailwindcss: {},
        autoprefixer: {},
      },
    }
  EOF
  end

  create_file "tailwind.config.js" do <<~EOF
    const defaultTheme = require('tailwindcss/defaultTheme')

    module.exports = {
      content: [
        './public/*.html',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js',
        './app/views/**/*.{erb,haml,html,slim}'
      ],
      theme: {
        extend: {
          fontFamily: {
            sans: ['Inter var', ...defaultTheme.fontFamily.sans],
          },
        },
      },
      plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/aspect-ratio'),
        require('@tailwindcss/typography'),
      ]
    }
  EOF
  end

  git add: "."
  git commit: "-m tailwind"
end

do_tool_bundle
