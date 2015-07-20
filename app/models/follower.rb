class Follower < ActiveRecord::Base
  validates(:guru_id, { presence: true })
  validates(:user_uuid, { presence: true })
  validates(:username, { presence: true })

  belongs_to :guru
end
