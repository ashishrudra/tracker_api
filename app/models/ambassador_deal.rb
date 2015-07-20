class AmbassadorDeal < ActiveRecord::Base
  validates(:ambassador_id, { presence: true })
  validates(:deal_id, { presence: true })

  belongs_to :ambassador
  belongs_to :deal
end
