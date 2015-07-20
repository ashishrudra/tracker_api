require "app/api/v1"

module GG
  module API
    class Endpoints < Grape::API
      mount({ GG::API::V1::Endpoints => :v1 })
    end
  end
end
