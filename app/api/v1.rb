require "app/api/v1/ambassadors"

module GA
  module API
    module V1
      class Endpoints < Grape::API
        mount({ GA::API::V1::Ambassadors => :ambassadors }) 
      end
    end
  end
end
