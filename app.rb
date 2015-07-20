$LOAD_PATH << File.dirname(__FILE__)

ENV["RACK_ENV"] ||= "development"

require "bundler/setup"
Bundler.setup(:default)

require "app/ga"
Bundler.require(:default, GA.env.to_sym)

Sonoma::ActiveRecord.boot!({ root: GA.root, schema_format: :sql })

support_directories = %w(app/models config/initializers lib)
support_directories.each do |directory|
  Dir["#{directory}/**/*.rb"].sort.each do |file|
    require file
  end
end
