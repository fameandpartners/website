class MigrateFacebookDataTableToSerializedAttribute < ActiveRecord::Migration
  def up
    add_column :spree_users, :facebook_data, :text
    drop_table :facebook_data
  end

  def down
    create_table :facebook_data do |t|
      t.integer :spree_user_id, index: true
      t.text :value

      t.timestamps
    end

    remove_column :spree_users, :facebook_data, :text
  end
end
