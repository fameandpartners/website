module Refulfiller
  module_function

  def check_line_items_in_inventory(line_items)
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
  def check_line_item_in_inventory(line_item)
    found = false

    if rii = ReturnInventoryItem.find_by_upc(upc)
      if line_item.order.shipping_address.country.name == 'United States'
        decrement_or_destroy_return_inventory_item(rii)
        line_item.refulfill = 'bergen'
        found = true
        line_item.save
      elsif line_item.order.shipping_address.country.name == 'Australia'
        decrement_or_destroy_return_inventory_item(rii)
        line_item.refulfill = 'next'
        found = true
        line_item.save
      end
    end
    found
  end

  def match_global_sku(line_item, upc)
    gs = Orders::LineItemPresenter.new(line_item).global_sku
    if gs&.id == upc
      return true
    else
      #do this check since global skus are jacked up and can't be trusted
      lookup = GlobalSku.where(
          style_number: gs.style_number,
          product_name: gs.product_name,
          size: gs.size,
          color_id: gs.color_id,
          customisation_id: gs.customisation_id,
          height_value: gs.height_value,
          product_id: gs.product_id
        )
      if lookup.empty?
        return false
      else
        return true
      end
    end
  end

  # unmark a lineitem for refulfillment, chose not to increment the inventory count
  # due possibility that inventory was refreshed, better to err on side of less inventory
  def unrefulfill_line_item(line_item_id)
    li = Spree::LineItem.find(line_item_id)
    li.refulfill = nil
    li.save
  end

  # if only 1 available remove item from table, otherwise decrement available count by 1
  def decrement_or_destroy_return_inventory_item(rii)
    if rii.available == 1
      rii.delete
    else
      rii.available -= 1
      rii.save
    end
  end

  def check_last_n_minutes(n_minutes)
    start_time = Time.now - n_minutes.minutes
    lis = get_line_items_between(start_time, Time.now)
    check_line_items_in_inventory(lis)
  end

  def get_n_days_of_line_items(start_date, n_days)
    end_date = start_date.beginning_of_day + n_days.days
    orders = Spree::Order.where(completed_at: start_date..end_date, shipment_state: 'ready')
    lis = orders.map {|ord| ord.line_items}.flatten
    check_line_items_in_inventory(lis)
  end

  def get_line_items_between(start_time, end_time)
    orders = Spree::Order.where(completed_at: start_time..end_time, shipment_state: 'ready')
    lis = orders.map {|ord| ord.line_items}.flatten
  end

end
