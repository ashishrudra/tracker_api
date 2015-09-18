require "app/api/v1/presenters"
require "app/api/v1/projects"
require "app/api/v1/helpers/error_handler"

module TA
  module API
    module V1
      class Endpoints < Grape::API
        helpers ErrorHandler
        CLIENT_ERRORS = [ Grape::Exceptions::ValidationErrors]

        rescue_from(*CLIENT_ERRORS) do |error|
          ErrorHandler.respond(error, 400)
        end

        rescue_from(StandardError) do |error|
          ErrorHandler.respond(error)
        end

        mount({ TA::API::V1::Projects => :projects })
      end
    end
  end
end
