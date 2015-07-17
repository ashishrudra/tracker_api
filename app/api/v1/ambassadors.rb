module GA
  module API
    module V1
      class Ambassadors < Grape::API
        get "/" do
          Ambassador.all
        end

        get "/:uuid" do
          Ambassador.find params[:uuid]
        end
      end
    end
  end
end
