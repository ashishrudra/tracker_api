class GuruDeal < ActiveRecord::Base
  validates(:guru_id, { presence: true })
  validates(:deal_id, { presence: true })

  belongs_to :guru
  belongs_to :deal
end
