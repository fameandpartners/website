class MigrateFacebookDataTableToSerializedAttribute < ActiveRecord::Migration
  def up
    drop_table :facebook_data
  end

  def down
    create_table :facebook_data do |t|
      t.integer :spree_user_id, index: true
      t.text :value

      t.timestamps
    end
  end
end
