class CreateDeals < ActiveRecord::Migration
  def up
    create_table :deals, { id: :uuid } do |t|
      t.timestamp(:created_at, { null: false })
      t.text(:permalink, { null: false })
      t.uuid(:deal_uuid, { null: false })
    end
  end

  def down
    drop_table :deals
  end
end
