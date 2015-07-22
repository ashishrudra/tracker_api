module GG
  module API
    module V1
      class Followers < Grape::API
        DEALS_LIMIT = 20.freeze

        get "/:userUuid/gurus" do
          follower = Follower.find_by_user_uuid!(params[:userUuid])

          { gurus: follower.gurus.map { |guru| Presenters::GuruPresenter.new(guru).present } }
        end

        get "/:userUuid/deals" do
          follower = Follower.includes(:gurus).find_by_user_uuid!(params[:userUuid])

          deals = follower.gurus.map do |guru|
            guru.deals.map { |deal| Presenters::DealPresenter.new(deal, guru).present }
          end.flatten.sample(DEALS_LIMIT)

          { deals: deals }
        end
      end
    end
  end
end
