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
          Ambassador.find params[:username]
        end
      end
    end
  end
end
