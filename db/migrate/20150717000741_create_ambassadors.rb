class CreateAmbassadors < ActiveRecord::Migration
  def up
    create_table :ambassadors, { id: :uuid } do |t|
      t.timestamp(:created_at, { null: false })
      t.uuid(:customer_uuid, { null: false })
      t.text(:email, { null: false })
    end
  end

  def down
    drop_table :ambassadors
  end
end
