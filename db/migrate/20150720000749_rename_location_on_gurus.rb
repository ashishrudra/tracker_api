class RenameLocationOnGurus < ActiveRecord::Migration
  def up
    rename_column :gurus, :location, :place
  end

  def down
    rename_column :gurus, :place, :location
  end
end
