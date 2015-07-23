class Follower < ActiveRecord::Base
  validates(:user_uuid, { presence: true })

  has_many :guru_followers
  has_many :gurus, { through: :guru_followers }

  class << self
    def is_following?(user_uuid, guruname)
      guru = Guru.find_by_username!(guruname)
      follower = Follower.find_by_user_uuid!(user_uuid)
      return true if GuruFollower.exists?({ guru: guru, follower: follower })

      false
    end
  end
end
