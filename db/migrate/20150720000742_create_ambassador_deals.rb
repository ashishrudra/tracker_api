class CreateAmbassadorDeals < ActiveRecord::Migration
  def up
    create_table :ambassador_deals, { id: :uuid } do |t|
      t.uuid(:deal_id, { null: false })
      t.uuid(:ambassador_id, { null: false })
    end
  end

  def down
    drop_table :ambassador_deals
  end
end
