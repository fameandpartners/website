module Batcher
  module_function

  BATCH_ITEMS_THRESHOLD = 40  #number of line items to make a batch
  DELIVERY_DAYS_THRESHOLD = 14  #number of minimum

  PRODUCTS_TO_IGNORE = [
    'RETURN_INSURANCE',
    'Fabric Swatch - Heavy Georgette'
  ]

  def batch_line_items(line_items)
    count = 0

    line_items.each do |li|
      if batch_line_item(li)
        count += 1
      end
    end
    count
  end

  def batch_line_item(line_item)
    # feature flipper
    if Features.inactive?(:batching)
      return
    end
    # check to see if it's a valid product
    if PRODUCTS_TO_IGNORE.include?(line_item.product.name)
      return false
    end

    delivery_date = Orders::LineItemPresenter.new(line_item).projected_delivery_date

    if (delivery_date > (Time.now+DELIVERY_DAYS_THRESHOLD.days))

      #check to see if there's a batch_collection for this
      if bc = BatchCollection.where(batch_key: line_item.product.master.sku.downcase, status: 'open').first
        groom_batch_collection(bc)

        if bc.line_items.count < BATCH_ITEMS_THRESHOLD
          bc.line_items << line_item
          bc.save

          if bc.line_items.count == BATCH_ITEMS_THRESHOLD
            bc.status = 'closed'
            bc.save
          end

          return true
        end
      else  #this style don't have a batch yet, make one
        bc = BatchCollection.create(batch_key: line_item.product.master.sku.downcase, status: 'open')
        bc.line_items << line_item
      end
    end
    return false
  end

  def groom_all_batch_collections
    BatchCollection.where(status: 'open').each do |bc|
      groom_batch_collection(bc)
    end
  end

  # kick out line_items that are within 2 weeks of due-ness
  def groom_batch_collection(batch_collection)
    if batch_collection.status == 'open'
      batch_collection.batch_collection_line_items.each do |bcli|
        if (Time.now+DELIVERY_DAYS_THRESHOLD.days) > bcli.projected_delivery_date
          # this thing is within N days...release it to be made
          bcli.delete
        end
      end
    end
  end

  def check_last_n_minutes(n_minutes)
    start_time = Time.now - n_minutes.minutes
    lis = get_line_items_between(start_time, Time.now)
    batch_line_items(lis)
  end

  def get_line_items_between(start_time, end_time)
    orders = Spree::Order.where(completed_at: start_time..end_time, shipment_state: 'ready')
    orders = orders.select {|ord| ord.shipment&.shipped_at.nil? && ord.shipment&.tracking.nil?}

    lis = orders.map {|ord| ord.line_items}.flatten
    #if we ever do something crazy like a li being able to be in more than 1 batch_collection..change this code below
    # filter out all line_items that have been previously processed by batcher or refulfiller or shipped
    lis.select {|li| li.batch_collections.empty? && li.refulfill_status.nil? && li.line_item_update&.tracking_number.nil?}
  end

end