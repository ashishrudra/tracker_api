require "app/api/v1/gurus"
require "app/api/v1/followers"
require "app/api/v1/presenters"
require "app/api/v1/helpers/error_handler"

module GG
  module API
    module V1
      class Endpoints < Grape::API
        helpers ErrorHandler
        CLIENT_ERRORS = [ActiveRecord::RecordInvalid, Grape::Exceptions::ValidationErrors]

        rescue_from(*CLIENT_ERRORS) do |error|
          ErrorHandler.respond(error, 400)
        end

        rescue_from(ActiveRecord::RecordNotFound) do |error|
          ErrorHandler.respond(error, 404)
        end

        rescue_from(StandardError) do |error|
          ErrorHandler.respond(error)
        end

        mount({ GG::API::V1::Gurus => :gurus })
        mount({ GG::API::V1::Followers => :followers })
      end
    end
  end
end
