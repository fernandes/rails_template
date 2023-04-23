# My Template
require_relative "./utils.rb"

# Set tools as source path so the script can apply them
module Thor::Actions
  def source_paths
    [File.join(__dir__, "tools")]
  end
end

# template.rb must be applied only to new apps
unless new_install?
  puts "This template should be applied only to new rails installs"
  puts "You can apply individual tools that live inside `tools' folder"
  exit 1
end

# Apply each tool to the new app
def install_tool(tool)
  apply "#{tool}.rb"
end

git add: "."
git commit: "-m rails"

tools = [
  "vite",
  "tailwind",
  "hotwire",
  "home",
  "fernandes",
]
tools.each { |t| install_tool(t) }

