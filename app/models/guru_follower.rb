class GuruFollower < ActiveRecord::Base
  validates(:guru_id, { presence: true })
  validates(:follower_id, { presence: true })

  belongs_to :guru
  belongs_to :follower
end
