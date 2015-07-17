require "app/api"

module GA
  module API
    BUILDER = Rack::Builder.new do
      use(Sonoma::RequestId::Middleware)
      use(Sonoma::Logger::Middleware)
      use(Sonoma::Monitor::Middleware)
      run GA::API::Endpoints
    end
  end
end
