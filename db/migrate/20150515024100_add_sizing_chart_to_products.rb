class AddSizingChartToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :size_chart, :string, null: false, default: '2014'
  end
end
