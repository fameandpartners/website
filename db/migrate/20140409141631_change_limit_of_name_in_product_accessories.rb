class ChangeLimitOfNameInProductAccessories < ActiveRecord::Migration
  def up
    change_column :product_accessories, :name, :string, limit: 512
  end

  def down
    change_column :product_accessories, :name, :string, limit: nil
  end
end
