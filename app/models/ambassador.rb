class Ambassador < ActiveRecord::Base
  validates(:user_uuid, { presence: true, uniqueness: true })
  validates(:username, { presence: true, uniqueness: true })
  validates(:email, { presence: true, case_sensitive: false })

  has_many :ambassador_deals
  has_many :followers
  has_many :deals, { through: :ambassador_deals }
end
