require "app/gg"

module GG
  module Config
    ARRAY_VALUE = /^\[(?<array>.+)\]$/

    class NotFound < StandardError
      def initialize(name)
        @name = name
      end

      def to_s
        "No config for #{@name} found in ENV, an enabled LocalConfig or as a file."
      end
    end

    @checked_in_file_cache = {}

    class << self
      attr_accessor :root

      def configure
        yield self
      end

      def enabled?(name)
        return (env_config(name) == "true") if ENV.key?(name.to_s.upcase)
        Sonoma::LocalConfig.enabled?(name.to_sym)
      end

      def file(name)
        checked_in_config(name) || raise(NotFound, name)
      end

      def data(name)
        env_config(name) || local_config(name) || raise(NotFound, name)
      end

      private

      def env_config(name)
        value = ENV[name.to_s.upcase]
        value.to_s.match(ARRAY_VALUE) do |match|
          return match[:array].split(",")
        end
        value
      end

      def local_config(name)
        Sonoma::LocalConfig.when_enabled(name.to_s) do |config|
          return config.data
        end
      end

      def checked_in_config(name)
        unless @checked_in_file_cache.key?(name)
          config_file = config_path(name)
          if config_file
            parsed_yml = YAML.load(ERB.new(IO.read(config_file)).result)
            @checked_in_file_cache[name] = dot_hashes(parsed_yml)
          end
        end
        @checked_in_file_cache[name]
      end

      def dot_hashes(element)
        case element
        when Array then element.collect { |item| dot_hashes(item) }
        when Hash then Sonoma::DottableHash.new(element)
        else
          element
        end
      end

      def config_path(name)
        yml_path = File.join(root, "#{name}.yml")
        return yml_path if File.exist?(yml_path)

        yml_erb_path = File.join(root, "#{name}.erb.yml")
        return yml_erb_path if File.exist?(yml_erb_path)
      end
    end
  end
end

GG::Config.configure do |config|
  config.root = File.join(GG.root, "config")
end
