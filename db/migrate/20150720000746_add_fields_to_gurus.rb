class AddFieldsToGurus < ActiveRecord::Migration
  def up
    add_column :gurus, :avatar, :text
    add_column :gurus, :location, :text
    add_column :gurus, :page_title, :text
  end

  def down
    remove_column :gurus, :avatar
    remove_column :gurus, :location
    remove_column :gurus, :page_title
  end
end
