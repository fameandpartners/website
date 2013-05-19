class AddAvatarToSpreeUsers < ActiveRecord::Migration
  def up
    change_table :spree_users do |t|
      t.has_attached_file :avatar
    end
  end

  def dowm
    change_table :spree_users do |t|
      t.drop_attached_file :avatar
    end
  end
end
