class RemoveUsernameFromFollowers < ActiveRecord::Migration
  def up
    remove_column :followers, :username
  end

  def down
    add_column :followers, :username, :text
  end
end
