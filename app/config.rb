require "app/ta"

module TA
  module Config
    ARRAY_VALUE = /^\[(?<array>.+)\]$/

    class NotFound < StandardError
      def initialize(name)
        @name = name
      end

      def to_s
        "No config for #{@name} found in ENV"
      end
    end

    @checked_in_file_cache = {}

    class << self
      attr_accessor :root

      def configure
        yield self
      end


      def data(name)
        env_config(name) || raise(NotFound, name)
      end

      private

      def env_config(name)
        value = ENV[name.to_s.upcase]
        value.to_s.match(ARRAY_VALUE) do |match|
          return match[:array].split(",")
        end
        value
      end
    end
  end
end

TA::Config.configure do |config|
  config.root = File.join(TA.root, "config")
end
