require "app/api/v1"

module GA
  module API
    class Endpoints < Grape::API
      mount({ GA::API::V1::Endpoints => :v1 })
    end
  end
end
