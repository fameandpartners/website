class AddTokenToSpreeWeddingAtelierEvents < ActiveRecord::Migration
  def change
    add_column :spree_wedding_atelier_events, :token, :string
  end
end
