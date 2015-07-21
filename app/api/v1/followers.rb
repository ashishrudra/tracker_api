module GG
  module API
    module V1
      class Followers < Grape::API
        get "/:user_uuid/gurus" do
          follower = Follower.find_by_user_uuid!(params[:user_uuid])
          { gurus: follower.gurus.each do |guru|
            Presenters::GuruPresenter.new(guru).present
          end
           }
        end
      end
    end
  end
end
