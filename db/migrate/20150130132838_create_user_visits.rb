class CreateUserVisits < ActiveRecord::Migration
  def change
    create_table :marketing_user_visits, force: true do |t|
      t.references  :spree_user
      t.string      :user_token, limit: 64
      t.integer     :visits, default: 0

      t.string      :utm_campaign
      t.string      :utm_source
      t.string      :utm_medium
      t.string      :utm_term
      t.string      :utm_content
      t.string      :referrer
    end

    add_index :marketing_user_visits, [:spree_user_id, :utm_campaign]
    add_index :marketing_user_visits, [:user_token,    :utm_campaign]
  end
end
