class DealSuggestion < ActiveRecord::Base
  validates(:ambassador_id, { presence: true })
  validates(:deal_uuid, { presence: true })

  has_one(:ambassador)
end
