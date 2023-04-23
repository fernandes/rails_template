#########
# Simple Cov
#########

require_relative "../utils.rb"

gem 'simplecov', require: false, group: :test
do_bundle

prepend_to_file 'test/test_helper.rb', <<~TEMPLATE
  
require 'simplecov'
SimpleCov.start

TEMPLATE

