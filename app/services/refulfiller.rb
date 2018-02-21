class Refulfiller

  def self.check_line_items_in_inventory(line_items)
    # remove this
    start_date = Time.now - 2.months
    line_items = get_n_days_of_line_items(start_date, 5)

    count = 0
    line_items.each do |li|
      if check_line_item_in_inventory(li)
        count += 1
      end
    end
    count
  end

  # check to see if line item exists in the inventories
  # if it does mark the 3pl on the line_item
  def self.check_line_item_in_inventory(line_item)
    found = false
    upc = Orders::LineItemPresenter.new(line_item).global_sku&.id
    if rii = ReturnInventoryItem.find_by_upc(upc)
      if line_item.order.shipping_address.country.name == 'United States'
        decrement_or_destroy_return_inventory_item(rii)
        line_item.refulfill = 'bergen'
        found = true
      elsif line_item.order.shipping_address.country.name == 'Australia'
        decrement_or_destroy_return_inventory_item(rii)
        line_item.refulfill = 'next'
        found = true
      end
      line_item.save
    end
    found
  end

  # unmark a lineitem for refulfillment, chose not to increment the inventory count
  # due possibility that inventory was refreshed, better to err on side of less inventory
  def self.unrefulfill_line_item(line_item_id)
    li = Spree::LineItem.find(line_item_id)
    li.refulfill = nil
    li.save
  end

  # if only 1 available remove item from table, otherwise decrement available count by 1
  def self.decrement_or_destroy_return_inventory_item(rii)
    if rii.available == 1
      rii.delete
    else
      rii.available -= 1
      rii.save
    end
  end

  def self.check_last_n_minutes(n_minutes)
    start_time = Time.now - n_minutes
    get_line_items_between(start_time, Time.now)
  end

  def self.get_n_days_of_line_items(start_date, n_days)
    end_date = start_date.beginning_of_day + n_days.days
    orders = Spree::Order.where(completed_at: start_date..end_date, shipment_state: nil)
    lis = orders.map {|ord| ord.line_items}.flatten
  end

  def self.get_line_items_between(start_time, end_time)
    orders = Spree::Order.where(completed_at: start_time..end_time, shipment_state: nil)
    lis = orders.map {|ord| ord.line_items}.flatten
  end

end
