class CreateFollowers < ActiveRecord::Migration
  def up
    create_table :followers, { id: :uuid } do |t|
      t.uuid(:guru_id, { null: false })
      t.uuid(:user_uuid, { null: false })
      t.text(:username, { null: false })
    end
  end

  def down
    drop_table :followers
  end
end
