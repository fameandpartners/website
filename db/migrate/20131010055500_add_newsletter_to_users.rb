class AddNewsletterToUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :newsletter, :bool
  end
end
