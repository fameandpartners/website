class AddCustomizationValuesToBridesmaidPartyMembers < ActiveRecord::Migration
  def change
    add_column :bridesmaid_party_members, :customization_value_ids, :string
    add_column :bridesmaid_party_members, :selected_product_status, :string
    add_column :bridesmaid_party_members, :wishlist_item_id,        :integer
  end
end
