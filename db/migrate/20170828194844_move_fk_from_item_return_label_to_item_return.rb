class MoveFkFromItemReturnLabelToItemReturn < ActiveRecord::Migration
  def change

  	add_column :item_returns, :item_return_label_id, :integer
  	add_index :item_returns, :item_return_label_id

  	count = 0
  	ItemReturnLabel.all.each do |label|
  	  ir = ItemReturn.find_by_id(label.item_return_id)
      if ir.nil?
        label.destroy
      else
  	    ir.item_return_label_id = label.id
  	    ir.save
  	    count = count + 1
      end
  	end
  	p "relationships changed: #{count}"

    count = 0
    OrderReturnRequest.where("created_at > ?", 30.days.ago).each do |orr|
      ir_arr = ReturnRequestItem.where(order_return_request_id: orr.id).map do |rri|
        ItemReturn.find_by_request_id(rri.id)
      end

      ir_arr.compact!
      if ir_arr.empty?
        # seriously broken orders
        next
      end
      labels = ir_arr.select {|ir| ir.item_return_label}

      # if we missing labels, then copy 1 label to the other item_returns
      if (labels.count > 0) && (labels.count < ir_arr.count)
        no_labels = ir_arr.select {|ir| ir.item_return_label.nil? }
        no_labels.each do |ir|
          ir.item_return_label = labels.first.item_return_label
          ir.save!
          count = count + 1
        end
      end

      p "labels duplicated: #{count}"
    end
  end
end
