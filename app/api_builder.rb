require "app/api"

module GG
  module API
    BUILDER = Rack::Builder.new do
      use(Sonoma::RequestId::Middleware)
      use(Sonoma::Logger::Middleware)
      use(Sonoma::Monitor::Middleware)
      run GG::API::Endpoints
    end
  end
end
