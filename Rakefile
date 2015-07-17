#!/usr/bin/env rake

$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)

require "rubocop/rake_task"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ["--display-cop-names", "--fail-fast"]
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

Dir.glob("./lib/tasks/*.rake").each { |r| import r }

require "sonoma/active_record/database_tasks"

task :environment do
  require "./initialize"
end

task :load_test_environment do
  ENV["RACK_ENV"] = "test"
  Rake::Task[:environment].invoke
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
task({ test: [:load_test_environment, :spec, :rubocop, :audit_dependencies] })
task({ default: [:prepare, :test] })
