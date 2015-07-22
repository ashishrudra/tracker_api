class AddFieldsToGuruDeals < ActiveRecord::Migration
  def up
    add_column :guru_deals, :is_cover, :boolean, { default: false }
    add_column :guru_deals, :notes, :text
  end

  def down
    remove_column :guru_deals, :is_cover
    remove_column :guru_deals, :notes
  end
end
