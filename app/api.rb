require "app/api/v1"
require "app/errors"

module TA
  module API
    class Endpoints < Grape::API
      default_format :json

      mount({ TA::API::V1::Endpoints => "v1" })

      get "/ping" do
        { pong: TA.slogan }
      end
    end
  end
end
