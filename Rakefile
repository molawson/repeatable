require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "standard/rake"

task :sorbet do
  sh %(bundle exec srb tc)
end

task default: %i[spec sorbet standard]
