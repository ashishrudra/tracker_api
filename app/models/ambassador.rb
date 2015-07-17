class Ambassador < ActiveRecord::Base
  validates(:customer_uuid, { presence: true, uniqueness: true })
  validates(:email, { presence: true , case_sensitive: false })

  has_many(:deal_suggestions)
end
