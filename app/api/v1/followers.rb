module GG
  module API
    module V1
      class Followers < Grape::API
        DEALS_LIMIT = 4.freeze
        RECOMMENDED_LIMIT = 8.freeze

        get "/:userUuid/gurus" do
          follower = Follower.find_by_user_uuid!(params[:userUuid])

          { gurus: follower.gurus.sort_by(&:followers_count).reverse!.map { |guru| Presenters::GuruPresenter.new(guru).present } }
        end

        get "/:userUuid/deals" do
          follower = Follower.includes(:gurus).find_by_user_uuid!(params[:userUuid])

          deals = follower.gurus.map do |guru|
            guru.deals.map { |deal| Presenters::DealPresenter.new(deal, guru).present }
          end.flatten.sample(DEALS_LIMIT)

          { deals: deals }
        end

        get "/:userUuid/following/:guruName" do
          { isFollowing: Follower.is_following?(params[:userUuid], params[:guruName])}
        end

        get "/:userUuid/recommended" do
          gurus = Guru.recommended(params[:userUuid])
          { gurus: gurus.take(RECOMMENDED_LIMIT).sort_by(&:followers_count).reverse!.map { |guru| Presenters::GuruPresenter.new(guru).present } }
        end
      end
    end
  end
end
