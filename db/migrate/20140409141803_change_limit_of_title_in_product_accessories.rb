class ChangeLimitOfTitleInProductAccessories < ActiveRecord::Migration
  def up
    change_column :product_accessories, :title, :string, limit: 512
  end

  def down
    change_column :product_accessories, :title, :string, limit: nil
  end
end
