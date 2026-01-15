# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Run RSpec tests"
task test: :spec

desc "Open an IRB console with the gem loaded"
task :console do
  require "irb"
  require "fotmob"
  ARGV.clear
  IRB.start
end
