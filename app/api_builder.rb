require "app/api"
require "rack/cors"

module TA
  module API
    APP = Rack::Builder.new do
      use Rack::Cors do
        allow do
          origins "*"
          resource "*", { headers: :any, methods: [:get, :post, :put, :options, :patch] }
        end
      end

      use(Sonoma::RequestId::Middleware)
      use(Sonoma::Monitor::Middleware)
      run TA::API::Endpoints
    end

    BUILDER = Rack::Builder.new do
      run Rack::Cascade.new([APP])
    end
  end
end
