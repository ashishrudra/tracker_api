class AddFieldsToGurus < ActiveRecord::Migration
  def up
    add_column :gurus, :avatar, :string
    add_column :gurus, :location, :string, :limit => 50
    add_column :gurus, :page_title, :string
    add_column :gurus, :writeup, :text
  end

  def down
    remove_column :gurus, :avatar
    remove_column :gurus, :location
    remove_column :gurus, :page_title
    remove_column :gurus, :writeup
  end
end
