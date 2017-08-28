class MoveFkFromItemReturnLabelToItemReturn < ActiveRecord::Migration
  def change

  	add_column :item_returns, :item_return_label_id, :integer
  	add_index :item_returns, :item_return_label_id

  	count = 0
	ItemReturnLabel.all.each do |label|
	  ir = ItemReturn.find(label.item_return_id)
    if ir.nil
      label.destroy
    else
	    ir.item_return_label_id = label.id
	    ir.save
	    count = count + 1
    end
	end
	p "relationships changed: #{count}"
  end
end
