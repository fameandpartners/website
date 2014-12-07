class AddTokenToBridesmaidPartyMembers < ActiveRecord::Migration
  def change
    add_column :bridesmaid_party_members, :token, :string
  end
end
