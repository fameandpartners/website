class AddOrderToRevolutionPage < ActiveRecord::Migration
  def change
    add_column :revolution_pages, :product_order, :string
  end
end
