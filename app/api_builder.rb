require "app/api"

module GG
  module API
    APP = Rack::Builder.new do
      use(Sonoma::RequestId::Middleware)
      use(Sonoma::Monitor::Middleware)
      run GG::API::Endpoints
    end

    BUILDER = Rack::Builder.new do
      run Rack::Cascade.new([Sonoma::LocalConfig::Frontend, APP])
    end
  end
end
