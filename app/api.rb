require "app/api/v1"
require "app/errors"

module GG
  module API
    class Endpoints < Grape::API
      use(Sonoma::AuthenticationMiddleware) do |config|
        config[:authenticator] = lambda do |req|
          return true unless GG::Config.enabled?(:AUTHENTICATION)

          auth_data = req.env["HTTP_AUTHORIZATION"]
          return false unless auth_data

          auth_data.match(/GGV1 (?<client_id>.*)$/) do |match|
            return Client.find_by({ key: match[:client_id] })
          end

          false
        end
      end

      mount({ GG::API::V1::Endpoints => "gurus_api/v1" })

      get "/ping" do
        { pong: GG.slogan }
      end
    end
  end
end
