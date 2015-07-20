$LOAD_PATH << File.dirname(__FILE__)

ENV["RACK_ENV"] ||= "development"

require "bundler/setup"
Bundler.setup(:default)

require "app/config"

require "app/gg"
Bundler.require(:default, GG.env.to_sym)

require "config/initializers/010_dotenv.rb"

Sonoma::ActiveRecord.boot!({ root: GG.root, schema_format: :sql })

support_directories = %w(app/models config/initializers lib)
support_directories.each do |directory|
  Dir["#{directory}/**/*.rb"].sort.each do |file|
    require file
  end
end
