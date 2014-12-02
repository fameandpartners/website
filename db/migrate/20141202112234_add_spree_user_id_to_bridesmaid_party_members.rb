class AddSpreeUserIdToBridesmaidPartyMembers < ActiveRecord::Migration
  def change
    add_column :bridesmaid_party_members, :spree_user_id, :integer
  end
end
