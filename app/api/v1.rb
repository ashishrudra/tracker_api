require "app/api/v1/gurus"
require "app/api/v1/presenters"

module GG
  module API
    module V1
      class Endpoints < Grape::API
        mount({ GG::API::V1::Gurus => :gurus })
      end
    end
  end
end
