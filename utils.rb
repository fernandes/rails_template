def do_bundle
  if new_install?
    run_bundle
  else
    # Custom bundle command ensures dependencies are correctly installed
    Bundler.with_unbundled_env { run "bundle install" }
  end
end

def do_tool_bundle
  unless new_install?
    do_bundle
    run_after_bundle_callbacks
  end
end

def file_contains?(filename, string)
  File.foreach(filename).detect { |line| line.include?(string) }
end

def find_and_replace_in_file(file_name, old_content, new_content)
  text = File.read(file_name)
  new_contents = text.gsub(old_content, new_content)
  File.open(file_name, 'w') { |file| file.write new_contents }
end

def do_commit(message)
  run 'standardrb --fix'
  git add: "."
  git commit: " -m '#{message}' "
end

def create_bin(name, command = nil)
  create_file "bin/#{name}" do <<~EOF
    #!/usr/bin/env ruby
    APP_ROOT = File.expand_path('..', __dir__)
    Dir.chdir(APP_ROOT) do
      begin
        exec '#{command || name}'
      rescue Errno::ENOENT
        $stderr.puts "#{name} executable was not detected in the system."
        exit 1
      end
    end
  EOF
  end
  `chmod +x bin/#{name}`
end

def new_install?
  @_invocations[Rails::Generators::AppGenerator].include?("create_root")
end

