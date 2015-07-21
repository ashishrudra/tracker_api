module GG
  module API
    module V1
      class Followers < Grape::API
        get "/:userUuid/gurus" do
          follower = Follower.find_by_user_uuid!(params[:userUuid])

          { gurus: follower.gurus.map { |guru| Presenters::GuruPresenter.new(guru).present } }
        end
      end
    end
  end
end
