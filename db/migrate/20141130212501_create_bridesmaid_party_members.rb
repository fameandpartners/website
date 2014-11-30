class CreateBridesmaidPartyMembers < ActiveRecord::Migration
  def up
    create_table :bridesmaid_party_members do |t|
      t.integer :event_id
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.integer :variant_id
      t.integer :size
      t.integer :color_id
    end
  end

  def down
    drop_table :bridesmaid_party_members
  end
end
