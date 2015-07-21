class Guru < ActiveRecord::Base
  validates(:user_uuid, { presence: true, uniqueness: true })
  validates(:username, { presence: true, uniqueness: true })

  has_many :guru_deals
  has_many :guru_followers
  has_many :deals, { through: :guru_deals }
  has_many :followers, { through: :guru_followers }

  class << self
    def add_deal(params)
      guru = Guru.find_by_username!(params[:username])
      permalink = DealHelper.get_permalink_from_uri(params[:dealUri])
      deal_uuid = DealCatalogData.get_deal_uuid(permalink)

      guru.deals << Deal.find_or_create_by!({ deal_uuid: deal_uuid,
                                              permalink: permalink
                                            })
    end

    def add_follower(username, follower_params)
      guru = Guru.find_by_username!(username)

      guru.followers << Follower.find_or_create_by!(follower_params)
    end
  end
end
