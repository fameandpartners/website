class AddFactoryToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :factory_id, :integer, references: :factories
  end
end
