class Follower < ActiveRecord::Base
  validates(:user_uuid, { presence: true })

  has_many :guru_followers
  has_many :gurus, { through: :guru_followers }
end
