class RemoveGuruIdFromFollowers < ActiveRecord::Migration
  def up
    remove_column :followers, :guru_id
  end

  def down
    add_column :followers, :guru_id, :uuid
  end
end
