class CreateFacebookData < ActiveRecord::Migration
  def change
    create_table :facebook_data do |t|
      t.integer :spree_user_id
      t.text :value

      t.timestamps
    end
  end
end
