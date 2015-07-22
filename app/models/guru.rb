class Guru < ActiveRecord::Base
  validates(:user_uuid, { presence: true, uniqueness: true })
  validates(:username, { presence: true, uniqueness: true })

  has_many :guru_deals
  has_many :guru_followers
  has_many :deals, { through: :guru_deals }
  has_many :followers, { through: :guru_followers }

  class << self
    def add_deal(username, deal_params)
      guru = Guru.find_by_username!(username)
      permalink = DealHelper.get_permalink_from_uri(deal_params[:uri])
      deal_uuid = DealCatalogData.get_deal_uuid(permalink)

      deal = Deal.find_or_create_by!({ deal_uuid: deal_uuid, permalink: permalink })
      guru_deal_mapping = GuruDeal.find_or_create_by!({ guru: guru, deal: deal })
      guru_deal_mapping.update(deal_params.except(:uri))

      guru.reload
    end

    def update_deal(username, deal_uuid, update_params)
      guru = Guru.find_by_username!(username)
      deal = Deal.find_by_deal_uuid!(deal_uuid)
      if update_params[:is_cover]
        GuruDeal.where({ guru: guru }).update_all({ is_cover: false })
      end

      GuruDeal.where({ guru: guru, deal: deal }).update_all(update_params) # could have done this with nested where & joins

      guru.reload
    end

    def add_follower(username, follower_params)
      guru = Guru.find_by_username!(username)
      follower = Follower.find_or_create_by!(follower_params)
      GuruFollower.find_or_create_by!(guru: guru, follower: follower)

      guru.reload
    end
  end
end
