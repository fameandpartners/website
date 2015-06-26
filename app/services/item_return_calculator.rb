class ItemReturnCalculator < EventSourcedRecord::Calculator
  events :item_return_events

  def advance_creation(event)

  end

  def advance_return_requested(event)
    @item_return

    # binding.pry
    # @item_return

    event.data.map do |k,v|
      @item_return.send("#{k}=", v)
    end

    # @item_return.order_number = event.order_number
  end

  def advance_receive_item(event)

    binding.pry
    @item_return
  end
end
