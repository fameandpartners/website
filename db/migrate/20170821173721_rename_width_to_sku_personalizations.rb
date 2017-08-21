class RenameWidthToSkuPersonalizations < ActiveRecord::Migration
  def change
    rename_column :line_item_personalizations, :width, :sku
  end
end
