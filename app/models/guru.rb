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
      deal_uuid = DealData.get_deal_uuid(params[:permalink])

      guru.deals << Deal.find_or_create_by!({ deal_uuid: deal_uuid,
                                              permalink: params[:permalink] })
    end

    def add_follower(params)
      guru = Guru.find_by_username!(params[:username])

      guru.followers << Follower.find_or_create_by!({ user_uuid: params[:follower_uuid],
                                                      username: params[:follower_username] })
    end
  end
end
