class Refulfiller

  def self.check_line_items_in_inventory(line_items)
    line_items.each do |li|
      check_line_item_in_inventory(li)
    end
  end


  # check to see if line item exists in the inventories
  # if it does mark the 3pl on the line_item
  def self.check_line_item_in_inventory(line_item)
    counter = 0

    upc = Orders::LineItemPresenter.new(line_item).global_sku&.id
    if ReturnInventoryItem.find_by_upc(upc)
      if line_item.order.shipping_address.country.name == 'United States'
        line_item.refulfill = 'bergen'
        counter += 1
      elsif line_item.order.shipping_address.country.name == 'Australia'
        line_item.refulfill = 'next'
        counter += 1
      end
      line_item.save
    end
    counter
  end

  def self.get_n_days_of_line_items(start_date, n_days)
    end_date = start_date.beginning_of_day + n_days.days
    orders = Spree::Order.where(completed_at: start_date..end_date)
    lis = orders.map {|ord| ord.line_items}.flatten
  end

  def self.get_line_items_between(start_date, end_date)


  end

end
