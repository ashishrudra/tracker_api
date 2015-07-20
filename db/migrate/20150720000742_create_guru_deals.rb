class CreateGuruDeals < ActiveRecord::Migration
  def up
    create_table :guru_deals, { id: :uuid } do |t|
      t.uuid(:deal_id, { null: false })
      t.uuid(:guru_id, { null: false })
    end
  end

  def down
    drop_table :guru_deals
  end
end
