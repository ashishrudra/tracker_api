require "app/api/v1/ambassadors"
require "app/api/v1/presenters"

module GA
  module API
    module V1
      class Endpoints < Grape::API
        mount({ GA::API::V1::Ambassadors => :ambassadors })
      end
    end
  end
end
