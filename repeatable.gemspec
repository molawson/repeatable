lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "repeatable/version"

Gem::Specification.new do |spec|
  spec.name = "repeatable"
  spec.version = Repeatable::VERSION
  spec.authors = ["Mo Lawson"]
  spec.email = ["mo@molawson.com"]

  spec.summary = "Describe recurring event schedules and calculate their occurrences"
  spec.description = "Ruby implementation of Martin Fowler's 'Recurring Events for Calendars' paper."
  spec.homepage = "https://github.com/molawson/repeatable"
  spec.license = "MIT"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sorbet-runtime"
end
