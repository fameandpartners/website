class AddBarcodeToLabel < ActiveRecord::Migration
  def up
		add_column :item_return_labels, :barcode, :string
	end

	def down
		remove_column :item_return_labels, :barcode
	end
end
