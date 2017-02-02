require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'repeatable'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
