module GA
  module API
    module V1
      class Ambassadors < Grape::API
        get "/" do
          ambassadors = Ambassador.all

          { ambassadors: ambassadors.each do |ambassador|
            Presenters::AmbassadorPresenter.new(ambassador).present
          end
          }
        end

        get "/:username" do
          ambassador = Ambassador.find_by_username params[:username]
          Presenters::AmbassadorPresenter.new(ambassador).present
        end
      end
    end
  end
end
