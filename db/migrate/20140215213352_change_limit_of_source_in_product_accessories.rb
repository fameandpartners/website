class ChangeLimitOfSourceInProductAccessories < ActiveRecord::Migration
  def up
    change_column :product_accessories, :source, :string, limit: 512
  end

  def down
    change_column :product_accessories, :source, :string, limit: nil
  end
end
