require "app/api"
require "rack/cors"

module GG
  module API
    APP = Rack::Builder.new do
      use Rack::Cors do
        allow do
          origins "*"
          resource "*", { headers: :any, methods: :get }
        end
      end

      use(Sonoma::RequestId::Middleware)
      use(Sonoma::Monitor::Middleware)
      run GG::API::Endpoints
    end

    BUILDER = Rack::Builder.new do
      run Rack::Cascade.new([Sonoma::LocalConfig::Frontend, APP])
    end
  end
end
