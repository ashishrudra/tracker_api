module GG
  class << self
    def root
      @_root ||= File.expand_path("../../", __FILE__)
    end

    def env
      @_env ||= (ENV["RACK_ENV"] || "development")
    end

    def local_environment?
      %w(test development).include?(env)
    end

    def logger
      Sonoma::Logger.instance
    end

    def slogan
      "SUDO IN YOUR FACE"
    end
  end
end
