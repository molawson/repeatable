# typed: strict

if ENV["COVERAGE"] == "true"
  require "simplecov"
  require "simplecov_json_formatter"

  SimpleCov.start do
    SimpleCov.formatter SimpleCov::Formatter::JSONFormatter
    SimpleCov.add_filter "/spec/"
  end
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "repeatable"

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }
