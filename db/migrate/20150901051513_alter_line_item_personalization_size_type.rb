class AlterLineItemPersonalizationSizeType < ActiveRecord::Migration
  def change
    change_column :line_item_personalizations, :size, :string
  end
end
