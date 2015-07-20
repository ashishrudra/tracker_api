class Guru < ActiveRecord::Base
  validates(:user_uuid, { presence: true, uniqueness: true })
  validates(:username, { presence: true, uniqueness: true })

  has_many :guru_deals
  has_many :followers
  has_many :deals, { through: :guru_deals }
end
