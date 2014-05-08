class CreateEmailNotifications < ActiveRecord::Migration
  def change
    create_table :email_notifications do |t|
      t.references  :spree_user
      t.string      :code
      t.timestamps
    end
  end
end
