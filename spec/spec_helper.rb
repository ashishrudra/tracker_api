ENV["RACK_ENV"] = "test"

require "webmock/rspec"
require "rack/test"

require "factory_girl"
FactoryGirl.definition_file_paths = %w(./spec/factories)
FactoryGirl.find_definitions

require "./app"
Sonoma::ActiveRecord.maintain_test_schema!
require "database_cleaner"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include UUIDHelper

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
