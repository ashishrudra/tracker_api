class CreateGuruFollowers < ActiveRecord::Migration
  def up
    create_table :guru_followers, { id: :uuid } do |t|
      t.uuid(:follower_id, { null: false })
      t.uuid(:guru_id, { null: false })
    end
  end

  def down
    drop_table :guru_followers
  end
end
