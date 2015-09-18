#!/usr/bin/env rake

$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)

Dir.glob("./lib/tasks/*.rake").each { |r| import r }


task :environment do
  require "./initialize"
end

task :load_test_environment do
  ENV["RACK_ENV"] = "test"
  Rake::Task[:environment].invoke
end

task :load_test_tasks do
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
end

task :audit_dependencies do
  system("bundle-audit") || exit
end

task :update_gems  do
  require "sonoma-colorizer"
  Sonoma::Colorizer.status("Updating gems (this may take a bit)") do
    `bundle update`
  end
end

task({ prepare: [:update_gems] })
task({ test: [:load_test_environment, :load_test_tasks, :audit_dependencies] }) do
  Rake::Task["spec"].invoke
end
task({ default: [:prepare, :test] })
