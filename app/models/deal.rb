class Deal < ActiveRecord::Base
  validates(:deal_uuid, { presence: true })
  validates(:permalink, { presence: true })

  has_many :guru_deals
  has_many :gurus, { through: :guru_deals }
end
