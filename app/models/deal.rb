class Deal < ActiveRecord::Base
  validates(:deal_uuid, { presence: true })
  validates(:permalink, { presence: true })

  has_many :ambassador_deals
  has_many :ambassadors, { through: :ambassador_deals }
end
