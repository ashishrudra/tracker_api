$LOAD_PATH << File.dirname(__FILE__)

ENV["RACK_ENV"] ||= "development"

require "bundler/setup"
Bundler.setup(:default)

require "app/config"

require "app/ta"
Bundler.require(:default, TA.env.to_sym)

require 'virtus'
require 'faraday'
require 'faraday_middleware'
require 'equalizer'
require 'representable/json'
require 'oj'
require 'addressable/uri'
require 'forwardable'

support_directories = %w(lib config/initializers app/models)
support_directories.each do |directory|
  Dir["#{directory}/**/*.rb"].sort.each do |file|
    require file
  end
end
