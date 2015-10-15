class AddFactoryFaultToItemReturn < ActiveRecord::Migration
  def change
    add_column :item_returns, :factory_fault, :boolean
  end
end
